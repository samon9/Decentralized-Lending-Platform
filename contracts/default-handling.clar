;; default-handling.clar
;; This contract processes collateral liquidation when necessary

(define-data-var admin principal tx-sender)

;; Data map to store liquidation information
(define-map liquidations
  { loan-id: uint }
  {
    liquidator: principal,
    liquidation-amount: uint,
    liquidation-time: uint,
    completed: bool
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

;; Initiate liquidation process
(define-public (initiate-liquidation (loan-id uint) (liquidation-amount uint))
  (begin
    (asserts! (is-admin) (err u403))
    (asserts! (> liquidation-amount u0) (err u400))
    (asserts! (is-none (map-get? liquidations { loan-id: loan-id })) (err u409))
    (ok (map-set liquidations
      { loan-id: loan-id }
      {
        liquidator: tx-sender,
        liquidation-amount: liquidation-amount,
        liquidation-time: block-height,
        completed: false
      }
    ))
  )
)

;; Complete liquidation process
(define-public (complete-liquidation (loan-id uint))
  (let ((liquidation (unwrap! (map-get? liquidations { loan-id: loan-id }) (err u404))))
    (begin
      (asserts! (is-admin) (err u403))
      (asserts! (not (get completed liquidation)) (err u400))
      (ok (map-set liquidations
        { loan-id: loan-id }
        (merge liquidation { completed: true })
      ))
    )
  )
)

;; Cancel liquidation process
(define-public (cancel-liquidation (loan-id uint))
  (let ((liquidation (unwrap! (map-get? liquidations { loan-id: loan-id }) (err u404))))
    (begin
      (asserts! (is-admin) (err u403))
      (asserts! (not (get completed liquidation)) (err u400))
      (ok (map-delete liquidations { loan-id: loan-id }))
    )
  )
)

;; Get liquidation information
(define-read-only (get-liquidation (loan-id uint))
  (map-get? liquidations { loan-id: loan-id })
)

;; Check if liquidation is completed
(define-read-only (is-liquidation-completed (loan-id uint))
  (default-to false
    (get completed (map-get? liquidations { loan-id: loan-id }))
  )
)
