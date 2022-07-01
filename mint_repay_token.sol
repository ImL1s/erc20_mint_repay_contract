// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.6.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.6.0/contracts/access/Ownable.sol";

contract MyToken is ERC20,Ownable {

    ERC20 public usdt;

    event Mint(address user ,uint amount);
    event Repay(address user ,uint amount);

    constructor(address usdtAddress) ERC20("MyToken", "MyToken") {
        usdt = ERC20(usdtAddress);
    }

    function getAllEther() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function mint(uint amount) public {
        uint userUsdtBalance = usdt.balanceOf(msg.sender);
        require(userUsdtBalance > 0, "You need get more USDT!");
        uint256 allowance = usdt.allowance(msg.sender, address(this));
        require(allowance >= amount, "Check the USDt allowance");
        usdt.transferFrom(msg.sender, address(this), amount);
        _mint(msg.sender, amount);
        emit Mint(msg.sender, amount);
    }

    function repay(uint amount) public {
        uint userUssBalance = balanceOf(msg.sender);
        require(userUssBalance > 0, "You need get more USS!");
        require(userUssBalance >= amount, "You don't have enough USS!");
        _burn(msg.sender, amount);
        usdt.transfer(msg.sender, amount);
        emit Repay(msg.sender, amount);
    }
}