# Decentralized Lending Platform

A blockchain-based lending platform built with Clarity smart contracts for the Stacks ecosystem. This platform enables decentralized lending and borrowing with collateral management, borrower verification, and automated default handling.

## Overview

This platform consists of four main smart contracts:

1. **Borrower Verification Contract**: Validates identity and creditworthiness of borrowers
2. **Collateral Management Contract**: Tracks assets used to secure loans
3. **Loan Terms Contract**: Manages interest rates and repayment schedules
4. **Default Handling Contract**: Processes collateral liquidation when necessary

## Smart Contracts

### Borrower Verification Contract

This contract handles the verification of borrowers, including:
- Storing and retrieving borrower verification status
- Managing credit scores
- Revoking verification when necessary

### Collateral Management Contract

This contract manages the collateral for loans, including:
- Adding collateral for a loan
- Locking and releasing collateral
- Tracking collateral status

### Loan Terms Contract

This contract manages the terms of loans, including:
- Creating new loans
- Calculating repayment amounts (principal + interest)
- Tracking loan status (active, repaid, defaulted)

### Default Handling Contract

This contract handles loan defaults, including:
- Initiating liquidation processes
- Completing liquidations
- Canceling liquidations when necessary

## Getting Started

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) - Clarity development environment
- [Node.js](https://nodejs.org/) - For running tests

### Installation

1. Clone the repository:
