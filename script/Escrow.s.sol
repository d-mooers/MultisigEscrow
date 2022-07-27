// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Script.sol";
import { Escrow } from "../src/Escrow.sol";

contract DeployScript is Script {

    address s1 = address(0x6c0d6Fba3bcdb224278474E8d524F19c6BB55850);
    address ben1 = address(0x6c0d6Fba3bcdb224278474E8d524F19c6BB55850);
    address ben2 = address(0xCD943EE26221AC3e6e7f3e38598F2b08BAEA87DD);
    address USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    uint cliff = block.timestamp + 365 days;


    function run() external {
        vm.startBroadcast();
        address[] memory signers = new address[](1);
        signers[0] = s1;

        new Escrow(signers, 1, ben1, ben2, cliff, USDC);

        vm.stopBroadcast();
    }
}