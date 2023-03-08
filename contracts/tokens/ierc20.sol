//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.16;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract TokenTransfer {
    address public tokenAddress;
    address public owner;

    constructor(address _tokenAddress) {
        tokenAddress = _tokenAddress;
        owner = msg.sender;
    }

    function transferTokens(address recipient, uint256 amount) external {
        IERC20 token = IERC20(tokenAddress);
        uint256 senderBalance = token.balanceOf(msg.sender);
        uint256 recipientBalance = token.balanceOf(recipient);
        require(amount > 0, "Transfer amount cannot be zero.");
        require(senderBalance >= amount, "Insufficient balance");
        require(recipientBalance + amount >= recipientBalance, "Overflow error");

        uint256 maxTransferAmount = senderBalance / 2;
        require(amount <= maxTransferAmount, "Transfer amount exceeds limit");

        token.transfer(recipient, amount);
    }

    function changeOwner(address newOwner) external {
        require(msg.sender == owner, "Only owner can change ownership");
        owner = newOwner;
    }
}
