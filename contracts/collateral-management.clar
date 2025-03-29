;; collateral-management.clar
;; This contract tracks assets used to secure loans

(define-data-var admin principal tx-sender)

;; Data map to store collateral information
(define-map collaterals
  { loan-id: uint }
  {
    borrower: principal,
    asset-type: (string-ascii 20),
    amount: uint,
    locked: bool
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

;; Add collateral for a loan
(define-public (add-collateral (loan-id uint) (asset-type (string-ascii 20)) (amount uint))
  (begin
    (asserts! (> amount u0) (err u400))
    (asserts! (is-none (map-get? collaterals { loan-id: loan-id })) (err u409))
    (ok (map-set collaterals
      { loan-id: loan-id }
      {
        borrower: tx-sender,
        asset-type: asset-type,
        amount: amount,
        locked: true
      }
    ))
  )
)

;; Release collateral (when loan is repaid)
(define-public (release-collateral (loan-id uint))
  (let ((collateral (unwrap! (map-get? collaterals { loan-id: loan-id }) (err u404))))
    (begin
      (asserts! (or (is-admin) (is-eq tx-sender (get borrower collateral))) (err u403))
      (asserts! (get locked collateral) (err u400))
      (ok (map-set collaterals
        { loan-id: loan-id }
        (merge collateral { locked: false })
      ))
    )
  )
)

;; Get collateral information
(define-read-only (get-collateral (loan-id uint))
  (map-get? collaterals { loan-id: loan-id })
)

;; Check if collateral is locked
(define-read-only (is-collateral-locked (loan-id uint))
  (default-to false
    (get locked (map-get? collaterals { loan-id: loan-id }))
  )
)
