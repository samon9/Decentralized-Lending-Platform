;; borrower-verification.clar
;; This contract validates identity and creditworthiness of borrowers

(define-data-var admin principal tx-sender)

;; Data map to store borrower verification status
(define-map borrowers
  { borrower: principal }
  {
    verified: bool,
    credit-score: uint,
    verification-time: uint
  }
)

;; Check if caller is admin
(define-private (is-admin)
  (is-eq tx-sender (var-get admin))
)

;; Set a new admin
(define-public (set-admin (new-admin principal))
  (begin
    (asserts! (is-admin) (err u403))
    (ok (var-set admin new-admin))
  )
)

;; Verify a borrower
(define-public (verify-borrower (borrower principal) (credit-score uint))
  (begin
    (asserts! (is-admin) (err u403))
    (asserts! (> credit-score u0) (err u400))
    (ok (map-set borrowers
      { borrower: borrower }
      {
        verified: true,
        credit-score: credit-score,
        verification-time: block-height
      }
    ))
  )
)

;; Revoke verification
(define-public (revoke-verification (borrower principal))
  (begin
    (asserts! (is-admin) (err u403))
    (asserts! (is-borrower-verified borrower) (err u404))
    (ok (map-set borrowers
      { borrower: borrower }
      {
        verified: false,
        credit-score: u0,
        verification-time: block-height
      }
    ))
  )
)

;; Check if a borrower is verified
(define-read-only (is-borrower-verified (borrower principal))
  (default-to false
    (get verified (map-get? borrowers { borrower: borrower }))
  )
)

;; Get borrower's credit score
(define-read-only (get-credit-score (borrower principal))
  (default-to u0
    (get credit-score (map-get? borrowers { borrower: borrower }))
  )
)
