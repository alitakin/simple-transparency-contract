// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FundingProject {
    struct Project {
        string name;
        address payable recipient;
        uint amount;
        bool isReleased;
    }

    address public owner;
    uint public projectCount = 0;
    mapping(uint => Project) public projects;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    // new project
    function addProject(
        string memory _name,
        address payable _recipient,
        uint _amount
    ) public onlyOwner {
        projects[projectCount] = Project(_name, _recipient, _amount, false);
        projectCount++;
    }

    // Releasing fund only after the project confirmation
    function releaseFunds(uint _projectId) public onlyOwner {
        Project storage project = projects[_projectId];
        require(!project.isReleased, "Funds already released");

        project.recipient.transfer(project.amount);
        project.isReleased = true;
    }

    //  receive crypto in the contract
    receive() external payable {}
}
