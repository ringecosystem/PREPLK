pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {safeconsole} from "forge-std/safeconsole.sol";
import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";

import {PreParaLink} from "../src/PREPLK.sol";

contract Deploy is Script {
    address treasury = 0x0f14341A7f464320319025540E8Fe48Ad0fe5aec;

    modifier broadcast() {
        vm.startBroadcast();
        _;
        vm.stopBroadcast();
    }

    function run() public broadcast {
        address proxy =
            Upgrades.deployUUPSProxy("PREPLK.sol:PreParaLink", abi.encodeCall(PreParaLink.initialize, (treasury)));
        safeconsole.log("Proxy: ", proxy);
        safeconsole.log("Logic: ", Upgrades.getImplementationAddress(proxy));
    }
}
