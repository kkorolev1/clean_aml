# CleanAML

A blockchain service that verifies the **AML (Anti-Money Laundering) status of a sender before allowing a token swap**.
The system introduces an **AML-verified proxy vault** that interacts with a decentralized exchange pool and only permits swaps once an AML oracle has approved the sender.

The project is implemented using **Solidity smart contracts** and the **Hardhat development environment**, with integration hooks for **Uniswap v4 pools**.

---

# 1. Project Goal

The goal of this project is to design a **prototype AML-aware crypto transaction system** that:

1. Prevents swaps initiated by wallets that have not passed AML verification.
2. Uses a **proxy vault smart contract** to isolate user funds.
3. Integrates AML validation into the **swap pipeline via a Uniswap v4 hook**.
4. Demonstrates a **working technical prototype** and development process.

---

# 2. System Architecture

The architecture introduces an AML verification layer between the user and the exchange.

```
User
 │
 │ deposit ETH
 ▼
ProxyVault
 │
 │ AML verification flag
 ▼
AML Oracle
 │
 │ swap execution
 ▼
Uniswap Pool (ETH/TOK)
 │
 ▼
AML Hook (beforeSwap)
```

### Key Idea

A swap is allowed **only if**:

* The sender is a **ProxyVault contract**
* The vault has an **AML approval flag set by the oracle**

---

# 3. Software Components (SW Agents)

The prototype consists of several interacting smart-contract agents.

## 3.1 ProxyVault

Smart contract controlled by the user that:

* stores user funds
* executes swaps on behalf of the user
* maintains AML verification status

### Responsibilities

* hold deposited ETH
* store AML approval flag
* execute swap transactions
* restrict withdrawal to vault owner

---

## 3.2 AML Oracle

Trusted oracle address that performs AML checks off-chain.

### Responsibilities

* verify sender address using AML database
* set AML approval flag on ProxyVault
* revoke approval if sender becomes suspicious

---

## 3.3 AML Hook

A **Uniswap v4 hook** that executes **before every swap**.

### Responsibilities

* check that the sender is a contract
* check that the contract is an approved ProxyVault
* revert the transaction if AML verification is missing

---

## 3.4 ERC20 Token

A token used to simulate trading against native ETH.

---

# 4. Technology Stack

The prototype uses the following technologies:

* **Solidity (0.8.x)** — smart contract development
* **Hardhat** — Ethereum development framework
* **Ethers.js** — contract interaction and scripting
* **Uniswap v4** — DEX protocol with customizable hooks
* **Node.js** — development runtime

---

# 5. Technical Description

The technical specification of the prototype includes:

### 5.1 Smart Contract Layer

Contracts:

```
contracts/
 ├ ProxyVault.sol
 ├ AMLOracle.sol
 ├ AMLHook.sol
 └ MockToken.sol
```

Functions implemented:

| Contract   | Function         | Description               |
| ---------- | ---------------- | ------------------------- |
| ProxyVault | deposit()        | Accept user funds         |
| ProxyVault | execute()        | Execute swap via router   |
| ProxyVault | withdraw()       | Withdraw funds            |
| ProxyVault | setAMLApproved() | Set AML verification flag |
| AMLOracle  | approve()        | Approve vault             |
| AMLOracle  | reject()         | Reject vault              |
| AMLHook    | beforeSwap()     | Enforce AML verification  |

---

### 5.2 Smart Contract Agents

| Agent        | Type               | Role                           |
| ------------ | ------------------ | ------------------------------ |
| User Wallet  | External           | Initiates deposit and swap     |
| ProxyVault   | Smart Contract     | Holds funds and performs swaps |
| AML Oracle   | Smart Contract     | Controls AML verification      |
| Uniswap Pool | Protocol Contract  | Executes token swap            |
| AML Hook     | Protocol Extension | Enforces AML validation        |

---

# 6. System Workflow

## 6.1 Pool Setup (Liquidity Provider)

1. Deploy ERC20 token `TOK`
2. Create ETH/TOK pool
3. Attach AMLHook to the pool
4. Provide liquidity

---

## 6.2 Vault Setup (Trader)

1. User deploys a `ProxyVault`
2. User deposits ETH into the vault

```
User → ProxyVault.deposit()
```

---

## 6.3 AML Verification

The AML Oracle verifies the sender off-chain and approves the vault.

```
AMLOracle.approve(vault)
```

The vault flag becomes:

```
amlApproved = true
```

---

## 6.4 Swap Execution

The user performs a swap through the vault.

```
ProxyVault.execute(router, swapData)
```

During swap:

```
Uniswap → AMLHook.beforeSwap()
```

Hook checks:

```
require(vault.amlApproved == true)
```

If verification fails → transaction reverts.

---

# 7. List of Actions Performed

The prototype development includes the following steps:

1. Environment setup using Hardhat
2. Implementation of smart contracts
3. Compilation and deployment scripts
4. Local blockchain testing
5. Integration with Uniswap v4 hook architecture
6. Execution of test swaps
7. Verification that AML validation blocks unauthorized swaps

---

# 8. Prototype Status

Completed:

* smart contract design
* AML verification logic
* vault architecture
* development environment

In progress:

* full Uniswap v4 pool integration
* swap testing with hook
* expanded test coverage
