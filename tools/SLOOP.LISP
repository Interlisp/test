;;; -*- Mode:LISP; Package: SLOOP;  Syntax:COMMON-LISP; Base:10 -*- ;;;;;;;;
;;;                                                                    ;;;;;
;;;     Copyright (c) 1985,86 by William Schelter,                     ;;;;;
;;;     All rights reserved                                            ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;Report bugs to atp.schelter@r20.utexas.edu
;;It comes with ABSOLUTELY NO WARRANTY but we hope it is useful.


;;The following code is meant to run in COMMON LISP and to provide
;;extensive iteration facilities, with very high backwards compatibility
;;with the traditional loop macro. It is meant to be publicly available!
;;Anyone is hereby given permission to copy it provided he does not make
;;ANY changes to the file unless he is William Schelter.  He may change
;;the behavior after loading it by resetting the global variables such
;;as like *Use-locatives*, *automatic-declarations*,..  listed at the
;;beginning of this file.  The original of this file is on
;;r20.utexas.edu:<atp.schelter>sloop.lisp  I am happy to accept suggestions
;;for different defaults for various implementations, or for improvements.

;;If you want to redefine the common lisp loop you may include in your code:
;;(defmacro loop (&body body)
;;  (parse-loop body))

;;         Principal New Features

;;Sloop is extremely user extensible so that you may easily redefine most
;;behavior, or add additional collections, and paths.  There are a number
;;of such examples defined in this file, including such constructs as
;;"for V in-fringe X", "sum V", "averaging V", "for SYM in-package Y",
;;"collate V" (for collecting X into an ordered list), "for (ELT I) in-array AR",
;;"for (KEY ELT) in-table FOO" (if foo is a hash table).  And of course
;;you can combine any collection method with any path.
;;Also there is iteration over products so that you may write
;;(sloop for I below K
;;       sloop (for J below I
;;          	    collecting (foo I J)))
;;Declare is fully supported.  The syntax would be
;;(sloop for u in l with v = 0
;;       declare (fixnum u v)
;;       do ....

;;This extensibility is gained by the ability to define a "loop-macro",
;;which plays a role analagous to an ordiary lisp macro.  See eg.
;;definitions near that of "averaging".  Essentially a "loop-macro"
;;takes some arguments (supplied from the body of the loop following its
;;occurrence, and returns a new form to be stuffed onto the front of the
;;loop form, in place of it and its arguments).
 
;;Compile notes:
;;For dec-20 clisp load the lisp file before compiling.


;;there seems to be no unanimity about what in-package etc. does on loading
;;and compiling a file.  The following is as close to the examples in
;;the Common Lisp manual, as we could make it.
;;The user should put (require "SLOOP") and then (use-package "SLOOP") 
;;early in his init file.  Note use of the string to avoid interning 'sloop
;;in some other package.

(provide "SLOOP")

(in-package "SLOOP"  :use '(LISP))  
 
(export '(loop-return sloop def-loop-collect def-loop-map
		      def-loop-for def-loop-macro local-finish
		      #-lispm loop-finish) (find-package "SLOOP"))
 
 
;;some variables that may be changed to suit different implementations:

(eval-when (compile load eval)

(defparameter *use-locatives* nil "See sloop.lisp")   ;#+lispm t #-lispm nil 
;;If t should have locf, such that (setf b nil) (setq a (locf b)) then if
;;(setf (cdr a) (cons 3 nil)) b==>(3).  This is useful for building lists
;;starting with a variable pointing to nil, since otherwise we must check
;;each time if the list has really been started, before we do a 
;;(setf (cdr b) ..)

(defparameter *Automatic-declarations*
	      #+lispm nil
  #-lispm
  '(:from fixnum
	  :in #+kcl object #-kcl t
	  :collect #+kcl object #-kcl t :count fixnum :max fixnum) "See sloop.lisp")
;;Automatic declarations for variables in the stepping and collecting,
;;so for i below n, gives i and n a :from declaration (here fixnum)
;;for item in lis, gives (declare (t item))

(defparameter *macroexpand-hook-for-no-copy* #-(or lmi ti) 'funcall #+(or lmi ti) t)
;;some lisps remember a macro so that (loop-return) will expand eq forms
;;always in the same manner, even if the form is in a macrolet! To defeat this feature
;;we copy all macro expansions unless *macro-expand-hook* = *macroexpand-hook-for-no-copy*
)

;;*****ONLY CONDITIONALIZATIONS BELOW HERE SHOULD BE FOR BUG FIXES******
;;eg. some  kcls don't return nil from a prog by default!

;;all macros here in here.
(eval-when (compile eval load)

(defparameter *sloop-translations* '((appending . append)
			 ((collecting collect) . collect)
			 ((maximizing maximize) . maximize)
			 ((minimizing minimize) . minimize)
			 (nconcing . nconc)
			 ((count counting) . count)
			 (as . for)
			 (in-fringe . in-fringe)
			 (collate . collate)
			 (in-table . in-table)
			 (in-carefully . in-carefully)
			 (averaging . averaging)
			 (in-array . in-array))
  "A list of cons's where the translation is the cdr, and the car
is a list of names or name to be translated.  Essentially allows 'globalizing'
a symbol for the purposes of being a keyword in a sloop")


(defparameter *additional-collections* nil)

(defmacro lcase (item &body body)
  (let (bod last-case tem)
    (do ((rest body (cdr rest)) (v))
	((or last-case (null rest)))
      (setq  v (car rest))
      (push
	(cond ((eql (car v) t) (setq last-case t) v)
	      ((eql (car v) :collect)
	       `((loop-collect-keyword-p .item.) ,@ (cdr v)))
	      ((eql (car v) :no-body)
	       `((parse-no-body  .item.) ,@ (cdr v)))
	      ((setq tem
		     (member (car v) '(:sloop-macro :sloop-for :sloop-map)))
	       `((get .item. ,(car tem)) ,@ (cdr v)))
	      (t
	       `((l-equal .item. ',(car v)) ,@ (cdr v))))
	bod))
    (or last-case (push `(t (error "lcase fell off end ~a  " .item.)) bod))
    `(let ((.item. ,item))
       (cond ,@ (nreverse bod)))))

(define-setf-method cons (a b)
  (let ((store (gensym "store")))
    (values nil nil (list store)
	    `(progn ,@ (and a  `((setf ,a (car ,store))))
		    ,@ (and b  `((setf ,b (cdr ,store)))))
	    `(error "You should not be setting this"))))

(defmacro cons-for-setf (form)
  (cond ((symbolp form) form)
	((consp form)
	 (cond ((cdr form)
		`(cons (cons-for-setf ,(car form))  (cons-for-setf  ,(cdr form))))
	       (t `(cons (cons-for-setf ,(car form)) nil))))))

(defmacro desetq (form val)
  "(desetq (a b) '(3 4)) would work.  This is destructured setq"
  `(setf (cons-for-setf ,form) ,val))
 
(defmacro loop-return (&rest vals)
  (cond ((<=  (length vals) 1)
	 `(return ,@ vals))
	(t`(return (values  ,@ vals)))))

(defmacro loop-finish ()
  `(go finish-loop))

(defmacro local-finish ()
  `(go finish-loop))

(defmacro sloop (&body body)
  (parse-loop body))
  
(defmacro def-loop-map (name args &body body)
  (def-loop-internal name args body 'map))
(defmacro def-loop-for (name args &body body )
  (def-loop-internal name args body 'for nil 1))
(defmacro def-loop-macro (name args &body body)
  (def-loop-internal name args body 'macro))
(defmacro def-loop-collect (name arglist &body body )
       "Define function of 2 args arglist= (collect-var value-to-collect)"
  (def-loop-internal name arglist body 'collect '*additional-collections* 2 2))

(defmacro sloop-swap ()
 `(progn (rotatef a *loop-bindings*)
  (rotatef b  *loop-prologue*)
  (rotatef c *loop-epilogue*)
  (rotatef e *loop-end-test*)
  (rotatef f *loop-increment*)
  (setf *inner-sloop* (not *inner-sloop*))
  ))

)

(defun l-equal (a b)
  (and (symbolp a)
       (cond ((symbolp b)
	      (equal (symbol-name a) (symbol-name b)))
	     ((listp b)
	      (member  a b :test 'l-equal)))))

(defun loop-collect-keyword-p (command)
  (or (member command '(collect append nconc sum count) :test 'l-equal)
      (find command *additional-collections* :test 'l-equal)))
 			 
(defun translate-name (name)
  (cond ((and (symbolp name)
	      (cdar (member name *sloop-translations* :test 'l-equal :key 'car))))
	(t name)))

(defun loop-pop () (declare (special *last-val* *loop-form*))
  (cond (*loop-form*
	 (setq *last-val* (translate-name (pop *loop-form*))))
	(t (setq *last-val* 'empty-form) nil)))

(defun loop-un-pop ()  (declare (special *last-val* *loop-form*))
  (case *last-val*
	(empty-form nil)
	(already-un-popped (error "you are un-popping without popping"))
	(t  (push *last-val* *loop-form*) (setf *last-val* 'alread-un-popped))))

(defun loop-peek () (declare (special *last-val* *loop-form*))
  (translate-name (car *loop-form*)))

(defun parse-loop (form &aux inner-body)
  (let ((*loop-form* form)
	(*Automatic-declarations* *Automatic-declarations*)
	*last-val* *loop-map*
	*loop-body* 
	*loop-name*
	*loop-prologue* *inner-sloop*
	*loop-epilogue* *loop-increment*
	*loop-collect-pointers*  *loop-map-declares*
	*loop-collect-var* 	*no-declare*
	*loop-end-test*
	*loop-bindings* 
	*product-for* local-macros
	(finish-loop 'finish-loop)
	)
    (declare (special *loop-form* *last-val* *loop-map*
		      *loop-collect-pointers*
		      *loop-name* *inner-sloop*
		      *loop-body*
		      *loop-prologue* 
		      *no-declare*
		      *loop-bindings*
		      *loop-collect-var*  *loop-map-declares*
		      *loop-epilogue* *loop-increment*
		      *loop-end-test* *product-for*
		      ))
    (parse-loop1)
    (when (or *loop-map* *product-for*)
      (or *loop-name* (setf *loop-name* (gensym "SLOOP")))
      (and (eql 'finish-loop finish-loop)
	   (setf finish-loop (gensym "FINISH"))))
    (and *loop-name*
	 (push 
	   `(loop-return (&rest vals) `(return-from ,',*loop-name* (values ,@ vals)))
	   local-macros))
    (unless (eql finish-loop 'finish-loop)
      (push 	 `(loop-finish () `(go ,',finish-loop)) local-macros)
      (push 	 `(local-finish () `(go ,',finish-loop)) local-macros))
    (and *loop-collect-var*
	 (push   `(return-from ,*loop-name* , *loop-collect-var*)
		 *loop-epilogue*))
    (setq inner-body (append  *loop-end-test*
			      (nreverse *loop-body*)
			      (nreverse	*loop-increment*)))
    (cond (*loop-map*
	   (setq inner-body (substitute-sloop-body inner-body)))
	  (t (setf inner-body (cons 'next-loop
				    (append inner-body '((go next-loop)))))))
    (let ((bod 
	    `(macrolet ,local-macros
	       (block ,*loop-name*
		 (tagbody
		     ,@ (append
		          (nreverse *loop-prologue*)
			  inner-body
			  `(,finish-loop)
			  (nreverse *loop-epilogue*)
			  #+kcl '((loop-return  nil))))))
	    
	    ))
      ;;temp-fix..should not be necessary but some lisps cache macro expansions.
      ;;and ignore the macrolet!!
      (unless  (eql *macroexpand-hook* *macroexpand-hook-for-no-copy*)
	(setf bod (copy-tree bod)))
      (dolist (v *loop-bindings*)
	(setf bod
	      `(let ,(car v) ,@(and (cdr v) `(,(cons 'declare (cdr v))))
		    ,bod)))
      bod
      ))) 

(defun parse-loop1 ()
  (declare (special *loop-form*
		    *loop-body* *loop-increment*
		    *no-declare* *loop-end-test*
		    *loop-name* ))
  (lcase (loop-peek)
     (named (loop-pop) (setq *loop-name* (loop-pop)))
     (t nil))
  (do ((v (loop-pop) (loop-pop)))
      ((and (null v) (null *loop-form*)))
    (lcase v
      (:no-body)
      (for (parse-loop-for))
      (while (push
	       `(or ,(loop-pop) (loop-finish))  *loop-body*))
      (until (push
	       `(and ,(loop-pop) (loop-finish))  *loop-body*))
      (do (setq *loop-body* (append (parse-loop-do) *loop-body*)))
      ((when unless) (setq *loop-body* (append (parse-loop-when) *loop-body*)))
      (:collect      (setq *loop-body* (append (parse-loop-collect) *loop-body*)))
      )))


(defun parse-no-body (com &aux (found t) (first t))
  "Reads successive no-body-contribution type forms, like declare, initially, etc.
which can occur anywhere. Returns t if it finds some
otherwise nil"
  (declare (special *loop-form*
		    *loop-body*
		    *loop-increment*
		    *no-declare* *loop-end-test*
		    *loop-name* ))
  (do ((v com (loop-pop)))
      ((null *loop-form*))
      (lcase v
	((initially finally)(parse-loop-initially v))
	(nil nil)
	(with      (parse-loop-with))
	(declare   (parse-loop-declare (loop-pop) t))
	(nodeclare  (setq *no-declare* (loop-pop)))  ;take argument to be consistent.
	(increment (setq *loop-increment* (append (parse-loop-do) *loop-increment*)))
	(end-test  (setq *loop-end-test* (append (parse-loop-do) *loop-end-test*)))
	(with-unique (parse-loop-with nil t))
	(:sloop-macro (parse-loop-macro v :sloop-macro))
	(t  (cond (first (setf found nil))
		  (t (loop-un-pop)))
	    (return 'done)))
      (setf first nil))
  found)

(defun parse-loop-with (&optional and-with only-if-not-there)
  (let ((var  (loop-pop)))
    (lcase (loop-peek)
      (= (loop-pop)
	 (or (symbolp var) (error "Not a variable ~a" var))
	 (loop-add-binding var (loop-pop) (not and-with) nil nil t only-if-not-there) )
      (t (loop-add-temps var nil nil (not and-with) only-if-not-there)))
    (lcase (loop-peek)
      (and (loop-pop)
	   (lcase (loop-pop)
	     (with (parse-loop-with t ))
	     (with-unique (parse-loop-with t t))
	     ))
      (t nil))))

(defun parse-loop-do (&aux result)
  (declare (special *loop-form*))
  (do ((v (loop-pop) (loop-pop)) )
      (())
    (cond
      ((listp v)
       (push v result)
       (or *loop-form* (return 'done)))
      (t (loop-un-pop) (return 'done))))
  (or result (error "empty clause"))
  result)
  
(defun parse-loop-initially (command )
  (declare (special *loop-prologue* *loop-epilogue* *loop-bindings*))
  (lcase command
    (initially (let ((form (parse-loop-do)))
		 (dolist (v (nreverse form))
		   (cond ((and (listp v)
			       (member (car v) '(setf setq))
			       (eql (length v) 3)
			       (symbolp   (second v))
			       (constantp (third v))
			       (loop-add-binding (second v) (third v) nil nil nil t t)
			       ))
			 (t (setf *loop-prologue* (cons v *loop-prologue*)))))))
    (finally
      (setf *loop-epilogue* (append (parse-loop-do) *loop-epilogue*)))))

(defun parse-one-when-clause ( &aux this-case  (want 'body) v)
  (declare (special *loop-form*))
  (prog nil
	next-loop
	   (and (null *loop-form*) (return 'done))
	   (setq v (loop-pop))
    (lcase v
      (:no-body)
      (:collect (or (eql 'body want) (go finish))
		(setq this-case (append  (parse-loop-collect) this-case))
		(setq want 'and))
      (when  (or (eql 'body want) (go finish))
	(setq this-case (append   (parse-loop-when) this-case))
		(setq want 'and))
      (do    (or (eql 'body want) (go finish))
	   (setq this-case (append   (parse-loop-do) this-case))
		(setq want 'and))
      (and    (or (eql 'and  want) (error "Premature AND"))
	   (setq want 'body))
      (t  (loop-un-pop)(return 'done)))
    (go next-loop)
    finish
    (loop-un-pop))
  (or this-case (error "Hanging conditional"))
  this-case)


(defun parse-loop-when (&aux initial else else-clause )
  (declare (special *last-val* ))
  (let ((test (cond ((l-equal *last-val* 'unless) `(not , (loop-pop)))
		    (t (loop-pop)))))
    (setq initial (parse-one-when-clause))
    (lcase (loop-peek)
      (else
	(loop-pop)
	(setq else t)
	(setq else-clause (parse-one-when-clause)))
      (t nil))
  `((cond (,test ,@ (nreverse initial))
	 ,@ (and else `((t ,@ (nreverse else-clause))))))))

(defun pointer-for-collect (collect-var)
  (declare (special *loop-collect-pointers*))
  (or (cdr (assoc collect-var *loop-collect-pointers*))
      (let ((sym(loop-add-binding (gensym "POIN") nil nil :collect )))
	(push (cons collect-var sym)
	      *loop-collect-pointers*)
	sym)))

(defun parse-loop-collect ( &aux collect-var pointer name-val)
  (declare (special *last-val* *loop-body* *loop-collect-var*
		    *loop-collect-pointers* *inner-sloop*
		    *loop-prologue* ))
  (and *inner-sloop* (throw 'collect nil))
  (let ((command   *last-val*)
	(val (loop-pop)))
    (lcase (loop-pop)
      (into (loop-add-binding (setq collect-var (loop-pop)) nil nil t nil t ))
      (t (loop-un-pop)
	 (cond (*loop-collect-var* (setf collect-var *loop-collect-var*))
	       (t  (setf collect-var
			 (setf *loop-collect-var*
			       (loop-add-binding (gensym "COLL") nil )))))))
    (lcase command
      ((append nconc collect)
       (setf pointer (pointer-for-collect collect-var))
       (cond (*use-locatives*
	      (pushnew `(setf ,pointer
			      (locf ,collect-var)) *loop-prologue* :test 'equal)))
       (lcase command
	 ( append
	  (unless (and (listp val) (eql (car val) 'list))
	    (setf val `(copy-list ,val))))
	 (t nil)))
      (t nil))
    (cond ((and  (listp val) (not *use-locatives*))
	   (setq name-val (loop-add-binding (gensym "VAL") nil nil)))
	  (t (setf name-val val)))
    (let
      ((result
	 (lcase command
	   ((nconc append)
	    (let ((set-pointer `(and (setf (cdr ,pointer) ,name-val)
				     (setf ,pointer (last (cdr ,pointer))))))
	      (cond (*use-locatives*
		     (list set-pointer))
		    (t
		     `((cond (,pointer ,set-pointer)
			     (t (setf ,pointer (last (setf ,collect-var ,name-val))))))))))
	   (collect
	     (cond (*use-locatives*
		    `((setf (cdr ,pointer) (setf ,pointer (cons ,name-val nil)))))
		   (t `((cond (,pointer (setf (cdr ,pointer)
					      (setf ,pointer (cons ,name-val nil))))
			      (t (setf ,collect-var
				       (setf ,pointer (cons ,name-val nil)))))))))
	   (t (cond ((find command *additional-collections* :test 'l-equal)
		     (loop-parse-additional-collections command collect-var name-val))
		    (t (error "loop fell off end ~a" command)))))))
      (cond ((eql name-val val)
	     result)
	    (t (nconc result `((setf ,name-val ,val) )))))))

(defun loop-parse-additional-collections (command collect-var name-val &aux eachtime)
  (declare (special *loop-prologue* *last-val* *loop-collect-var* *loop-epilogue* ))
  (let* ((com  (find command *additional-collections* :test 'l-equal))
	 (helper (get com :sloop-collect)))
    (let ((form (funcall helper collect-var name-val)))
      (let ((*loop-form* form) *last-val*)
	(declare (special  *loop-form* *last-val*))
	(do ((v (loop-pop) (loop-pop)))
	    ((null *loop-form*))
	  (lcase v
	    (:no-body)
	    (do (setq eachtime (parse-loop-do)))))
	eachtime))))

(defun the-type (symbol type)
  (declare (special *no-declare*))
  (and *no-declare* (setf type nil))
  (and type (setf type (or (getf *Automatic-declarations* type)
			   (and  (not (keywordp type)) type))))
  (cond (type (list 'the type symbol ))
	(t symbol)))

;;keep track of the bindings in a list *loop-bindings*
;;each element of the list will give rise to a different let.
;;the car will be the variable bindings,
;;the cdr the declarations.
(defun loop-add-binding
       (variable value &optional (new-level t) type force-type (force-new-value t)
			 only-if-not-there &aux tem)
  "Add a variable binding to the current or new level.
 If FORCE-TYPE, ignore a *no-declare*.
 If ONLY-IF-NOT-THERE, check all levels."
  (declare (special *loop-bindings*))
  (when  (or new-level (null *loop-bindings*)) (push (cons nil nil) *loop-bindings*))
  (cond ((setq tem (assoc variable (caar  *loop-bindings*) ))
	 (and force-new-value
	      (setf (cdr tem) (and value (list value)))))
	((and (or only-if-not-there (and (null (symbol-package variable))
					 (constantp value)))
	      (dolist (v (cdr *loop-bindings*))
		(cond ((setq tem (assoc variable (car v)))
		       (and force-new-value
			    (setf (cdr tem) (and value (list value))))
		       (return t))))))
	(t (push (cons variable  (and value (list value)))
		 (caar *loop-bindings*))))
  (and type (loop-declare-binding variable type force-type))
  variable)

;(defmacro nth-level (n) `(nth ,n *loop-bindings*))
;if x = (nth i *loop-bindings*)
;(defmacro binding-declares (x) `(cdr ,x)) ;(cons 'declare (binding-declares x)) to get honest declare statement
;(defmacro binding-values (x) `(car ,x))  ;(let (binding-values x) ) to get let.

(defun loop-declare-binding (var type force-type &aux found tem)
  (declare (special *loop-bindings* *Automatic-declarations* *no-declare* *loop-map*))
  (and type (setf type (or (getf *Automatic-declarations* type)
			   (and  (not (keywordp type)) type))))
  (when (and type(or force-type (null *no-declare*)))
    (dolist (v *loop-bindings*)
      (cond ((assoc var (car v))
	     (setq found t)
	     (or (setq tem(member var (cdr v) :key 'cadr))
		 (progn (push  (list nil var) (cdr v)) (setq tem (cdr v))))
	     (setf (caar tem) type))))
    (or found *loop-map* (error "Could not find variable ~a in bindings" var))
    var))

(defun parse-loop-declare (&optional (decl-list (loop-pop)) (force t))
  (dolist (v (cdr decl-list))
    (loop-declare-binding v (car decl-list) force)))
	
(defun loop-add-temps (form &optional val type new-level only-if-not-there)
  (cond ((null form))
	((symbolp form)
	 (loop-add-binding form val new-level type nil  t only-if-not-there))
	((listp form)
	 (loop-add-temps (car form))
	 (loop-add-temps (cdr form)))))

(defun parse-loop-for ( &aux direction)
  (declare (special *loop-form*  *loop-map-declares*  *loop-map* 
		    *loop-body* *loop-increment*
		    *loop-prologue*
		    *loop-epilogue*
		    *loop-end-test*
		    *loop-bindings*
		    ))
  (let* ((var (loop-pop)) test incr
	 (varl var))
    (do ((v (loop-pop) (loop-pop)))
	(())
      (lcase v
	(in (let ((lis (gensym "LIS")))
	      (loop-add-temps var nil :in t)
	      (loop-add-binding lis (loop-pop) nil)
  	      (push  `(desetq ,var (car ,lis)) *loop-body*)
	      (setf incr `(setf ,lis (cdr ,lis)))
	      (setq test   `(null ,lis) )
	      ))
	(on (let ((lis
		    (cond ((symbolp var) var)
			  (t (gensym "LIS")))))
	      (loop-add-temps var nil :in t)
	      (loop-add-binding lis (loop-pop) nil)
	      (setf incr `(setf ,lis (cdr ,lis)))
	      (unless (eql lis var)
		(push `(desetq ,var ,lis) *loop-body*))
	      (setf test `(null ,lis))))
	((upfrom from)
	    (loop-add-binding var (loop-pop) (not(prog1 direction (setf direction 'up))) :from)
	    (setf incr `(setf ,var ,(the-type `(+  ,var 1) :from))))
	(downfrom
	  (loop-add-binding var (loop-pop) (not(prog1 direction (setf direction 'down))) :from)
	  (setf incr `(setf ,var ,(the-type `(-  ,var 1) :from))))
	(by (let ((inc (loop-pop)))
	      (cond ((and (listp inc)(eql (car inc) 'quote))
		     (setf inc (second inc))
		     ))
	      (cond (direction
		      (setf incr (subst inc 1 incr)))
		    (t (setf incr (subst inc 'cdr incr))))))
	(below
	  (let ((lim (gensym "LIM")))
	    (loop-add-binding var 0 (not(prog1 direction (setf direction 'up)))
			      :from nil nil)
	    (loop-add-binding lim (loop-pop) nil :from )
             (or incr (setf incr `(setf ,var ,(the-type `(+  ,var 1) :from))))
	       (setq test `(>= ,var ,lim))))
	(above
	  (let ((lim (gensym "ABOVE")))
	    (loop-add-binding var 0 (not(prog1 direction (setf direction 'down)))
			      :from nil nil)
	    (loop-add-binding lim (loop-pop) nil :from )
	       (or incr (setf incr `(setf ,var ,(the-type `(-  ,var 1) :from))))
	       (setq test `(<= ,var ,lim))))
	(to
	  (let ((lim (gensym "LIM")))
	    (loop-add-binding var 0 (not(prog1 direction (or direction (setf direction 'up))))
			      :from nil nil)
	    (loop-add-binding lim (loop-pop) nil :from )
             (or incr (setf incr `(setf ,var ,(the-type `(+  ,var 1) :from))))
     	     (setq test `(,(if (eql direction 'down) '< '>),var ,lim))))
	(:sloop-for (parse-loop-macro v :sloop-for var ) (setf varl nil)(return 'done))
        (:sloop-map (parse-loop-map v var ) (return nil))
	(t(or ; (null *loop-form*)
	      (loop-un-pop))
	  (return 'done))))
    ;;temporary fix for bad macrolet on explorer and dec-20.
    (and test (push (copy-tree `(and ,test (local-finish))) *loop-end-test*))
    (and incr (push incr *loop-increment*))))

(defun parse-loop-macro (v type &optional initial &aux result)
  (declare (special *loop-form*))
  (let ((helper (get v type)) args)
    (setq args
	  (ecase type
	    (:sloop-for
	     (let ((tem (get v :sloop-for-args)))
	       (or (cdr tem) (error "sloop-for macro needs at least one arg"))
	       (cdr tem)))
	    (:sloop-macro(get v :sloop-macro-args))))
    (let ((last-helper-apply-arg
	    (cond ((member '&rest args) (prog1 *loop-form* (setf *loop-form* nil)))
		  (t (dotimes (i (length args) (nreverse result))
			     (push (car *loop-form*) result)
			     (setf *loop-form* (cdr *loop-form*)))))))
      (setq *loop-form*
	    (append 
	      (case type
		    (:sloop-for (apply helper initial last-helper-apply-arg))
		    (:sloop-macro(apply helper  last-helper-apply-arg)))
	      *loop-form*)))))

(defun parse-loop-map (v var)
  (declare (special *loop-map* *loop-map-declares* *loop-form*))
  (and *loop-map* (error "Sorry only one allowed loop-map per sloop"))
  (let ((helper (get v :sloop-map))
	(args  (get v :sloop-map-args)))
    (or args (error "map needs one arg before the key word"))
    (cond ((member '&rest args)(error "Build this in two steps if you want &rest")))
    (let* (result
	   (last-helper-apply-arg
	     (dotimes (i (1- (length args)) (nreverse result))
	       (push (car *loop-form*) result) (setf *loop-form* (cdr *loop-form*)))))
      (setq *loop-map-declares*
	    (do ((v (loop-pop)(loop-pop)) (result))
		((null (l-equal v 'declare))
		 (loop-un-pop)
		 (and result (cons 'declare result)))
	      (push (loop-pop) result)))
      (setq *loop-map* (apply helper var last-helper-apply-arg))
      nil)))

(defun substitute-sloop-body (inner-body)
  (declare (special *loop-map* *loop-map-declares*))
    (cond (*loop-map*
	   (setf inner-body (list  (subst (cons 'progn inner-body)
					  :sloop-body *loop-map*)))
	   (and *loop-map-declares*
		(setf inner-body(subst *loop-map-declares*
				       :sloop-map-declares inner-body)))))
  inner-body)

;;;**User Extensible Iteration Facility**

(eval-when (compile eval load)
(defun def-loop-internal (name args  body type &optional list min-args max-args
  &aux (*print-case* :upcase) (helper (intern (format nil "~a-SLOOP-~a" name type))))
  (and min-args (or (>= (length args) min-args)(error "need more args")))
  (and max-args (or (<= (length args) max-args)(error "need less args")))
 `(eval-when (load compile eval)
    (defun ,helper ,args
      ,@ body)
    ,@ (and list `((pushnew ',name ,list)))
    (setf (get ',name ,(intern (format nil "SLOOP-~a" type) (find-package 'keyword))) ',helper)
    (setf (get ',name ,(intern (format nil "SLOOP-~a-ARGS" type)(find-package 'keyword))) ',args)))
)
		

;;DEF-LOOP-COLLECT
;;lets you get a handle on the collection var.
;;exactly two args.
;;First arg=collection-variable 
;;Second arg=value this time thru the loop.
(def-loop-collect sum (ans val)
  `(initially (setq ,ans 0)
    do (setq ,ans (+ ,ans ,val))))
(def-loop-collect logxor (ans val)
  `(initially (setf ,ans 0)
  do (setf ,ans (logxor ,ans ,val))
  declare (fixnum ,ans ,val)))
(def-loop-collect maximize (ans val)
  `(initially (setq ,ans nil) 
  do (if ,ans (setf ,ans (max ,ans ,val)) (setf ,ans ,val))
  declare  (fixnum ,val)))
(def-loop-collect minimize (ans val) 
  `(initially (setq ,ans nil)
  do (if ,ans (setf ,ans (min ,ans ,val)) (setf ,ans ,val)) 
  declare  (fixnum ,val)))
(def-loop-collect count (ans val)
  `(initially (setq ,ans 0)
  do (and ,val (setf ,ans (1+ ,ans)))
  declare  (fixnum ,ans )))
(def-loop-collect thereis (ans val) ans  `(do (if ,val (loop-return ,val))))
(def-loop-collect always (ans val) `(initially (setq ,ans t) do (and (null ,val)(loop-return nil))))
(def-loop-collect never (ans val)  `(initially (setq ,ans t) do (and  ,val  (loop-return nil))))
 

;;DEF-LOOP-MACRO
;;If we have done
;(def-loop-macro averaging (x)
;  `(sum ,x into .tot. and count t into .how-many.
;	finally (loop-return (/ .tot. (float .how-many.)))))

;(def-loop-collect average (ans val)
;  `(initially (setf ,ans 0.0)
;    with-unique .how-many. = 0
;    do (setf ,ans (/  (+ (* .how-many. ,ans) ,val) (incf .how-many.)))
;    ))

;;provides averaging with current value the acutal average.
(def-loop-macro averaging (x)
  `(with-unique .average. = 0.0
    and with-unique .n-to-average. = 0
    declare (float .average. ) declare (fixnum .n-to-average.)
    do (setf .average. (/  (+ (* .n-to-average. .average.) ,x) (incf .n-to-average.)))
    finally (loop-return .average.)))


;;then we can write:
;(sloop for x in l when (oddp x) averaging x)


;;DEF-LOOP-FOR
;;def-loop-for and def-loop-macro
;;are almost identical except that the def-loop-for construct can only occur
;;after a for:
;(def-loop-for in-array (vars array)
;  (let ((elt (car vars))
;	(ind (second vars)))
;  `(for ,ind below (length ,array) do (setf ,elt (aref ,array ,ind)))))
;; (sloop for (elt ind) in-array ar when (oddp elt) collecting ind)
;;You are just building something understandable by loop but minus the for.
;;Since this is almost like a "macro", and users may want to customize their
;;own, the comparsion of tokens uses eq, ie. you must import IN-ARRAY to your package
;;if you define it in another one.   Actually we make a fancier in-array
;;below which understands from, to, below, downfrom,.. and can have
;;either (elt ind) or elt as the argument vars.

;;DEF-LOOP-MAP
;;A rather general iteration construct which allows you to map over things
;;It can only occur after FOR.
;;There can only be one loop-map for a given loop, so you want to only
;;use them for complicated iterations.  

(def-loop-map in-table (var table)
  `(maphash #'(lambda ,var :sloop-map-declares :sloop-body) ,table))
;Usage  (sloop for (key elt) in-table table
;              declare (fixnum elt)
;              when (oddp elt) collecting (cons key elt))


(def-loop-map in-package (var package)
  `(do-symbols (,var (find-package ,package))  :sloop-body))

;(defun te()(sloop for sym in-package 'sloop when (fboundp sym) count t)) 

;;in-array that understands from,downfrowm,to, below, above,etc.
;;I used a do for the macro iteration to be able include it here.
(def-loop-for in-array (vars array &rest args)
  (let (elt ind from to)
    (cond ((listp vars) (setf elt (car vars) ind (second vars)))
	  (t (setf elt vars ind (gensym "INDEX" ))))
    (let ((skip (do ((v args (cddr v)) (result))
		    (())
		   (lcase (car v)
		       ((from downfrom) (setf from  t))
		       ((to below above) (setf to t))
		       (by)
		       (t (setq args (copy-list v)) (return (nreverse result))))
		   (push (car v) result) (push (second v) result))))
      (or to (setf skip (nconc `(below (length ,array)) skip)))
      `(for ,ind 
	,@ skip
	with ,elt 
	do (setf ,elt (aref ,array ,ind)) ,@ args))))

;usage: IN-ARRAY
;(sloop for (elt i) in-array ar from 4
;       when (oddp i)
;       collecting elt)

;(sloop for elt in-array ar below 10 by 2
;       do (print elt))


(def-loop-macro sloop (for-loop)
  (lcase (car for-loop)
    (for))
  (let (*inner-sloop* *loop-body* *loop-map* inner-body
	(finish-loop (gensym "FINISH"))
	a b c e f (*loop-form* for-loop))
    (declare (special *inner-sloop* *loop-end-test* *loop-increment*
		      *product-for* *loop-map*
		      *loop-form*  *loop-body*  *loop-prologue*  *loop-epilogue* *loop-end-test*
		      *loop-bindings*
		      ))
    (setf *product-for* t)
    (loop-pop)
    (sloop-swap)
    (parse-loop-for)
     (sloop-swap)
    (do ()
	((null *loop-form*))
      (cond ((catch 'collect  (parse-loop1)))
	    ((null *loop-form*)(return 'done))
	    (t ;(fsignal "hi")
	     (print *loop-form*)
	     (sloop-swap)
	     (parse-loop-collect)
	     (sloop-swap)
	     	     (print *loop-form*)
	     )))
    (sloop-swap)
    (setf inner-body (nreverse *loop-body*))
    (and *loop-map*  (setf inner-body (substitute-sloop-body inner-body)))
    (let ((bod
	    `(macrolet ((local-finish () `(go ,',finish-loop)))
	      (tagbody
		  ,@ (nreverse *loop-prologue*)
	          ,@ (and (null *loop-map*) '(next-loop))
		  ,@ (nreverse *loop-end-test*)
		  ,@ inner-body
		  ,@ (nreverse *loop-increment*)
		  ,@ (and (null *loop-map*) '((go next-loop)))
		  ,finish-loop
		  ,@ (nreverse *loop-epilogue*)))))
      (dolist (v *loop-bindings*)
	(setf bod
	      `(let ,(car v) ,@(and (cdr v) `(,(cons 'declare (cdr v))))
		    ,bod)))
      (sloop-swap)
      `(do ,bod))))

;Usage: SLOOP (FOR 
;(defun te ()
;  (sloop for i below 5
;	 sloop (for j  to i collecting (list i j))))

(def-loop-for in-carefully (var lis)
  "Path with var in lis except lis may end with a non nil cdr" 
  (let ((point (gensym "POINT")))
    `(with ,point and with ,var initially (setf ,point ,lis)
           do(desetq ,var (car ,point))
	   end-test (and (atom ,point)(local-finish))
	   increment (setf ,point (cdr ,point)))))

;usage: IN-CAREFULLY
;(defun te (l)
;  (sloop for v in-carefully l collecting v))

(defvar *collate-order* #'<)

;;of course this should be a search of the list based on the
;;order and splitting into halves.  I have one such written,
;;but for short lists it may not be important.  It takes more space.
(defun find-in-ordered-list
       (it list &optional (order-function *collate-order*) &aux prev)
  (do ((v list (cdr v)))
      ((null v) (values prev nil))
	 (cond ((eql (car v) it) (return (values v t)))
	       ((funcall order-function it (car v))
		(return (values prev nil))))
	 (setq prev v)))

(def-loop-collect collate (ans val)
  "Collects values into a sorted list without duplicates.
Order based order function *collate-order*"
  `(do (multiple-value-bind
       (after already-there )
       (find-in-ordered-list ,val ,ans)
       (unless already-there
	  (cond (after (setf (cdr after) (cons ,val (cdr after))))
		(t (setf ,ans (cons ,val ,ans))))))))

;usage: COLLATE
;(defun te ()
;  (let ((res
;	  (sloop for i below 10
;            sloop (for j downfrom 8 to 0 
;		          collate (* i (mod j (max i 1)) (random 2)))))

(defun map-fringe (fun tree)
      (do ((v tree))
	       (())
	(cond ((atom v)
		    (and v (funcall fun v))(return 'done))
	      ((atom (car v))
		    (funcall fun (car v)))
	      (t (map-fringe fun (car v) )))
	     (setf v (cdr v))))

(def-loop-map in-fringe (var tree)
  "Map over the non nil atoms in the fringe of tree"
  `(map-fringe #'(lambda (,var) :sloop-map-declares :sloop-body) ,tree))

;;usage: IN-FRINGE
;(sloop for v in-fringe '(1 2 (3 (4 5) . 6) 8 1 2)
;       declare (fixnum v)
;       maximize v)
