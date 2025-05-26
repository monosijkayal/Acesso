// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract VeriLock {
    address public admin;
    mapping(address => bool) public isKYCApproved;
    bool public isPaused;

    event UserApproved(address indexed user);
    event UserRevoked(address indexed user);
    event ContractPaused(bool paused);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    modifier onlyKYCApproved() {
        require(isKYCApproved[msg.sender], "KYC not completed");
        _;
    }

    modifier whenNotPaused() {
        require(!isPaused, "Contract is paused");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    // Admin adds KYC-approved user
    function approveUser(address user) external onlyAdmin {
        isKYCApproved[user] = true;
        emit UserApproved(user);
    }

    // Admin removes KYC-approved user
    function revokeUser(address user) external onlyAdmin {
        isKYCApproved[user] = false;
        emit UserRevoked(user);
    }

    // Admin can pause the contract
    function pause(bool _paused) external onlyAdmin {
        isPaused = _paused;
        emit ContractPaused(_paused);
    }

// Only verified users can access this function
function accessRestrictedFeature() external view onlyKYCApproved whenNotPaused returns (string memory) {
    return "Welcome, verified user! You may access this feature.";
}
    // Public info
    function checkKYCStatus(address user) external view returns (bool) {
        return isKYCApproved[user];
    }

    // Admin transfer (in case you want to change the admin later)
    function transferAdmin(address newAdmin) external onlyAdmin {
        require(newAdmin != address(0), "Invalid address");
        admin = newAdmin;
    }
}

