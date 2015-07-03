(define (pi-sum a b)
  (if (> a b)
    0
    ((+ (/ 1.0 (* a (+ a 2))) (pi-sum (+ a 4) b)))))

(display (* 8 (pi-sum 1 100)))
