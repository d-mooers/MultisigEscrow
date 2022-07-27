// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import {console} from "forge-std/console.sol";
import {stdStorage, StdStorage, Test} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";

import {Utils} from "./utils/Utilities.sol";

import {ERC20PresetFixedSupply} from "openzeppelin-contracts/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol";

import {Escrow} from "../src/Escrow.sol";

contract BaseSetup is DSTest {
    Vm internal vm;
    Utils internal utils;
    address payable[] internal users;

    address internal alice;
    address internal bob;
    address internal tim;

    function setUp() public virtual {
        utils = new Utils();
        users = utils.createUsers(5);
        vm = utils.vm();
        alice = users[0];
        vm.label(alice, "Alice");
        bob = users[1];
        vm.label(bob, "Bob");
        tim = users[2];
        vm.label(tim, "Tim");
    }
}

contract ContractTest is BaseSetup {
    ERC20PresetFixedSupply escrowToken;
    Escrow escrow;
    uint cliff = block.timestamp + 365 days;

    function setUp() public override {
        BaseSetup.setUp();
        escrowToken = new ERC20PresetFixedSupply(
            "test",
            "t",
            2**256 - 1,
            tim
        );

        address[] memory signers = new address[](3);
        signers[0] = tim;
        signers[1] = alice;
        signers[2] = bob;
        escrow = new Escrow(signers, 3, alice, bob, cliff, address(escrowToken));
    }

    function contribute(uint256 amount) internal {
        vm.prank(tim);
        escrowToken.transfer(address(escrow), amount);
    }

    function claimAs(address claimer) internal returns (uint256 claimed) {
        vm.prank(claimer);
        claimed = escrow.claim();
    }

    function testAllowClaimFuzz(uint contributeAmount) public {
        contribute(contributeAmount);
        vm.warp(cliff);
        uint claimed_1 = claimAs(alice);
        uint claimed_2 = claimAs(bob);

        assert(claimed_1 == claimed_2);
    }

    function testRevertBeforeCliffFuzz(uint contributeAmount, uint time) public {
        contribute(contributeAmount);
        vm.startPrank(bob);
        if (time < cliff) {
            vm.warp(time);
            
            vm.expectRevert("cliff");
            escrow.claim();
        }
    }

    function testMaintainEqualClaimsFuzz(uint contributeAmount, uint8 contributionTimes) public {
        if (contributionTimes > contributeAmount) return;
        if (contributionTimes == 0) contributionTimes++;
        uint amount = contributeAmount / contributionTimes;
        uint claimed_1 = 0;
        uint claimed_2 = 0;
        vm.warp(cliff);
        for (uint8 i = 0; i < contributionTimes; i++) {
            contribute(amount);
            claimed_1 += claimAs(alice);
            if ((i % 3) == 0) {
                claimed_2 += claimAs(bob);
            }
        }
        claimed_1 += claimAs(alice);
        claimed_2 += claimAs(bob);

        assert(claimed_1 == claimed_2);
    }

    function testRevertOnNonBeneficiaryFuzz(uint256 amount, address claimer) public {
        if (claimer == bob || claimer == alice) return;
        vm.warp(cliff);
        contribute(amount);
        vm.startPrank(claimer);

        vm.expectRevert("Not a beneficiary");
        escrow.claim();
    }
}