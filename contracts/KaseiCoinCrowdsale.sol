// SPDX-License-Identifier: MIT

// requires compiling with 0.5.5 due to dependencies
pragma solidity ^0.5.0;

import "./KaseiCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";


// Have the KaseiCoinCrowdsale contract inherit the following OpenZeppelin:
// * Crowdsale
// * MintedCrowdsale
contract KaseiCoinCrowdsale is Crowdsale, MintedCrowdsale { // UPDATE THE CONTRACT SIGNATURE TO ADD INHERITANCE
    
    // Provide parameters for all of the features of your crowdsale, such as the `rate`, `wallet` for fundraising, and `token`.
    constructor(
        uint256 rate,
        address payable wallet,
        KaseiCoin token
    ) public Crowdsale(rate, wallet, token) {
        // constructor can stay empty
    }
}


contract KaseiCoinCrowdsaleDeployer {
    // Create an `address public` variable called `kasei_token_address`.
    address public kaseiTokenAddress;
    // Create an `address public` variable called `kasei_crowdsale_address`.
    address public kaseiCrowdsaleAddress;

    // Add the constructor.
    constructor(
        string memory name, 
        string memory symbol, 
        address payable wallet
    ) public {
        // Create a new instance of the KaseiCoin contract
        KaseiCoin token = new KaseiCoin(name, symbol);
        
        // Assign the token address to `kasei_token_address` variable.
        kaseiTokenAddress = address(token);

        // Create a new instance of the `KaseiCoinCrowdsale` contract
        // using a value of 1 will maintain parity with ether (1 eth = 1 kaseicoin)
        KaseiCoinCrowdsale kaseiCrowdsale = new KaseiCoinCrowdsale(1, wallet, token);
            
        // Aassign the `KaseiCoinCrowdsale` contract’s address to the `kasei_crowdsale_address` variable.
        kaseiCrowdsaleAddress = address(kaseiCrowdsale);

        // Set the `KaseiCoinCrowdsale` contract as a minter
        token.addMinter(kaseiCrowdsaleAddress);
        
        // Have the `KaseiCoinCrowdsaleDeployer` renounce its minter role.
        token.renounceMinter();
    }
}
