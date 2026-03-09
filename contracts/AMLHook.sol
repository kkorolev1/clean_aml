// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IProxyVault {
    function amlApproved() external view returns(bool);
}

contract AMLHook {

    function beforeSwap(address sender) external view {

        require(sender.code.length > 0, "must be contract");

        bool approved = IProxyVault(sender).amlApproved();

        require(approved, "AML failed");
    }
}