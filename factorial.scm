(define (factorial n)
  (define (fact-iter acc i)
    (define next (+ i 1))
    (if (= n i)
      acc
      (fact-iter (* acc next) next)))
  (fact-iter 1 1))
(factorial 100)

