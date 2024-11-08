// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20VotesUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/Ownable2StepUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract PreParaLink is
    Initializable,
    ERC20Upgradeable,
    ERC20PermitUpgradeable,
    ERC20VotesUpgradeable,
    Ownable2StepUpgradeable,
    UUPSUpgradeable,
    ReentrancyGuardUpgradeable
{
    /// @dev This event is emitted when the contract is initialized, marking the initial token distribution.
    event Initialized(address indexed owner, uint256 amount);

    /// @dev Multi-signature modifier to add additional access control to upgrades.
    modifier onlyUpgradeManager() {
        require(msg.sender == owner() || /* add multi-sig check logic here */, "Not authorized for upgrades");
        _;
    }

    // Overridden function to restrict access to upgrades with enhanced security
    function _authorizeUpgrade(address newImplementation) internal override onlyUpgradeManager {}

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address initialOwner) public initializer {
        __ERC20_init("Pre ParaLink", "PREPLK");
        __ERC20Permit_init("Pre ParaLink");
        __ERC20Votes_init();
        __Ownable_init(initialOwner);
        __UUPSUpgradeable_init();
        __ReentrancyGuard_init();

        uint256 initialSupply = 100_000 * 10 ** decimals();
        _mint(initialOwner, initialSupply);

        emit Initialized(initialOwner, initialSupply);
    }

    function transfer(address to, uint256 value) public override nonReentrant returns (bool) {
        return super.transfer(to, value);
    }

    function transferFrom(address from, address to, uint256 value) public override nonReentrant returns (bool) {
        return super.transferFrom(from, to, value);
    }

    function approve(address spender, uint256 value) public override returns (bool) {
        return super.approve(spender, value);
    }

    function clock() public view override returns (uint48) {
        return uint48(block.timestamp);
    }

    // solhint-disable-next-line func-name-mixedcase
    function CLOCK_MODE() public pure override returns (string memory) {
        return "mode=timestamp";
    }

    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256 value)
        internal
        override(ERC20Upgradeable, ERC20VotesUpgradeable)
    {
        super._update(from, to, value);
    }

    function nonces(address owner) public view override(ERC20PermitUpgradeable, NoncesUpgradeable) returns (uint256) {
        return super.nonces(owner);
    }
}
