# BitcoinFlow Protocol

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Stacks](https://img.shields.io/badge/Stacks-Clarity-orange.svg)](https://stacks.org)
[![Bitcoin](https://img.shields.io/badge/Bitcoin-Secured-f7931a.svg)](https://bitcoin.org)

> A revolutionary Bitcoin-secured protocol that democratizes financial access through community-governed universal basic income distributions on Stacks.

## 🌟 Vision

BitcoinFlow represents the next evolution of economic empowerment, where Bitcoin's unshakeable security meets Stacks' programmable smart contracts to create a transparent, community-driven income distribution system. Built on the foundation of Bitcoin finality and Stacks' Clarity language, this protocol ensures every transaction, vote, and distribution is permanently recorded on the most secure blockchain network in existence.

## 🏗️ Architecture

### Core Innovations

- **Bitcoin-Native Security**: Leveraging Bitcoin's proof-of-work consensus for unmatched security
- **Transparent Governance**: Every decision recorded immutably on-chain with democratic participation
- **Sustainable Economics**: Adaptive treasury management with community oversight and economic safeguards
- **Trust-Minimized Operations**: Smart contract automation reduces human intervention while maintaining safety
- **Democratic Participation**: One participant, one vote governance model ensuring fair representation

### Protocol Constants

| Parameter | Value | Purpose |
|-----------|--------|---------|
| `PAYOUT-CYCLE-BLOCKS` | 144 blocks (~24 hours) | Bitcoin-aligned distribution timing |
| `RESERVE-FLOOR` | 10 STX | Minimum treasury balance for sustainability |
| `GOVERNANCE-CEILING` | 1,000,000 STX | Maximum proposal value to prevent manipulation |
| `VOTING-DURATION` | 1,440 blocks (~10 days) | Sufficient deliberation time for proposals |

## 🚀 Getting Started

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) - Stacks smart contract development toolkit
- [Node.js](https://nodejs.org/) (v16+)
- [Stacks Wallet](https://wallet.hiro.so/) or compatible wallet

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/alfred-olabisi/bitcoin-flow.git
   cd bitcoin-flow
   ```

2. **Install dependencies**

   ```bash
   npm install
   ```

3. **Verify contracts**

   ```bash
   clarinet check
   ```

4. **Run tests**

   ```bash
   npm test
   ```

### Development Setup

```bash
# Start Clarinet console for interactive development
clarinet console

# Run tests with coverage and cost analysis
npm run test:report

# Watch mode for continuous testing during development
npm run test:watch
```

## 📋 Protocol Operations

### Core Functions

#### Community Participation

##### Join Community

```clarity
(contract-call? .bitcoin-flow join-community)
```

- Registers new participants in the protocol
- Creates member profile with verification requirements
- Updates global participation metrics

##### Receive Universal Basic Income

```clarity
(contract-call? .bitcoin-flow receive-income)
```

- Distributes STX to eligible community members
- Enforces 24-hour cooldown between claims
- Validates treasury sufficiency and member verification

##### Fund Treasury

```clarity
(contract-call? .bitcoin-flow fund-treasury amount)
```

- Allows community funding of the protocol treasury
- Accepts STX contributions from any participant
- Updates treasury reserves for sustainable distributions

#### Governance System

##### Propose Changes

```clarity
(contract-call? .bitcoin-flow propose-change "base-income-amount" new-amount)
```

- Submit proposals for protocol parameter modifications
- Supported categories: `base-income-amount`, `payout-cycle-blocks`, `reserve-floor`
- Creates democratic voting opportunity for community

##### Cast Votes

```clarity
(contract-call? .bitcoin-flow cast-vote proposal-id support-boolean)
```

- Democratic participation in protocol governance
- One vote per verified community member
- Prevents double voting and manipulation

#### Administrative Functions

##### Approve Members (Admin Only)

```clarity
(contract-call? .bitcoin-flow approve-member member-principal)
```

- Administrative verification of new community members
- Quality control mechanism for protocol integrity
- Grants distribution eligibility to verified participants

### Read-Only Functions

#### Member Information

```clarity
(contract-call? .bitcoin-flow fetch-member-profile member-principal)
```

Returns comprehensive member data including registration status, verification, earnings history, and claim statistics.

#### Treasury Status

```clarity
(contract-call? .bitcoin-flow fetch-treasury-status)
```

Provides real-time treasury balance for transparency and planning.

#### Protocol Metrics

```clarity
(contract-call? .bitcoin-flow fetch-protocol-metrics)
```

Returns system overview including payout amounts, cycle duration, community size, and operational parameters.

#### Eligibility Check

```clarity
(contract-call? .bitcoin-flow check-income-eligibility member-principal)
```

Real-time verification of distribution eligibility considering all protocol requirements.

## 🔒 Security Features

### Economic Safeguards

- **Treasury Floor**: Minimum 10 STX reserve prevents complete depletion
- **Governance Ceiling**: Maximum proposal values prevent economic attacks
- **Cooldown Periods**: 24-hour intervals prevent gaming and ensure fair distribution
- **Verification Requirements**: Administrative approval gates prevent spam and abuse

### Access Controls

- **Administrative Functions**: Protocol owner controls for emergency management
- **Member Verification**: Quality control for community participation
- **Proposal Validation**: Ensures only legitimate parameter changes are proposed
- **Vote Integrity**: Prevents double voting and unauthorized participation

### Emergency Procedures

The protocol includes emergency suspension capabilities for crisis management:

```clarity
;; Emergency suspension (Admin only)
(contract-call? .bitcoin-flow suspend-protocol)

;; Protocol reactivation (Admin only)
(contract-call? .bitcoin-flow reactivate-protocol)
```

## 📊 Error Handling

The protocol implements comprehensive error handling with descriptive error codes:

| Error Code | Description | Category |
|------------|-------------|----------|
| u100 | Admin Required | Administrative |
| u101 | Duplicate Registration | Registration |
| u102 | Unregistered User | Authentication |
| u103 | Verification Pending | Authorization |
| u104 | Claim Cooldown | Distribution |
| u105 | Treasury Depleted | Economic |
| u106 | Invalid Contribution | Economic |
| u107 | Access Denied | Authorization |
| u108 | Malformed Proposal | Governance |
| u109 | Proposal Expired | Governance |
| u110 | Value Out of Bounds | Validation |
| u111 | Duplicate Vote | Governance |
| u112 | Protocol Suspended | Administrative |

## 🧪 Testing

The project uses Vitest with Clarinet SDK for comprehensive testing:

```bash
# Run all tests
npm test

# Run tests with coverage and cost analysis
npm run test:report

# Development mode with auto-reload
npm run test:watch

# Check contract syntax and analysis
clarinet check
```

### Test Structure

- **Unit Tests**: Individual function testing with edge cases
- **Integration Tests**: End-to-end protocol workflow validation
- **Gas Cost Analysis**: Economic efficiency optimization
- **Security Tests**: Attack vector validation and prevention

## 🤝 Contributing

We welcome contributions to the BitcoinFlow protocol! Please follow these guidelines:

1. **Fork the repository** and create a feature branch
2. **Write comprehensive tests** for new functionality
3. **Follow Clarity best practices** and maintain code quality
4. **Document changes** thoroughly in commit messages
5. **Submit pull requests** with detailed descriptions

### Development Workflow

1. Create feature branch: `git checkout -b feature/your-feature`
2. Make changes and add tests
3. Verify with: `clarinet check && npm test`
4. Commit changes: `git commit -m "feat: describe your changes"`
5. Push branch: `git push origin feature/your-feature`
6. Create pull request with comprehensive description

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Built with ❤️ on Stacks | Secured by Bitcoin
