(define-module (p001))

(define (divisible-by-3-or-5? input)
  (or (= 0 (modulo input 3))
      (= 0 (modulo input 5))))

(define (solve input)
  (apply + (filter divisible-by-3-or-5? (iota input))))
