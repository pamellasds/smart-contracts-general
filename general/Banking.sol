// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Banking {
    mapping(address => uint256) public balances;
    address payable owner;

    constructor() {
        owner = payable(msg.sender);
    }

    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than 0.");
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint _amount) public {
        require(msg.sender == owner, "Only the owner can withdraw funds.");
        require(_amount <= balances[msg.sender], "Insufficient funds.");
        require(_amount > 0, "Withdrawal amount must be greater than 0.");
        payable(msg.sender).transfer(_amount);
        balances[msg.sender] -= _amount;
    }

    function transfer(address payable _recipient, uint256 _amount) public {
        require(_amount <= balances[msg.sender], "Insufficient funds.");
        require(_amount > 0, "Transfer amount must be greater than 0.");
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
    }

    function getBalance(address payable user) public view returns (uint256) {
        return balances[user];
    }

    function grantAccess(address payable user) public {
        require(msg.sender == owner, "Only the owner can withdraw funds.");
        owner = user;
    }

    function revokeAccess(address payable user) public {
        require(msg.sender == owner, "Only the owner can withdraw funds.");
        require(user != owner, "Cannot revoke access for the current owner.");
        owner = payable(msg.sender);
    }

    function destroy() public {
        require(msg.sender == owner, "Only the owner can withdraw funds.");
        selfdestruct(owner);
    }
}