// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ILFICertificationProcess {
    enum Phase {
        Registration,
        ProjectDevelopment,
        ChangingIntendedCertification,
        Audit,
        CertificationRulings,
        ReadyAudit,
        FinalAudit,
        VirtualSiteTour,
        ProjectsRegisteredPriorToSep2020,
        CertificationRulingAppealProcess,
        CostOfAppeal,
        Completed
    }

    enum AuditStatus {
        Ready,
        Final
    }

    struct Project {
        address teamLead;
        Phase currentPhase;
        AuditStatus auditStatus;
        uint256 registrationTimestamp;
        uint256 readyAuditTimestamp;
        uint256 finalAuditTimestamp;
    }

    mapping(address => Project) public projects;

    modifier onlyTeamLead() {
        require(msg.sender == projects[msg.sender].teamLead, "Only the team lead can perform this action.");
        _;
    }

    constructor() {
        // Initialize the contract with default values
    }

    function registerProject() external {
        require(projects[msg.sender].teamLead == address(0), "Project already registered.");
        projects[msg.sender].teamLead = msg.sender;
        projects[msg.sender].currentPhase = Phase.Registration;
        projects[msg.sender].registrationTimestamp = block.timestamp;
    }

    function advanceToNextPhase(Phase nextPhase) external onlyTeamLead {
        require(uint256(nextPhase) == uint256(projects[msg.sender].currentPhase) + 1, "Invalid phase transition.");
        projects[msg.sender].currentPhase = nextPhase;
        
        // Update timestamps for specific phases
        if (nextPhase == Phase.ReadyAudit) {
            projects[msg.sender].readyAuditTimestamp = block.timestamp;
        } else if (nextPhase == Phase.FinalAudit) {
            projects[msg.sender].finalAuditTimestamp = block.timestamp;
        }
        
        // Mark the project as completed when it reaches the final phase
        if (nextPhase == Phase.Completed) {
            projects[msg.sender].currentPhase = Phase.Completed;
        }
    }

    function updateAuditStatus(AuditStatus status) external onlyTeamLead {
        require(projects[msg.sender].currentPhase == Phase.Audit, "Audit status can only be updated during the Audit phase.");
        projects[msg.sender].auditStatus = status;
    }

    function getCurrentPhase() external view returns (Phase) {
        return projects[msg.sender].currentPhase;
    }

    function getAuditStatus() external view returns (AuditStatus) {
        require(projects[msg.sender].currentPhase == Phase.Audit, "Audit status is only applicable during the Audit phase.");
        return projects[msg.sender].auditStatus;
    }

    function getRegistrationTimestamp() external view returns (uint256) {
        return projects[msg.sender].registrationTimestamp;
    }

    function getReadyAuditTimestamp() external view returns (uint256) {
        return projects[msg.sender].readyAuditTimestamp;
    }

    function getFinalAuditTimestamp() external view returns (uint256) {
        return projects[msg.sender].finalAuditTimestamp;
    }
}

