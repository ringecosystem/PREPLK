pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {safeconsole} from "forge-std/safeconsole.sol";
import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";

import {PreParaLink} from "../src/PREPLK.sol";

contract Deploy is Script {
    address treasury = 0x05101B3856c803bd1B01F18eEa98C011fe88E3ea;

    modifier broadcast() {
        vm.startBroadcast();
        _;
        vm.stopBroadcast();
    }

    function run() public broadcast {
        safeconsole.log("Chain Id: ", block.chainid);
        address proxy =
            Upgrades.deployUUPSProxy("PREPLK.sol:PreParaLink", abi.encodeCall(PreParaLink.initialize, (treasury)));
        safeconsole.log("Proxy: ", proxy);
        safeconsole.log("Logic: ", Upgrades.getImplementationAddress(proxy));
    }
}
