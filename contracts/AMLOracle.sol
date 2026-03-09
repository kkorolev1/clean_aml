// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IProxyVault {
    function setAMLApproved(bool approved) external;
}

contract AMLOracle {

    address public admin;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin);
        _;
    }

    function approve(address vault) external onlyAdmin {
        IProxyVault(vault).setAMLApproved(true);
    }

    function reject(address vault) external onlyAdmin {
        IProxyVault(vault).setAMLApproved(false);
    }
}