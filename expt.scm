(define (fast-expt b n)
  (define (expt-iter x acc)
    (if (>= x n)
      acc
      (if (and (> x 0) (<= (* x 2) n))
        (expt-iter (* x 2) (* acc acc))
        (expt-iter (inc x) (* acc b)))))
  (expt-iter 0 1))

(define (exp2 x) (fast-expt 2 x))
(map exp2 (range 20))
