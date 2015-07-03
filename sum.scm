(define (sum term a next b)
  (if (> a b)
    0
    ((+ (term a) (sum term (next a) next b)))))

(define (pi-sum a b)
  (define (term n)
    (/ 1.0 (* n (+ n 2))))
  (define (next n)
    (+ n 4))
  (sum term a next b))

(define (cube n)
  (* n n n))

(define (sum-cubes a b)
  (sum cube a inc b))

(define (integral f a b dx)
  (define (add-dx x) (+ x dx))
  (* (sum f (+ a (/ dx 2.0)) add-dx b) dx))

(display (* 8 (pi-sum 1 100)))
(display (sum-cubes 1 10))
(display (integral cube 0 1 0.05))
