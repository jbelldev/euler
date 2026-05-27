#!/usr/bin/env -S guile -e main -s
!#

(define (make-fib-gen)
  (let ((a 0)
        (b 1))
    (lambda ()
      (let ((n a))
        (set! a (+ a b))
        (set! b n)
        n))))

(define (solve limit)
  (define next-fib (make-fib-gen))
  (let loop ((result 0))
    (let ((n (next-fib)))
      (cond
       [(>= n limit) result]
       [(even? n)    (loop (+ result n))]
       [else         (loop result)]))))

(define (main _)
  (display (solve 4000000)))
