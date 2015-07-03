(define (pascal row col)
  (if (or (= row 1) (= col 1) (= row col))
    1
    (+ (pascal (dec row) (dec col))
       (pascal (dec row) col))))

(pascal 5 3)
