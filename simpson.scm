(define (sum term a next b)
  (if (> a b)
    0
    ((+ (term a) (sum term (next a) next b)))))

(define (simpson f a b n)
  (define h (/ (- b a) n))
  (define (y k)
    (f (+ a (* k h))))
  (define (coef k)
    (cond ((= k 0) 1)
          ((even? k) 2)
          (else 4)))
  (define (term k)
    (* (coef k) (y k)))
  (* (/ h 3) (sum term 0 inc n)))

(define (cube n)
  (* n n n))

(display (simpson cube 0 1 90))

