pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MinimalSwap {
    // Swaps ERC20 for ETH 
    address owner;
    constructor () {
        owner = msg.sender; 
    }
    
    modifier only_owner {
        require(msg.sender == owner, "Owner");
        _; 
    }
    
    struct swap {
        address token; 
        uint256 amount; 
        uint256 price;
    }
    
    event Ask(address token, address seller, uint256 amount, uint256 price);
    event Swap(address token, address seller, address buyer, uint256 amount, uint256 price);
    event Refund(address buyer, uint256 amount);
    
    // For the sake of simplicity let's assume each seller can create only one ask proposal 
    mapping (address => swap) swaps; 
    
    // To avoi re-entrancy
    mapping (address => bool) is_working;
    
    function ask(address token, uint256 amount, uint256 price) external {
        require(token != address(0), "Token");
        require(amount > 0, "Amount");
        
        swaps[msg.sender] = swap(token, amount, price); 
        
        emit Ask(token, msg.sender, amount, price); 
    }
    
    function buy(address payable seller) external payable {
        require( swaps[seller].amount > 0, "No such swap" ); 
        require( msg.value >= swaps[seller].amount ); 
        require( is_working[seller] == false, "Already working" ); 
        
        is_working[seller] = true;
        
        // Transfer token to the buyer 
        require( IERC20(swaps[seller].token).transferFrom(seller, address(this), swaps[seller].amount), "Transfer" ); 
        require( IERC20(swaps[seller].token).transfer(msg.sender, swaps[seller].amount), "Transfer" );
        
        // Pay the seller
        seller.transfer( swaps[seller].price );
        
        emit Swap(swaps[seller].token, seller, msg.sender, swaps[seller].amount, swaps[seller].price);
        
        if( msg.value > swaps[seller].price ) {
            payable(msg.sender).transfer( msg.value - swaps[seller].price );
            emit Refund(msg.sender, msg.value - swaps[seller].price); 
        }
        
        delete swaps[seller]; 
        
        is_working[seller] = false;
    }

}

