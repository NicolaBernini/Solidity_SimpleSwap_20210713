
# Solidity_SimpleSwap_20210713

Simple Solidity Contract to swap ERC20 with ETH 

# Quick Test in Remix 

1. Deploy the [`contracts/erc20.sol`](contracts/erc20.sol) from the `W1` Wallet who will be receive the minted initial amount 

2. Deploy the [`contracts/swap.sol`](contracts/swap.sol) 

3. Say `W1` wants to sell a certain amount of its ERC20 tokens so it first calls the ERC20 `approve()` to approve the Swap Contract for that amount of ERC20 and then calls `ask()` to create the deal 

4. Everybody can now see the deal inspecting the logs 

5. Now `W2` Wallet wants to enter the deal so using it just call `buy()` making sure you pay at least the required amount of ETH 

6. The Swap Contract will run the swap and refund the buyer for the exceeding amount of ETH 



FINAL NOTES 

This is just a very minimal example so I have not paid attention to security and efficiency, just focusing on the minimal functionalities 

Please do not use this in production 







