;; KnowledgeFund: Community Learning Credit System
;; Version: 1.0.0

(define-data-var fund-administrator principal tx-sender)
(define-data-var credit-reserve uint u0)
(define-data-var contribution-bonus uint u100) ;; bonus credits added per block (example value)
(define-data-var last-updated uint u0) ;; last block when bonuses were calculated
(define-map participant-credits principal uint)

;; Helper function to ensure only the fund administrator can perform certain actions
(define-private (is-administrator (caller principal))
  (begin
    (asserts! (is-eq caller (var-get fund-administrator)) (err u100))
    (ok true)))

;; Initialize the contract
(define-public (setup (administrator principal))
  (begin
    (asserts! (is-none (map-get? participant-credits administrator)) (err u101))
    (var-set fund-administrator administrator)
    (ok "KnowledgeFund initialized")))

;; Contribute learning credits to the fund
(define-public (contribute (credits uint))
  (begin
    (asserts! (> credits u0) (err u102))
    (let ((current-credits (default-to u0 (map-get? participant-credits tx-sender))))
      (map-set participant-credits tx-sender (+ current-credits credits))
      (var-set credit-reserve (+ (var-get credit-reserve) credits))
      (ok (+ current-credits credits)))))

;; Calculate bonuses for all participants
(define-public (distribute-bonuses)
  (begin
    (try! (is-administrator tx-sender))
    (let ((current-block tenure-height)
          (previous-update (var-get last-updated)))
      (asserts! (> current-block previous-update) (err u103))
      ;; Calculate bonuses based on blocks elapsed
      (let ((elapsed (- current-block previous-update))
            (total-bonus (* elapsed (var-get contribution-bonus))))
        (var-set last-updated current-block)
        (var-set credit-reserve (+ (var-get credit-reserve) total-bonus))
        (ok total-bonus)))))

;; Redeem credits and bonuses
(define-public (redeem)
  (begin
    (let ((learner-credits (default-to u0 (map-get? participant-credits tx-sender))))
      (asserts! (> learner-credits u0) (err u104))
      (let ((total-credits (var-get credit-reserve))
            (total-bonus (* (var-get contribution-bonus) (- tenure-height (var-get last-updated))))
            (proportion (/ (* learner-credits u100000) total-credits)))
        ;; Update credits and calculate bonus proportion
        (let ((bonus-portion (/ (* proportion total-bonus) u100000)))
          (map-delete participant-credits tx-sender)
          (var-set credit-reserve (- (var-get credit-reserve) learner-credits))
          (ok (+ learner-credits bonus-portion)))))))