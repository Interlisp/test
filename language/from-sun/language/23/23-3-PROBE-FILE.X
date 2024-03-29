;; Function To Be Tested: PROBE-FILE
;;
;; Source:        Steele's book    
;;                Section 23.3	        
;;                Page: 4124
;;
;; Created By:    Henry Cate III
;;
;; Creation Date: November 13,1986
;;
;; Last Update:    
;;
;; Filed As:      {ERIS}<LISPCORE>CML>TEST>23-3-PROBE-FILE.TEST
;;
;;
;; Syntax:        (PROBE-FILE pathname)
;;
;;
;;
;; Function Description:
;;     returns the name of the device as a string or symbol
;; 
;; 
;; 
;; Argument(s):   pathname - pointing to a file 
;;
;; Returns:       the device name
;;


(do-test "load functions for chapter 23 tests"
(unless (fboundp '23check-parse-list)   (load "{eris}<lispcore>cml>test>23-functions.def"))
  T)			; get here and functions were defined


(do-test "test a simple case"
  (let* ((temp-name (string (gensym)))
	    (simple-list (23BUILD-LIST-OF-FILENAME-PATHNAMES 
		  "core" 1 "tempdevice" nil temp-name))
	    (probe-result (probe-file (car simple-list)))
	    (expect (concatenate 'string "{CORE}TEMPDEVICE:" temp-name ".;1"))
	    (result (and (pathnamep probe-result)
			(string-equal (namestring probe-result) expect))))
	(23Delete-file-list simple-list) 
	result))


(do-test-group "test do same type of test on several different HOSTS"
	:before (PROGN

(test-defun 23TEST-PROBE-FILE (temp-pathname expectvalue)
	"check one pathname at a time"
  (let ((probe-result (probe-file temp-pathname)))
  (and
	(pathnamep probe-result)
	(string-equal expectvalue (namestring probe-result))
  )))

(test-defun 23TEST-PROBE-FILE-LIST (big-list expectvalue)
	"check that each item in the list exists, and give the right pathname"
  (cl:every #'(lambda (item) (23TEST-PROBE-FILE item expectvalue)) big-list))

(test-defun 23DRIVE-PROBE-FILE-LIST (host device directory name type expectvalue)
	"build the list and check get what want"
  (let* ((delete-list (23BUILD-LIST-OF-STREAM host 1 
			device directory name type))
	    (big-list (23Multiply-stream delete-list))
	    (result (23TEST-PROBE-FILE-LIST big-list expectvalue)))
	(23Delete-file-list delete-list)
	result)) 


)	; End of defining functions for this test group.


(do-test "test lots of variations in {CORE}"
  (let ((temp-name (string (gensym))))
  (and
	(23DRIVE-PROBE-FILE-LIST "CORE" NIL "TDIR" temp-name NIL
		(concatenate 'string "{CORE}<TDIR>" temp-name ".;1"))
	(23DRIVE-PROBE-FILE-LIST "CORE" "TEMPDEVICE" "TDIR" temp-name NIL
		(concatenate 'string "{CORE}TEMPDEVICE:<TDIR>" temp-name ".;1"))
	(23DRIVE-PROBE-FILE-LIST "CORE" NIL "CMLTEST>SUB" temp-name "TYPE"
		(concatenate 'string "{CORE}<CMLTEST>SUB>" temp-name ".TYPE;1"))
	(23DRIVE-PROBE-FILE-LIST "CORE" "TEMPDEVICE" "TDIR" temp-name "TYPE"
		(concatenate 'string "{CORE}TEMPDEVICE:<TDIR>" temp-name ".TYPE;1"))
  )))

;For now don't worry about, problem with DSK vs PSEUDO-DSK
;(do-test "test lots of variations in {DSK}"
;  (let ((temp-name (string (gensym))))
;  (and
;	(23DRIVE-PROBE-FILE-LIST "DSK" NIL "TDIR" temp-name NIL
;		(concatenate 'string "{DSK}<TDIR>" temp-name ".;1"))
;	(23DRIVE-PROBE-FILE-LIST "DSK" "TEMPDEVICE:" "TDIR" temp-name NIL
;		(concatenate 'string "{DSK}TEMPDEVICE:<TDIR>" temp-name ".;1"))
;	(23DRIVE-PROBE-FILE-LIST "DSK" NIL "CMLTEST>SUB" temp-name "TYPE"
;		(concatenate 'string "{DSK}<CMLTEST>SUB>" temp-name ".TYPE;1"))
;	(23DRIVE-PROBE-FILE-LIST "DSK" "TEMPDEVICE:" "TDIR" temp-name "TYPE"
;		(concatenate 'string "{DSK}TEMPDEVICE:<TDIR>" temp-name ".TYPE;1"))
;  )))

(do-test "test lots of variations in {ERINYES}"
  (let ((temp-name (string (gensym))))
  (and
	(23DRIVE-PROBE-FILE-LIST "ERINYES" NIL "CMLTEST" temp-name NIL
		(concatenate 'string "{ERINYES}<CMLTEST>" temp-name ".;1"))
	(23DRIVE-PROBE-FILE-LIST "ERINYES" NIL "CMLTEST>SUB" temp-name "TYPE"
		(concatenate 'string "{ERINYES}<CMLTEST>SUB>" temp-name ".TYPE;1"))
  )))


)	; end of do-test-group


(do-test "test for files not there"
  (and
	(not (probe-file "{core}fdadzzzzzzzzzzxxxxx."))
	(not (probe-file "{core}fdadzzzzzzzzzzxxxxx.dfwqe"))
	(not (probe-file "{zzzzzz}aaaaaa.aaaadfzzz"))
	(not (probe-file "{zzzzzz}dfdad:aaaaaa.aaaadfzzz"))
	(not (probe-file "{zzzzzz}dfdad:<dfkljdas>aaaaaa.aaaadfzzz"))
  ))

(do-test "test error conditions"
   (and
	(not (probe-file 54))
	(not (probe-file #\h))
	(not (probe-file (list 'hi 'bye)))
	(not (probe-file (make-array '(2 3 4))))
	(not (probe-file (make-hash-table)))
	(not (probe-file (copy-readtable)))
	(not (probe-file (find-package 'Lisp)))
;	(not (probe-file (make-random-state)))
	(not (probe-file "DF"))
	(not (probe-file "OCT-6-65"))
	(not (probe-file 'hello))
	(not (probe-file 'bye))
   ))



STOP
