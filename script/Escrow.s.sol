// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Script.sol";
import { Escrow } from "../src/Escrow.sol";

contract DeployScript is Script {

    address signer_fabien = address(0x889DD99B5C23Bc5c2F975AB4853A14fCCAf12CE3);
    address signer_eric = address(0x86a66947d3FBDac7E82909500BD63AFa33576120);
    address signer_dylan = address(0x6c0d6Fba3bcdb224278474E8d524F19c6BB55850);

    address benificiary_dylan = address(0x63c079444e07D82d33399DE7D56d6E48740494c7);
    address benificiary_eric = address(0x4B4f60fEa759eEb2a3a0D4f48a69C651c89D7d18);
    address USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    uint cliff = block.timestamp + 365 days;


    function run() external {
        vm.startBroadcast();
        address[] memory signers = new address[](3);
        signers[0] = signer_fabien;
        signers[1] = signer_eric;
        signers[2] = signer_dylan;


        new Escrow(signers, 3, benificiary_dylan, benificiary_eric, cliff, USDC);

        vm.stopBroadcast();
    }
}