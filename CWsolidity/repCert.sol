// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ILFICertification {
    address public owner; // Address of the contract owner (e.g., ILFI)

    enum CertificationStatus { Registered, InProgress, Ready, Certified, Appeal }
    struct Project {
        address teamLead;
        uint registrationDate;
        CertificationStatus status;
        uint fee;
    }

    mapping(address => Project) public projects;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }

    modifier projectRegistered(address projectAddress) {
        require(projects[projectAddress].status == CertificationStatus.Registered, "Project not registered");
        _;
    }

    function registerProject(address projectAddress, uint registrationFee) external onlyOwner {
        require(projects[projectAddress].status == CertificationStatus.Registered, "Project already registered");
        projects[projectAddress] = Project({
            teamLead: msg.sender,
            registrationDate: block.timestamp,
            status: CertificationStatus.Registered,
            fee: registrationFee
        });
    }

    function advanceToInProgress(address projectAddress) external onlyOwner projectRegistered(projectAddress) {
        require(projects[projectAddress].status == CertificationStatus.Registered, "Project not in Registered state");
        // Additional checks and updates can be performed here.
        projects[projectAddress].status = CertificationStatus.InProgress;
    }

    // More functions for different stages of the certification process (InProgress, Ready, Certified, Appeal) can be added.

    function updateProjectStatus(address projectAddress, CertificationStatus newStatus) external onlyOwner projectRegistered(projectAddress) {
        require(projects[projectAddress].status < newStatus, "Invalid status update");
        projects[projectAddress].status = newStatus;
    }
}

