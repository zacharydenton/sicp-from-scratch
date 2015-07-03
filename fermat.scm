(define (square x)
  (* x x))

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (square (expmod base (/ exp 2) m)) m))
        (else
          (remainder (* base (expmod base (dec exp) m)) m))))

(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (inc (random (dec n)))))

(define (fast-prime? n)
  (define (fast-prime-inner n times)
    (cond ((or (= times 0) (<= n 2)) true)
          ((fermat-test n) (fast-prime-inner n (dec times)))
          (else false)))
  (fast-prime-inner n 10))
  
(zip (range 10) (map fast-prime? (range 10)))
