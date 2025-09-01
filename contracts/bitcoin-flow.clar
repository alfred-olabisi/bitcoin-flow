;; BITCOINFLOW - DECENTRALIZED UNIVERSAL INCOME PROTOCOL
;;
;; A revolutionary Bitcoin-secured protocol that democratizes financial access
;; through community-governed universal basic income distributions on Stacks.
;;
;; VISION:
;; BitcoinFlow represents the next evolution of economic empowerment, where
;; Bitcoin's unshakeable security meets Stacks' programmable smart contracts
;; to create a transparent, community-driven income distribution system.
;;
;;  ARCHITECTURE:
;; Built on the foundation of Bitcoin finality and Stacks' clarity language,
;; this protocol ensures every transaction, vote, and distribution is
;; permanently recorded on the most secure blockchain network in existence.
;;
;;  KEY INNOVATIONS:
;; - Bitcoin-Native Security: Leveraging Bitcoin's proof-of-work consensus
;; - Transparent Governance: Every decision recorded immutably on-chain
;; - Sustainable Economics: Adaptive treasury management with community oversight
;; - Trust-Minimized Operations: Smart contract automation reduces human intervention
;; - Democratic Participation: One participant, one vote governance model
;;

;; PROTOCOL CONSTANTS     

;; Core protocol ownership - immutable at deployment
(define-constant PROTOCOL-ADMIN tx-sender)

;; Distribution timing - leverages Bitcoin's predictable block production
(define-constant PAYOUT-CYCLE-BLOCKS u144) ;; ~24 hours (Bitcoin-aligned timing)

;; Treasury security thresholds - ensures sustainable operation
(define-constant RESERVE-FLOOR u10000000) ;; 10 STX minimum (economic sustainability)
(define-constant GOVERNANCE-CEILING u1000000000000) ;; Max proposal value (anti-manipulation)
(define-constant VOTING-DURATION u1440) ;; ~10 days (sufficient deliberation time)

;; COMPREHENSIVE ERROR HANDLING 

;; Administrative errors - protocol management
(define-constant ERR-ADMIN-REQUIRED (err u100))
(define-constant ERR-PROTOCOL-SUSPENDED (err u112))

;; Participant lifecycle errors - registration and verification
(define-constant ERR-DUPLICATE-REGISTRATION (err u101))
(define-constant ERR-UNREGISTERED-USER (err u102))
(define-constant ERR-VERIFICATION-PENDING (err u103))

;; Distribution mechanism errors - economic constraints
(define-constant ERR-CLAIM-COOLDOWN (err u104))
(define-constant ERR-TREASURY-DEPLETED (err u105))
(define-constant ERR-INVALID-CONTRIBUTION (err u106))

;; Governance system errors - democratic process integrity
(define-constant ERR-ACCESS-DENIED (err u107))
(define-constant ERR-MALFORMED-PROPOSAL (err u108))
(define-constant ERR-PROPOSAL-EXPIRED (err u109))
(define-constant ERR-VALUE-OUT-OF-BOUNDS (err u110))
(define-constant ERR-DUPLICATE-VOTE (err u111))

;;   PROTOCOL STATE VARIABLES  

;; Core treasury metrics - tracks Bitcoin-secured value flow
(define-data-var community-treasury uint u0)
(define-data-var active-participants uint u0)

;; Distribution parameters - community-governed economic policy
(define-data-var base-income-amount uint u1000000) ;; 1 STX default (adjustable via governance)
(define-data-var previous-distribution-block uint u0)

;; Protocol controls - administrative safeguards
(define-data-var protocol-active bool true)
(define-data-var governance-proposal-index uint u0)

;; STRUCTURED DATA MAPPINGS 

;; Comprehensive participant profiles - tracks entire user journey
(define-map community-members
  principal
  {
    is-registered: bool, ;; Basic enrollment status
    verification-complete: bool, ;; Identity verification flag
    enrollment-block: uint, ;; Historical record of joining
    latest-claim-block: uint, ;; Cooldown enforcement
    lifetime-earnings: uint, ;; Total received from protocol
    distribution-count: uint, ;; Number of successful claims
  }
)

;; Democratic governance infrastructure - ensures transparent decision-making
(define-map community-proposals
  uint
  {
    creator: principal, ;; Proposal originator
    category: (string-ascii 32), ;; Type of parameter change
    target-value: uint, ;; Proposed new value
    support-votes: uint, ;; Community approval count
    opposition-votes: uint, ;; Community rejection count
    current-status: (string-ascii 10), ;; active, passed, rejected, expired
    deadline-block: uint, ;; Voting cutoff point
  }
)