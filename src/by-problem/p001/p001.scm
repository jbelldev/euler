#!/usr/bin/env -S guile -e main -s
!#

(define (divisible-by-3-or-5? input)
  (or (= 0 (modulo input 3))
      (= 0 (modulo input 5))))

(define (solve input)
  (apply + (filter divisible-by-3-or-5? (iota input))))

(define (main _)
  (display (solve 1000))
  (newline))
