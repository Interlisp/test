;: Test File for Function: plusp
;; Source:	 Steel's Book, Chapter 12, Section 2, page 196
;; Created by: John Park  ;; Creation Date: May 1, 86
;; Predicate: The plus predicate is true if number is greater than zero and false otherwise.
;; Syntax Format:  (plusp number)
;; Input: number (positive number or non-complex number)
;; Output: T or NIL

(do-test plusp-test
			(and (plusp 1)
				(plusp 4.0)
				(plusp  +79)
				(not (plusp 0))
				(not (plusp -9))))				