(define (double x) (+ x x))
(define (halve x) (/ x 2))

(define (* a b)
  (cond ((= b 0) 0)
        ((= b 1) a)
        ((even? b) (double (* a (halve b))))
        (else (+ a (* a (dec b))))))

(* 1 (* 2 3))
