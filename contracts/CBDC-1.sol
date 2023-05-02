// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AuthorityBasedContract {
    
    address public superAdmin;
    mapping(address => bool) public intermediaries;
    mapping(address => bool) public users;
    
    event IntermediaryRegistered(address indexed intermediary);
    event UserRegistered(address indexed user);
    event Transaction(address indexed from, address indexed to, string description, uint256 amount);
    
    constructor() {
        superAdmin = msg.sender;
    }
    
    modifier onlySuperAdmin() {
        require(msg.sender == superAdmin, "Only super admin can perform this action");
        _;
    }
    
    modifier onlyIntermediary() {
        require(intermediaries[msg.sender] == true, "Only intermediaries can perform this action");
        _;
    }
    
    modifier onlyUser() {
        require(users[msg.sender] == true, "Only users can perform this action");
        _;
    }
    
    function registerIntermediary(address intermediaryAddress) public onlySuperAdmin {
        intermediaries[intermediaryAddress] = true;
        emit IntermediaryRegistered(intermediaryAddress);
    }
    
    function registerUser(address userAddress) public onlyIntermediary {
        users[userAddress] = true;
        emit UserRegistered(userAddress);
    }
    
    function transfer(address from, address to, string memory description, uint256 amount) public onlyIntermediary {
        require(users[from] == true && (users[to] == true || intermediaries[to] == true), "Invalid user/intermediary address");
        require(from != to, "Cannot transfer to the same address");
        emit Transaction(from, to, description, amount);
    }
    
    function merchantToUser(address userAddress, string memory description, uint256 amount) public onlyUser {
        require(users[userAddress] == true, "Invalid user address");
        emit Transaction(msg.sender, userAddress, description, amount);
    }
}