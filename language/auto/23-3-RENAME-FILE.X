;; Function To Be Tested: RENAME-FILE
;;
;; Source:        Steele's book    
;;                Section 23.3	        
;;                Page: 423
;;
;; Created By:    Henry Cate III
;;
;; Creation Date: November 13,1986
;;
;; Last Update:    
;;
;; Filed As:      {ERIS}<LISPCORE>CML>TEST>23-3-RENAME-FILE.TEST
;;
;;
;; Syntax:        (RENAME-FILE file new-name)
;;
;;
;;
;; Function Description:
;;     renames a file
;; 
;; 
;; 
;; Argument(s):   file - an existing file
;;			   new-name - the new name
;;
;; Returns:       three values 
;;				a) the new name filled in 
;;				b) the truename of file before renamed
;;				c) truename after renamed
;;


(do-test "load functions for chapter 23 tests"
(unless (fboundp '23check-parse-list)   (load "{eris}<lispcore>cml>test>23-functions.def"))
  T)			; get here and functions were defined


(do-test "test another simple case"
  (let* ((temp-name (string (gensym)))
	    (simple-file (car (23BUILD-LIST-OF-FILENAME-PATHNAMES 
		  "core" 1 "tempdevice" nil temp-name)))
	    (new-name (concatenate 'string 
			"{CORE}<TDIR>" temp-name ".ren;1"))
	    (new-pathname (make-pathname :host "core" 
		  :directory "tdir" :name temp-name :type "ren"))
	    (result (23check-RENAME new-name simple-file new-pathname)))
	(Delete-file new-pathname) 
	result))

(do-test-group "test do same type of test on several different HOSTS"
	:before (PROGN

(test-defun 23Check-rename-simple (host)
	"complete test for just adding a type"
  (let* ((temp-name (string (gensym)))
	    (simple-file (car (23BUILD-LIST-OF-FILENAME-PATHNAMES 
		  host 1 nil "cmltest" temp-name)))
	    (new-name (concatenate 'string 
			"{" host "}<CMLTEST>" temp-name ".ren;1"))
	    (new-pathname (make-pathname :host host 
		  :directory "cmltest" :name temp-name :type "ren"))
	    (result (23check-RENAME new-name simple-file new-pathname)))
	(Delete-file new-pathname) 
	result))

(test-defun 23Check-rename-name-type (host)
	"complete test for renaming the name and adding type"
  (let* ((temp-name (string (gensym)))
	    (simple-file (car (23BUILD-LIST-OF-FILENAME-PATHNAMES 
		  host 1 nil "cmltest" temp-name)))
	    (new-temp-name (concatenate 'string temp-name "ab"))
	    (new-name (concatenate 'string 
			"{" host "}<CMLTEST>" new-temp-name ".ren;1"))
	    (new-pathname (make-pathname :host host 
		  :directory "cmltest" :name new-temp-name :type "ren"))
	    (result (23check-RENAME new-name simple-file new-pathname)))
	(Delete-file new-pathname) 
	result))

(test-defun 23Check-rename-directory (host)
	"complete test for changing dirctories"
  (let* ((temp-name (string (gensym)))
	    (simple-file (car (23BUILD-LIST-OF-FILENAME-PATHNAMES 
		  host 1 nil "cmltest" temp-name)))
	    (new-temp-name (concatenate 'string temp-name "cd"))
	    (new-name (concatenate 'string 
			"{" host "}<CMLTEST>sub>" new-temp-name ".ren;1"))
	    (new-pathname (make-pathname :host host 
		  :directory "cmltest>sub" :name new-temp-name :type "ren"))
	    (result (23check-RENAME new-name simple-file new-pathname)))
	(Delete-file new-pathname) 
	result))

(test-defun 23Drive-rename-test (host)
	"make sure the tests work"
  (and
	(23Check-rename-simple host)
	(23Check-rename-name-type host)
	(23Check-rename-directory host)
  ))

)	; End of defining functions for this test group.

(do-test "test variations in {core}"
	(23Drive-rename-test "core"))

;DSK vs Pseudo-dsk problem, need to redesign test to handle
;(do-test "test variations in {dsk}"
;	(23Drive-rename-test "dsk"))

(do-test "test variations in {erinyes}"
	(23Drive-rename-test "erinyes"))

)	; end of do-test-group
	

(do-test "test error conditions"
   (flet ((handle-expect-errors (value) 
		  (xcl-test:expect-errors (cl:error) 
			(cl:rename-file value value))
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
	(handle-expect-errors "DF")
	(handle-expect-errors "OCT-6-65")
	(handle-expect-errors 'hello)
	(handle-expect-errors 'bye)
	T
   ))



STOP
