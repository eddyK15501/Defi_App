//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "./DappToken.sol";
import "./DaiToken.sol";

contract TokenFarm {
    string public name = "My Token Farm";

    DappToken public dappToken;
    DaiToken public daiToken;
    address public owner;

    address[] public stakers;
    mapping(address => uint256) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    constructor(DappToken _dappToken, DaiToken _daiToken) {
        dappToken = _dappToken;
        daiToken = _daiToken;
        owner = msg.sender;
    }

    function stakeTokens(uint256 _amount) public {
        //Transfer Mock Dai tokens to this contract for staking
        daiToken.transferFrom(msg.sender, address(this), _amount);

        //Update staking balance
        stakingBalance[msg.sender] += _amount;

        //Add users to staker array *only* if they have not staked already
        if (!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }
        //Update staking status
        hasStaked[msg.sender] = true;
        isStaking[msg.sender] = true;
    }
    
    function unstakeTokens() public {
        //Fetch staking balance
        uint balance = stakingBalance[msg.sender];

        //Require the amount be greater than 0
        require(balance > 0, "staking balance cannot be 0");

        //Transfer Mock Dai Tokens back where it came from
        daiToken.transfer(msg.sender, balance);

        //Update staking balance
        stakingBalance[msg.sender] = 0;

        //Update staking status
        isStaking[msg.sender] = false;
    }
    
    function issueTokens() public {
        //Only owner can call this function
        require(msg.sender == owner, "caller must be the owner");

        //Issue tokens to all stakers
        for (uint256 i = 0; i < stakers.length; i++) {
            address recipient = stakers[i];
            uint256 balance = stakingBalance[recipient];
            if (balance > 0) {
                dappToken.transfer(recipient, balance);
            }
        }
    }
}
