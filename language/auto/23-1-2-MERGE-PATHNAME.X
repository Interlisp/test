;; Function To Be Tested: MERGE-PATHNAME
;;
;; Source:        Steele's book    
;;                Section 23.1.2	PATHNAME Functions        
;;                Page: 415
;;
;; Created By:    Henry Cate III
;;
;; Creation Date: November 11,1986
;;
;; Last Update:    
;;
;; Filed As:      {ERIS}<LISPCORE>CML>TEST>23-1-2-MERGE-PATHNAME.TEST
;;
;;
;; Syntax:        (MERGE-PATHNAME pathname &optional defaults default-version)
;;
;;
;;
;; Function Description:
;;     returns the name of the file as a string or symbol
;; 
;; 
;; 
;; Argument(s):   pathname - pointing to a file 
;;			   defaults - the default values
;;			   default-version - the default version
;;
;; Returns:       the name of the file 
;;


(do-test "load functions for chapter 23 tests"
(unless (fboundp '23check-parse-list)   (load "{eris}<lispcore>cml>test>23-functions.dfasl"))
  T)			; get here and functions were defined


(do-test "test a simple case"
  (23check-merge "{CORE}TEMPDEVICE:<TEMPDIR>HELLO.TYPE" "hello" 
	"{CORE}TEMPDEVICE:<TEMPDIR>NAME.TYPE"))


;;; test do same type of test on several different HOSTS




(do-test "test lots of variations in {CORE}"
  (let ((temp-name (string (gensym))))
	(23DRIVE-MERGE-LIST-STREAM 
	  (concatenate 'string "{CORE}TEMPDEVICE:<TEMPDIR>" temp-name ".;1")
	  "CORE" NIL NIL temp-name NIL
	  "CORE" "TEMPDEVICE" "TEMPDIR" temp-name "TYPE" 1)
  ))


	

(do-test "test error conditions"
   (flet ((handle-expect-errors (value) 
		  (xcl-test:expect-errors (cl:error) 
			(MERGE-PATHNAMES value))
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
	T		; get ride of some stuff, what's the better way?
   )))



STOP
