// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Roles {
    struct Role {
        mapping(address => bool) bearer;
    }

    /**
     * @dev give an address access to this role
     */
    function add(Role storage role, address addr) internal {
        role.bearer[addr] = true;
    }

    /**
     * @dev remove an address' access to this role
     */
    function remove(Role storage role, address addr) internal {
        role.bearer[addr] = false;
    }

    /**
     * @dev check if an address has this role
     * // reverts
     */
    function check(Role storage role, address addr) internal view {
        require(has(role, addr));
    }

    /**
     * @dev check if an address has this role
     * @return bool
     */
    function has(Role storage role, address addr) internal view returns (bool) {
        return role.bearer[addr];
    }
}

contract RBAC {
    using Roles for Roles.Role;

    Roles.Role private admins;
    Roles.Role private intermediaries;
    Roles.Role private users;
    Roles.Role private merchants;

    struct Account {
        address addr;
        string role;
    }

    Account[] accounts;

    constructor() {
        admins.add(msg.sender);
    }

    function getAccount() public view returns (Account[] memory) {
        return accounts;
    }

    function addAccount(address _addr, string memory _role) public {
        accounts.push(Account(_addr, _role));
    }

    function userFunc() external onlyUser {}

    function adminFunc() external onlyAdmin {}

    function addAdmin(address _newAdmin) external onlyAdmin {
        accounts.push(Account(_newAdmin, "admin"));
        admins.add(_newAdmin);
    }

    function addUser(address _newUser) external onlyUser {
        accounts.push(Account(_newUser, "user"));
        users.add(_newUser);
    }

    function addIntermediaries(address _newIntermediaries)
        external
        onlyIntermediaries
    {
        accounts.push(Account(_newIntermediaries, "intermediaries"));
        intermediaries.add(_newIntermediaries);
    }

    function addMerchants(address _newMerchants) external onlyMerchants {
        accounts.push(Account(_newMerchants, "merchants"));
        merchants.add(_newMerchants);
    }

    modifier onlyAdmin() {
        require(admins.has(msg.sender) == true, "Must have admin role");
        _;
    }

    modifier onlyUser() {
        require(users.has(msg.sender) == true, "Must have user role");
        _;
    }

    modifier onlyIntermediaries() {
        require(
            intermediaries.has(msg.sender) == true,
            "Must have intermediaries role"
        );
        _;
    }

    modifier onlyMerchants() {
        require(merchants.has(msg.sender) == true, "Must have merchants role");
        _;
    }
}
