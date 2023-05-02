// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    event TransferWithMetadata(
        address indexed from,
        address indexed to,
        uint256 value,
        string data
    );

    struct TxInfo {
        address sender;
        address to;
        uint256 amount;
        string data;
    }

    mapping(address => TxInfo[]) private TxInfos;

    constructor() ERC20("My Token", "MTK") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        // Mint 100 tokens to msg.sender
        // Similar to how
        // 1 dollar = 100 cents
        // 1 token = 1 * (10 ** decimals)
        _mint(msg.sender, 100000 * 10**uint256(decimals()));
    }

    function transferWithMetadata(
        address to,
        uint256 amount,
        string memory data
    ) public returns (bool) {
        require(transfer(to, amount * 10**uint256(decimals())), "Transfer failed");
        TxInfos[msg.sender].push(
            TxInfo({sender: msg.sender, to: to, amount: amount, data: data})
        );
        emit TransferWithMetadata(msg.sender, to, amount, data);
        return true;
    }

    function getTxInfos(uint256 _txindex)
        external
        view
        returns (TxInfo memory)
    {
        TxInfo storage txInfo = TxInfos[msg.sender][_txindex];
        return txInfo;
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    function burn(uint256 amount) public onlyRole(BURNER_ROLE) {
        _burn(msg.sender, amount);
    }

    function addTokenValue(address to, uint256 amount)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        _mint(to, amount);
    }

    function grantMinterRole(address account)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        _grantRole(MINTER_ROLE, account);
    }

    function revokeMinterRole(address account)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        _revokeRole(MINTER_ROLE, account);
    }

    function grantBurnerRole(address account)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        _grantRole(BURNER_ROLE, account);
    }

    function revokeBurnerRole(address account)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        _revokeRole(BURNER_ROLE, account);
    }
}
