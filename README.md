# KnowledgeFund: Community Learning Credit System

A decentralized platform for managing educational credits within learning communities.

## Overview

KnowledgeFund is a blockchain-based system that enables communities to create collective learning incentives through a credit system. Built on Stacks using Clarity smart contracts, it provides a transparent way for participants to contribute to a shared knowledge economy and receive bonuses for their participation.

## Features

- Contribute learning credits to a community fund
- Earn bonus credits based on contribution time and community activity
- Redeem credits with accumulated bonuses
- Transparent tracking of community learning resources
- Administrator tools for managing community incentives

## Smart Contract Functions

### Core Functions

- `setup`: Initialize the KnowledgeFund with an administrator
- `contribute`: Add learning credits to the community fund
- `distribute-bonuses`: Calculate and distribute bonus credits
- `redeem`: Withdraw credits and earned bonuses

### Error Codes

- `100`: Caller is not the fund administrator
- `101`: Contract already initialized
- `102`: Credit contribution must be greater than zero
- `103`: No time has elapsed since last update
- `104`: No credits available to redeem

## Data Structures

The contract maintains:

- Fund administrator principal
- Total credit reserve
- Contribution bonus rate (additional credits per block)
- Last update block height
- Mapping of participant credit balances

## Technical Implementation

The system calculates bonuses proportionally based on:

1. Duration of participation (measured in blocks)
2. Size of contribution relative to total pool
3. Community-set bonus rate

When a participant redeems, they receive their initial contribution plus a share of accumulated bonuses proportional to their contribution.

## Getting Started

1. Clone the repository
2. Install Clarinet for local development
3. Run tests to verify functionality
4. Deploy to testnet for community testing.
