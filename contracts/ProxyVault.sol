// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ProxyVault {

    address public owner;
    address public oracle;

    bool public amlApproved;

    constructor(address _owner, address _oracle) {
        owner = _owner;
        oracle = _oracle;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    modifier onlyOracle() {
        require(msg.sender == oracle, "not oracle");
        _;
    }

    receive() external payable {}

    function deposit() external payable {}

    function setAMLApproved(bool approved) external onlyOracle {
        amlApproved = approved;
    }

    function withdraw(uint amount) external onlyOwner {
        payable(owner).transfer(amount);
    }

    function execute(address target, bytes calldata data)
        external
        onlyOwner
        returns (bytes memory)
    {
        (bool success, bytes memory result) = target.call(data);
        require(success, "call failed");
        return result;
    }
}