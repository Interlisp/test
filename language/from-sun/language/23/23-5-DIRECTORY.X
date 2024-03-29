;; Function To Be Tested: DIRECTORY
;;
;; Source:        Steele's book    
;;                Section 23.5	        
;;                Page: 427
;;
;; Created By:    Henry Cate III
;;
;; Creation Date: November 13,1986
;;
;; Last Update:    
;;
;; Filed As:      {ERIS}<LISPCORE>CML>TEST>23-5-DIRECTORY.TEST
;;
;;
;; Syntax:        (DIRECTORY pathname &key)
;;
;;
;;
;; Function Description:
;;     returns a list of pathnames to files
;; 
;; 
;; 
;; Argument(s):   pathname - a pathname
;;			   
;;
;; Returns:       three values 
;;				a) the new name filled in 
;;				b) the truename of file before renamed
;;				c) truename after renamed
;;


(do-test "make sure have the functions for chapter 23"
(unless (fboundp '23check-parse-list)   (load "{eris}<lispcore>cml>test>23-functions.DFASL"))	
	t)

(do-test "make sure able to do a simple directory."
  (let* ((temp-name (string (gensym)))
	    (simple-file (car (23BUILD-LIST-OF-FILENAME-PATHNAMES 
		  "core" 1 nil "TDIR" temp-name)))
	    (expect (concatenate 'string "{CORE}<TDIR>" temp-name ".;1"))
	    (dir-pathname (directory simple-file))
	    (result (and (pathnamep (car dir-pathname))
			(string-equal expect (namestring (first dir-pathname))))))
	(delete-file simple-file)
	result))



(do-test "test error conditions"
   (flet ((handle-expect-errors (value) 
		  (xcl-test:expect-errors (cl:error) 
			(cl:directory value))
		))
   (and
	(handle-expect-errors 54)
	(handle-expect-errors #\h)
	(handle-expect-errors (list 'hi 'bye))
	(handle-expect-errors (make-array '(2 3 4)))
	(handle-expect-errors (make-hash-table))
	(handle-expect-errors (copy-readtable))
	(handle-expect-errors (find-package 'Lisp))
;	(handle-expect-errors (make-random-state))
	T
   )))



STOP
