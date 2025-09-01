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

;; Vote tracking system - prevents governance manipulation
(define-map participation-records
  {
    proposal-ref: uint,
    participant: principal,
  }
  bool
)

;; INTERNAL UTILITY FUNCTIONS  

;; Administrative privilege verification - protocol security
(define-private (verify-admin-access)
  (is-eq tx-sender PROTOCOL-ADMIN)
)

;; Universal Basic Income eligibility engine - core protocol logic
(define-private (calculate-distribution-eligibility (participant principal))
  (match (map-get? community-members participant)
    member-profile
    (and
      ;; Must be verified community member
      (get verification-complete member-profile)
      ;; Respects distribution timing (Bitcoin-aligned cycles)
      (>= (- stacks-block-height (get latest-claim-block member-profile))
        PAYOUT-CYCLE-BLOCKS
      )
      ;; Treasury has sufficient reserves
      (>= (var-get community-treasury) (var-get base-income-amount))
      ;; Protocol is operational
      (var-get protocol-active)
    )
    ;; Unregistered users are ineligible
    false
  )
)

;; Participant record management - maintains accurate state
(define-private (process-successful-claim
    (recipient principal)
    (payout-amount uint)
  )
  (match (map-get? community-members recipient)
    current-profile (ok (map-set community-members recipient
      (merge current-profile {
        latest-claim-block: stacks-block-height,
        lifetime-earnings: (+ (get lifetime-earnings current-profile) payout-amount),
        distribution-count: (+ (get distribution-count current-profile) u1),
      })
    ))
    ERR-UNREGISTERED-USER
  )
)

;; Governance parameter validation - prevents system abuse
(define-private (validate-proposal-category (category (string-ascii 32)))
  (or
    (is-eq category "base-income-amount") ;; UBI payout size
    (is-eq category "payout-cycle-blocks") ;; Distribution frequency
    (is-eq category "reserve-floor") ;; Minimum treasury balance
  )
)

;; Economic bounds checking - maintains protocol stability
(define-private (validate-proposed-amount (amount uint))
  (and
    (> amount u0) ;; Must be positive value
    (<= amount GOVERNANCE-CEILING) ;; Prevents economic attacks
  )
)

;; PUBLIC INTERFACE - CORE OPERATIONS

;; Community Enrollment - Gateway to Bitcoin-secured income
(define-public (join-community)
  (let ((existing-membership (map-get? community-members tx-sender)))
    ;; Prevent duplicate registrations
    (asserts! (is-none existing-membership) ERR-DUPLICATE-REGISTRATION)
    ;; Ensure protocol is operational
    (asserts! (var-get protocol-active) ERR-PROTOCOL-SUSPENDED)

    ;; Create new community member profile
    (map-set community-members tx-sender {
      is-registered: true,
      verification-complete: false, ;; Requires admin verification
      enrollment-block: stacks-block-height,
      latest-claim-block: u0,
      lifetime-earnings: u0,
      distribution-count: u0,
    })

    ;; Update global participation metrics
    (var-set active-participants (+ (var-get active-participants) u1))
    (ok true)
  )
)

;; Identity Verification - Administrative quality control
(define-public (approve-member (candidate principal))
  (begin
    ;; Restrict to protocol administrators
    (asserts! (verify-admin-access) ERR-ADMIN-REQUIRED)
    ;; Verify candidate is registered
    (asserts! (is-some (map-get? community-members candidate))
      ERR-UNREGISTERED-USER
    )

    ;; Grant verification status
    (map-set community-members candidate
      (merge
        (unwrap! (map-get? community-members candidate) ERR-UNREGISTERED-USER) { verification-complete: true }
      ))
    (ok true)
  )
)

;; Universal Basic Income Distribution - Core value proposition
(define-public (receive-income)
  (let (
      (beneficiary tx-sender)
      (payout-size (var-get base-income-amount))
    )
    ;; Protocol operational checks
    (asserts! (var-get protocol-active) ERR-PROTOCOL-SUSPENDED)
    ;; Eligibility verification (includes cooldown, verification, treasury)
    (asserts! (calculate-distribution-eligibility beneficiary)
      ERR-VERIFICATION-PENDING
    )
    ;; Treasury adequacy confirmation
    (asserts! (>= (var-get community-treasury) payout-size) ERR-TREASURY-DEPLETED)

    ;; Execute Bitcoin-secured STX transfer
    (try! (as-contract (stx-transfer? payout-size tx-sender beneficiary)))

    ;; Update treasury accounting
    (var-set community-treasury (- (var-get community-treasury) payout-size))

    ;; Record successful distribution
    (try! (process-successful-claim beneficiary payout-size))

    (ok payout-size)
  )
)

;; Treasury Funding - Community-driven sustainability
(define-public (fund-treasury (contribution-amount uint))
  (begin
    ;; Validate contribution parameters
    (asserts! (> contribution-amount u0) ERR-INVALID-CONTRIBUTION)
    (asserts! (var-get protocol-active) ERR-PROTOCOL-SUSPENDED)

    ;; Process STX contribution to protocol treasury
    (try! (stx-transfer? contribution-amount tx-sender (as-contract tx-sender)))

    ;; Update treasury reserves
    (var-set community-treasury
      (+ (var-get community-treasury) contribution-amount)
    )

    (ok contribution-amount)
  )
)

;; DEMOCRATIC GOVERNANCE SYSTEM 

;; Proposal Submission - Community-driven protocol evolution
(define-public (propose-change
    (parameter-category (string-ascii 32))
    (new-value uint)
  )
  (let ((next-proposal-id (+ (var-get governance-proposal-index) u1)))
    ;; Membership requirement for governance participation
    (asserts! (is-some (map-get? community-members tx-sender))
      ERR-UNREGISTERED-USER
    )
    ;; Validate proposal parameters
    (asserts! (validate-proposal-category parameter-category)
      ERR-MALFORMED-PROPOSAL
    )
    (asserts! (validate-proposed-amount new-value) ERR-VALUE-OUT-OF-BOUNDS)
    ;; Ensure protocol accepts new proposals
    (asserts! (var-get protocol-active) ERR-PROTOCOL-SUSPENDED)

    ;; Create governance proposal record
    (map-set community-proposals next-proposal-id {
      creator: tx-sender,
      category: parameter-category,
      target-value: new-value,
      support-votes: u0,
      opposition-votes: u0,
      current-status: "active",
      deadline-block: (+ stacks-block-height VOTING-DURATION),
    })

    ;; Increment proposal counter
    (var-set governance-proposal-index next-proposal-id)
    (ok next-proposal-id)
  )
)