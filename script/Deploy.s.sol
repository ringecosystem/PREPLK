pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {safeconsole} from "forge-std/safeconsole.sol";
import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";
import {PreParaLink} from "../src/PREPLK.sol";

contract Deploy is Script {
    address public treasury;

    constructor(address _treasury) {
        require(_treasury != address(0), "Treasury address cannot be zero");
        treasury = _treasury;
    }

    modifier broadcast() {
        vm.startBroadcast();
        _;
        vm.stopBroadcast();
    }

    function run() public broadcast {
        safeconsole.log("Chain Id: ", block.chainid);

        // Deploy the UUPS Proxy with safety checks for address validation.
        address proxy = Upgrades.deployUUPSProxy(
            "PREPLK.sol:PreParaLink",
            abi.encodeCall(PreParaLink.initialize, (treasury))
        );

        safeconsole.log("Proxy Address: ", proxy);
        address logicAddress = Upgrades.getImplementationAddress(proxy);
        require(logicAddress != address(0), "Invalid logic address detected.");
        safeconsole.log("Logic Address: ", logicAddress);
    }
}
