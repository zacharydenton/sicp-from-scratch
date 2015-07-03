(define (square n)
  (* n n))

(define (divides? a b)
  (= (remainder b a) 0))

(define (next n)
  (if (= n 2)
    3
    (+ 2 n)))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (next test-divisor)))))

(define (smallest-divisor n)
  (find-divisor n 2))

(define (prime? n)
  (= n (smallest-divisor n)))

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

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
  (if (fast-prime? n)
    ((report-prime n (- (runtime) start-time)))))

(define (report-prime n elapsed-time)
  (display " *** ")
  (display elapsed-time)
  true)

(define (search-for-primes lower)
  (define (search-iter n count)
    (define next (+ n 2))
    (if (< count 3)
      (if (timed-prime-test n)
        (search-iter next (inc count))
        (search-iter next count))))
  (search-iter (if (odd? lower) lower (inc lower)) 0))

(search-for-primes 10)
(search-for-primes 100)
(search-for-primes 1000)
(search-for-primes 10000)
(search-for-primes 100000)
(search-for-primes 1000000)
