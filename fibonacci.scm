(define (fib-recursive n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (else (+ (fib (- n 1))
                 (fib (- n 2))))))

(define (fib n)
  (define (fib-iter a b count)
    (if (= count n)
      a
      (fib-iter (+ a b) a (inc count))))
  (fib-iter 1 0 0))

(map fib (range 100))
