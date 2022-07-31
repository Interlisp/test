(DEFINE-FILE-INFO PACKAGE "XCL-USER" READTABLE "XCL" BASE 10)

(IL:FILECREATED "30-Jul-2022 21:51:55" IL:|{DSK}<home>larry>medley>internal>test>DO-TEST.;5| 40389  

      :CHANGES-TO (OPTIMIZERS DO-TEST IL:DO-TEST)
                  (IL:VARS IL:DO-TESTCOMS)
                  (IL:VARIABLES *ANY-ERRORS* *TEST-CLEANUP-FORMS* *TEST-COMPILE* *TEST-MODE* 
                         *TEST-BATCH-RESULTS* *TEST-FILE-PATTERN* *TEST-FILE-NAME* 
                         IL:*TEST-BATCH-RESULTS* IL:*TEST-FILE-PATTERN* IL:*ANY-ERRORS* 
                         IL:*TEST-CLEANUP-FORMS* IL:*TEST-COMPILE* IL:*TEST-MODE* IL:*TEST-FILE-NAME*
                         )
                  (IL:FUNCTIONS DO-TEST DO-TEST-GROUP RUN-COMPILED-TEST-FILES TEST-DEFMACRO 
                         TEST-DEFUN TEST-SETQ WITHOUT-BATCH-MODE-ERRORS DO-ALL-TESTS 
                         CURRENT-FILE-NAME CL-READFILE DO-TEST-FILE DO-TEST-LIST IL:DO-TEST 
                         IL:DO-TEST-GROUP IL:MUNG-TEST-FILES IL:PREP-TEST-FILE 
                         IL:RUN-COMPILED-TEST-FILES IL:TEST-DEFMACRO IL:TEST-DEFUN IL:TEST-SETQ 
                         IL:WITHOUT-BATCH-MODE-ERRORS IL:EXPECT-ERRORS IL:DO-ALL-TESTS 
                         IL:CURRENT-FILE-NAME IL:CL-READFILE IL:DO-TEST-FILE IL:DO-TEST-LIST 
                         IL:DEFTEST IL:DEFTESTGROUP IL:TEST-EQUAL IL:DEFINE-VERIFIED-TEST 
                         IL:MAKE-TEST-DEFUN IL:VERIFIED-TEST-TO-DO-TEST IL:GET-FORMS IL:COMMENT-P 
                         IL:TYPE-NUMBER)
                  (IL:COMMANDS "COPY-TEST" "E-TEST")
                  (IL:DEFINE-TYPES VERIFIED-TESTS)

      :PREVIOUS-DATE "14-Jun-90 21:15:50" IL:|{DSK}<home>larry>medley>internal>test>DO-TEST.;4|)


; Copyright (c) 1990 by Venue.

(IL:PRETTYCOMPRINT IL:DO-TESTCOMS)

(IL:RPAQQ IL:DO-TESTCOMS
          ((IL:VARIABLES IL:*ANY-ERRORS* IL:*TEST-CLEANUP-FORMS* IL:*TEST-COMPILE* IL:*TEST-MODE* 
                  IL:*TEST-BATCH-RESULTS* IL:*TEST-FILE-PATTERN* IL:*TEST-FILE-NAME*)
           (IL:P (IMPORT '(IL:DO-TEST-FILE IL:DO-ALL-TESTS IL:DO-TEST IL:DO-TEST-GROUP IL:CL-READFILE
                                 IL:EXPECT-ERRORS IL:TEST-DEFUN IL:TEST-DEFMACRO IL:TEST-SETQ 
                                 IL:*TEST-MODE* IL:*TEST-COMPILE* IL:*TEST-BATCH-RESULTS* 
                                 IL:*TEST-FILE-PATTERN* IL:*TEST-FILE-NAME*)
                        "XCL-USER")
                 (DEFPACKAGE "XCL-TEST" (:USE "LISP" "XCL")
                        (:IMPORT IL:DO-TEST-FILE IL:DO-ALL-TESTS IL:DO-TEST IL:DO-TEST-GROUP 
                               IL:CL-READFILE IL:EXPECT-ERRORS IL:TEST-DEFUN IL:TEST-DEFMACRO 
                               IL:TEST-SETQ IL:*TEST-MODE* IL:*TEST-COMPILE* IL:*TEST-BATCH-RESULTS*
                               IL:*TEST-FILE-PATTERN* IL:*TEST-FILE-NAME*)))
           (IL:FUNCTIONS IL:DO-TEST IL:DO-TEST-GROUP IL:MUNG-TEST-FILES IL:PREP-TEST-FILE 
                  IL:RUN-COMPILED-TEST-FILES IL:TEST-DEFMACRO IL:TEST-DEFUN IL:TEST-SETQ 
                  IL:WITHOUT-BATCH-MODE-ERRORS IL:EXPECT-ERRORS IL:DO-ALL-TESTS IL:CURRENT-FILE-NAME
                  IL:CL-READFILE IL:DO-TEST-FILE IL:DO-TEST-LIST)
           
           (IL:* IL:|;;| "For compiled tests:")

           (OPTIMIZERS IL:DO-TEST)
           (IL:COMS 

                  (IL:* IL:|;;| "Support for saving DO-TESTs onto files.  This defines the TESTS filepkg type, with definers DEFTEST and DEFTESTGROUP.  These expand directly into DO-TEST and DO-TEST-GROUP respectively.")

                  (IL:DEFINE-TYPES IL:TESTS)
                  
                  (IL:* IL:|;;| 
                  "Used to define tests:  These expand exactly into DO-TEST and DO-TEST-GROUP")

                  (IL:FUNCTIONS IL:DEFTEST IL:DEFTESTGROUP)
                  
                  (IL:* IL:|;;| "This command will run one or more")

                  (IL:COMMANDS "RUN")
                  (IL:VARS (IL:*DEFINED-TESTS* (MAKE-HASH-TABLE :SIZE 20 :TEST #'EQUAL)))
                  (IL:GLOBALVARS IL:*DEFINED-TESTS*))
           (IL:COMS 

                  (IL:* IL:|;;| "Master definition for VERIFIED-TESTS")

                  (IL:DEFINE-TYPES VERIFIED-TESTS)
                  (IL:FUNCTIONS IL:TEST-EQUAL)
                  (IL:FUNCTIONS IL:DEFINE-VERIFIED-TEST IL:MAKE-TEST-DEFUN)
                  (IL:FUNCTIONS IL:VERIFIED-TEST-TO-DO-TEST IL:GET-FORMS IL:COMMENT-P)
                  (IL:FUNCTIONS IL:TYPE-NUMBER IL:MAKE-TEST-DEFUN)
                  (IL:COMMANDS "COPY-TEST" "E-TEST"))
           (IL:PROP (IL:FILETYPE)
                  IL:DO-TEST)))

(DEFVAR IL:*ANY-ERRORS* NIL)

(DEFVAR IL:*TEST-CLEANUP-FORMS* NIL)

(DEFVAR IL:*TEST-COMPILE* NIL)

(DEFVAR IL:*TEST-MODE* :BATCH)

(DEFVAR IL:*TEST-BATCH-RESULTS* (IL:MEDLEYDIR "tmp/test-results" NIL T T))

(DEFVAR IL:*TEST-FILE-PATTERN* (IL:MEDLEYDIR "internal/test/cases" "*.TEST;" NIL T))

(DEFVAR IL:*TEST-FILE-NAME* "unknown")

(IMPORT '(IL:DO-TEST-FILE IL:DO-ALL-TESTS IL:DO-TEST IL:DO-TEST-GROUP IL:CL-READFILE IL:EXPECT-ERRORS
                IL:TEST-DEFUN IL:TEST-DEFMACRO IL:TEST-SETQ IL:*TEST-MODE* IL:*TEST-COMPILE* 
                IL:*TEST-BATCH-RESULTS* IL:*TEST-FILE-PATTERN* IL:*TEST-FILE-NAME*)
       "XCL-USER")

(DEFPACKAGE "XCL-TEST" (:USE "LISP" "XCL")
       (:IMPORT IL:DO-TEST-FILE IL:DO-ALL-TESTS IL:DO-TEST IL:DO-TEST-GROUP IL:CL-READFILE 
              IL:EXPECT-ERRORS IL:TEST-DEFUN IL:TEST-DEFMACRO IL:TEST-SETQ IL:*TEST-MODE* 
              IL:*TEST-COMPILE* IL:*TEST-BATCH-RESULTS* IL:*TEST-FILE-PATTERN* IL:*TEST-FILE-NAME*))

(DEFMACRO IL:DO-TEST (IL:NAME-AND-OPTIONS &BODY IL:BODY)

   (IL:* IL:|;;| "This is the MACRO for DO-TEST; it does NOT run compiled tests.")

   (IL:* IL:|;;| "!!!*****If you change this, change the optimizer, too*****!!!")

   (LET ((IL:NAME NIL)
         (IL:OPTIONS NIL))
        (COND
           ((CONSP IL:NAME-AND-OPTIONS)
            (SETQ IL:NAME (CAR IL:NAME-AND-OPTIONS))
            (SETQ IL:OPTIONS (CDR IL:NAME-AND-OPTIONS)))
           (T (SETQ IL:NAME IL:NAME-AND-OPTIONS)))
        (IF (OR (EQ IL:*TEST-MODE* :INTERACTIVE)
                (EQ IL:*TEST-MODE* :BATCH-VERBOSE))
            (FORMAT *ERROR-OUTPUT* "Testing... ~S~%" IL:NAME))
        (COND
           ((IL:FMEMB :COMPILED IL:OPTIONS)
            `(FORMAT *ERROR-OUTPUT* "Compiled-only test \"~A\" in file \"~A\" not run.~%"
                    ',IL:NAME
                    (IL:CURRENT-FILE-NAME)))
           (T `(NOT (WHEN (NULL (IL:WITHOUT-BATCH-MODE-ERRORS ,@IL:BODY))
                        (FORMAT *ERROR-OUTPUT* "Test \"~A\" failed in file \"~A\"~%"
                               ',IL:NAME
                               (IL:CURRENT-FILE-NAME))
                        (IL:SETQ IL:*ANY-ERRORS* T)))))))

(DEFMACRO IL:DO-TEST-GROUP (IL:NAME-AND-OPTIONS &BODY IL:BODY)
   (LET ((IL:NAME NIL)
         (IL:OPTIONS NIL))
        (COND
           ((CONSP IL:NAME-AND-OPTIONS)
            (SETQ IL:NAME (CAR IL:NAME-AND-OPTIONS))
            (SETQ IL:OPTIONS (CDR IL:NAME-AND-OPTIONS)))
           (T (SETQ IL:NAME IL:NAME-AND-OPTIONS)))

        (IL:* IL:|;;| "Hack: find :BEFORE and :AFTER clauses in the body and move them out")

        (LOOP (IF (AND (SYMBOLP (CAR IL:BODY))
                       (OR (EQ (CAR IL:BODY)
                               :BEFORE)
                           (EQ (CAR IL:BODY)
                               :AFTER)))
                  (PROGN (IL:SETQ IL:OPTIONS (IL:APPEND IL:OPTIONS (LIST (CAR IL:BODY)
                                                                         (CADR IL:BODY))))
                         (IL:SETQ IL:BODY (CDDR IL:BODY)))
                  (RETURN NIL)))
        `(LET ((IL:*TEST-CLEANUP-FORMS* NIL))
              ,@(AND (BOUNDP 'IL:*COMPILING-TEST-FILES*)
                     `((EVAL-WHEN (COMPILE)
                              (SETQ IL:*TEST-CLEANUP-FORMS* NIL)
                              ,(IGNORE-ERRORS (GETF IL:OPTIONS :BEFORE)))))
              (BLOCK ,IL:NAME
                  ,(IF (OR (EQ IL:*TEST-MODE* :INTERACTIVE)
                           (EQ IL:*TEST-MODE* :BATCH-VERBOSE))
                       (FORMAT *ERROR-OUTPUT* "Testing... ~S~%" IL:NAME))
                  ,(LET ((IL:BEFORE (IGNORE-ERRORS (GETF IL:OPTIONS :BEFORE))))
                        (IF IL:BEFORE
                            `(WHEN (NULL (IL:WITHOUT-BATCH-MODE-ERRORS ,IL:BEFORE T))
                                 (FORMAT *ERROR-OUTPUT* 
                                        ":BEFORE forms for test \"~A\" in file ~S failed."
                                        ',IL:NAME
                                        (IL:CURRENT-FILE-NAME))
                                 (IL:SETQ IL:*ANY-ERRORS* T)
                                 (RETURN-FROM ,IL:NAME))))
                  ,@(IL:|for| IL:B IL:|in| IL:BODY IL:|join| (COND
                                                                ((AND (CONSP IL:B)
                                                                      (EQ (CAR IL:B)
                                                                          'IL:DO-TEST))

                                                                 (IL:* IL:|;;| "DO-TESTs work fine.")

                                                                 (LIST IL:B))
                                                                ((AND (CONSP IL:B)
                                                                      (EQ (CAR IL:B)
                                                                          'IL:DEFTEST))

                                                                 (IL:* IL:|;;| 
                                                              "eplace all the DEFTESTs with DO-TESTs")

                                                                 (LIST (CONS 'IL:DO-TEST (CDR IL:B)))
                                                                 )
                                                                (T (FORMAT *ERROR-OUTPUT* 
                                                                 "Non DO-TEST form in ~S in ~S~%~S~%"
                                                                          IL:NAME (
                                                                                 IL:CURRENT-FILE-NAME
                                                                                   )
                                                                          IL:B))))
                  ,(LET ((IL:AFTER (IGNORE-ERRORS (GETF IL:OPTIONS :AFTER))))
                        (IF IL:AFTER
                            `(WHEN (NULL (IL:WITHOUT-BATCH-MODE-ERRORS ,IL:AFTER T))
                                 (FORMAT *ERROR-OUTPUT* 
                                        ":AFTER forms for test \"~A\" in file ~S failed."
                                        ',IL:NAME
                                        (IL:CURRENT-FILE-NAME))
                                 (SETQ IL:*ANY-ERRORS* T)))))
              (EVAL (CONS 'PROGN IL:*TEST-CLEANUP-FORMS*))
              ,@(AND (BOUNDP 'IL:*COMPILING-TEST-FILES*)
                     `((EVAL-WHEN (COMPILE)
                              (EVAL (CONS 'PROGN IL:*TEST-CLEANUP-FORMS*)))))
              NIL)))

(DEFUN IL:MUNG-TEST-FILES (IL:PATTERN &KEY (IL:COMPILER 'COMPILE-FILE)
                                 (IL:STARTINGLIST))
   (LET ((IL:*COMPILING-TEST-FILES* T))
        (DECLARE (SPECIAL IL:*COMPILING-TEST-FILES*))
        (DOLIST (IL:PN (OR IL:STARTINGLIST (DIRECTORY IL:PATTERN)))
            (LET* ((IL:LOCALFILE (IL:PREP-TEST-FILE IL:PN))
                   (IL:COMPILED-FILE (IGNORE-ERRORS (FUNCALL IL:COMPILER IL:LOCALFILE))))
                  (IF IL:COMPILED-FILE
                      (PROGN (IL:COPYFILE IL:COMPILED-FILE (NAMESTRING (MAKE-PATHNAME :TYPE
                                                                              (PATHNAME-TYPE 
                                                                                     IL:COMPILED-FILE
                                                                                     )
                                                                              :DEFAULTS IL:PN)))
                             (DELETE-FILE IL:COMPILED-FILE))
                      (FORMAT *ERROR-OUTPUT* "Couldn't compile ~a~%" IL:PN))))))

(DEFUN IL:PREP-TEST-FILE (IL:FILE)
   (LET ((IL:OUTFILE (IL:OPENFILE "{core}hack.;1" 'IL:OUTPUT)))
        (FORMAT IL:OUTFILE ";; This is a COMMON LISP FILE, DAMMIT!
(setq XCL-USER::*TEST-FILE-NAME* ~S)
(in-package \"XCL-TEST\")
" (PATHNAME-NAME IL:FILE))
        (IL:COPYFILE IL:FILE IL:OUTFILE)
        (CLOSE IL:OUTFILE)
        "{core}hack.;1"))

(DEFUN IL:RUN-COMPILED-TEST-FILES (IL:PATTERN)

   (IL:* IL:|;;| "I'd like to use IL:DIRECTORY and generate the list incrementally, but IL:DIRECTORY returns upcased filenames, which Unix dislikes... *sigh*...")

   (DOLIST (IL:PN (DIRECTORY IL:PATTERN))
       (LET ((IL:*TEST-FILE-NAME* (PATHNAME-NAME IL:PN)))
            (LOAD IL:PN))))

(DEFMACRO IL:TEST-DEFMACRO (IL:NAME &REST IL:STUFF)
   `(PROGN (IF (FBOUNDP ',IL:NAME)
               (IF (MACRO-FUNCTION ',IL:NAME)
                   (PUSH (LIST 'SETF (LIST 'SYMBOL-FUNCTION (LIST 'MACRO-FUNCTION
                                                                  '',IL:NAME))
                               (LIST 'QUOTE (SYMBOL-FUNCTION (MACRO-FUNCTION ',IL:NAME))))
                         IL:*TEST-CLEANUP-FORMS*)
                   (ERROR "Please don't redefine ~A in a test form" ',IL:NAME))
               (PUSH (LIST 'REMPROP '',IL:NAME ''IL:MACRO-FN)
                     IL:*TEST-CLEANUP-FORMS*))
           (DEFMACRO ,IL:NAME ,@IL:STUFF)))

(DEFMACRO IL:TEST-DEFUN (IL:NAME &REST IL:STUFF)
   `(PROGN (IF (FBOUNDP ',IL:NAME)
               (IF (OR (MACRO-FUNCTION ',IL:NAME)
                       (SPECIAL-FORM-P ',IL:NAME))
                   (ERROR "Please don't redefine ~A in a test form" ',IL:NAME)
                   (PUSH (LIST 'SETF (LIST 'SYMBOL-FUNCTION '',IL:NAME)
                               (LIST 'QUOTE (SYMBOL-FUNCTION ',IL:NAME)))
                         IL:*TEST-CLEANUP-FORMS*))
               (PUSH (LIST 'FMAKUNBOUND '',IL:NAME)
                     IL:*TEST-CLEANUP-FORMS*))
           (IL:EVAL '(DEFUN ,IL:NAME ,@IL:STUFF))))

(DEFMACRO IL:TEST-SETQ (&REST STUFF)
   (LET (UNBINDLIST)
        (DO ((IL:X STUFF (CDDR IL:X)))
            ((NULL IL:X))
          (PUSH `(IF (BOUNDP ',(CAR IL:X))
                     (PUSH (LIST 'SETQ ',(CAR IL:X)
                                 (LIST 'QUOTE (SYMBOL-VALUE ',(CAR IL:X))))
                           IL:*TEST-CLEANUP-FORMS*)
                     (PUSH (LIST 'MAKUNBOUND '',(CAR IL:X))
                           IL:*TEST-CLEANUP-FORMS*))
                UNBINDLIST))
        `(PROGN ,@UNBINDLIST (SETQ ,@STUFF))))

(DEFMACRO IL:WITHOUT-BATCH-MODE-ERRORS (&BODY IL:BODY)
   (COND
      ((EQ IL:*TEST-MODE* :INTERACTIVE)
       `(PROGN ,@IL:BODY))
      (T `(IGNORE-ERRORS ,@IL:BODY))))

(DEFMACRO IL:EXPECT-ERRORS (IL:ERROR-TYPES &REST IL:FORMS)
   `(HANDLER-CASE (PROGN ,@IL:FORMS NIL)
           (,(IF (LISTP IL:ERROR-TYPES)
                 `(OR ,@IL:ERROR-TYPES)
                 IL:ERROR-TYPES)
            (CONDITION)
            (VALUES T CONDITION))))

(DEFUN IL:DO-ALL-TESTS (&KEY (IL:RESULTS IL:*TEST-BATCH-RESULTS*)
                             (IL:PATTERNS (IF (CONSP IL:*TEST-FILE-PATTERN*)
                                              IL:*TEST-FILE-PATTERN*
                                              (LIST IL:*TEST-FILE-PATTERN*)))
                             (IL:SYSOUT-TYPE NIL)
                             (IL:RESUME NIL))
   (LET ((IL:NO-PROBLEMS T)
         (*DEFAULT-PATHNAME-DEFAULTS* (PATHNAME "{ERIS}<LISPCORE>CML>TEST>"))
         (*ERROR-OUTPUT* (IF (EQ IL:RESULTS T)
                             *ERROR-OUTPUT*
                             (OPEN IL:RESULTS :DIRECTION :OUTPUT :IF-EXISTS (IF IL:RESUME
                                                                                :APPEND
                                                                                :NEW-VERSION)))))
        (UNWIND-PROTECT
            (PROGN (IF (NOT IL:RESUME)
                       (PROGN (FORMAT *ERROR-OUTPUT* ";;; Test results for sysout of ~A~%" 
                                     IL:MAKESYSDATE)
                              (IF IL:SYSOUT-TYPE (FORMAT *ERROR-OUTPUT* ";;; Sysout type is ~A~%" 
                                                        IL:SYSOUT-TYPE))
                              (IF IL:*TEST-COMPILE* (FORMAT *ERROR-OUTPUT* 
                                                           ";;; Tests are being compiled~%"))
                              (FORMAT *ERROR-OUTPUT* ";;; Tests run on ~A~%" (IL:DATE))
                              (FORMAT *ERROR-OUTPUT* ";;; Running tests from ~A~2%" IL:PATTERNS)
                              (SETQ IL:*ALL-FILES-REMAINING* (IL:FOR IL:DP IL:IN IL:PATTERNS
                                                                IL:JOIN (IL:DIRECTORY IL:DP))))
                       (FORMAT *ERROR-OUTPUT* ";;;Resuming after dying on file ~S~%" (POP 
                                                                             IL:*ALL-FILES-REMAINING*
                                                                                          )))
                   (IL:|while| IL:*ALL-FILES-REMAINING* IL:|do| (IL:SETQ IL:NO-PROBLEMS
                                                                 (AND (IL:DO-TEST-FILE (CAR 
                                                                             IL:*ALL-FILES-REMAINING*
                                                                                            ))
                                                                      IL:NO-PROBLEMS))
                                                              (IL:|pop| IL:*ALL-FILES-REMAINING*))
                   (FORMAT *ERROR-OUTPUT* "(END-OF-TESTS)"))
            (UNLESS (EQ IL:RESULTS T)
                   (CLOSE *ERROR-OUTPUT*)))
        IL:NO-PROBLEMS))

(DEFMACRO IL:CURRENT-FILE-NAME ()
   `',IL:*TEST-FILE-NAME*)

(DEFUN IL:CL-READFILE (IL:TEST-FILE &OPTIONAL (*READTABLE* IL:CMLRDTBL)
                             (IL:ENDTOKEN "STOP"))
   (LET
    ((IL:TRUE-NAME (PROBE-FILE IL:TEST-FILE))
     IL:FILE-CONTENTS)
    (IF IL:TRUE-NAME
        (COND
           ((IL:LISPSOURCEFILEP IL:TRUE-NAME)

            (IL:* IL:|;;| "IL-format (managed) file.  Read it using IL:READFILE and drop the DEFINE-FILE-INFO form on the front (if there is one), so that it all reads with the right package.")

            (HANDLER-BIND ((WARNING #'(LAMBDA (IL:THE-WARNING)
                                             (FORMAT *ERROR-OUTPUT* "~&While reading ~S: ~A~%" (
                                                                                 IL:CURRENT-FILE-NAME
                                                                                                )
                                                    IL:THE-WARNING)
                                             (MUFFLE-WARNING))))
                   (REMOVE-IF #'(IL:LAMBDA (IL:FORM)
                                  (AND (IL:LISTP IL:FORM)
                                       (IL:FMEMB (CAR IL:FORM)
                                              '(IL:DEFINE-FILE-INFO IL:DECLARE\:))))
                          (IL:READFILE IL:TRUE-NAME))))
           (T 
              (IL:* IL:|;;| "CL format file.  Have to read it carefully.")

              (LET (IL:TEM (*PACKAGE* (FIND-PACKAGE 'XCL-TEST))
                          (*FEATURES* (CONS :NO-STACK-OVERFLOW *FEATURES*)))
                   (SETQ IL:*TEST-FILE-NAME* (NAMESTRING IL:TRUE-NAME))
                   (WITH-COLLECTION
                    (WITH-OPEN-STREAM (IL:TEST-FILE (IL:OPENTEXTSTREAM (IL:MKATOM IL:TEST-FILE)))
                           (HANDLER-BIND ((WARNING #'(LAMBDA (IL:THE-WARNING)
                                                            (FORMAT *ERROR-OUTPUT* 
                                                                   "~&While reading ~S: ~A~%" (
                                                                                 IL:CURRENT-FILE-NAME
                                                                                               )
                                                                   IL:THE-WARNING)
                                                            (MUFFLE-WARNING))))
                                  (LOOP (WHEN (OR (NULL (IGNORE-ERRORS (SETQ IL:TEM (READ 
                                                                                         IL:TEST-FILE
                                                                                          ))))
                                                  (AND (SYMBOLP IL:TEM)
                                                       (STRING= IL:TEM IL:ENDTOKEN)))
                                              (RETURN))
                                        (COLLECT IL:TEM))))))))
        (PROGN (FORMAT *ERROR-OUTPUT* "~%Couldn't find file ~A~%" IL:TEST-FILE)
               NIL))))

(DEFUN IL:DO-TEST-FILE (IL:FILENAME)
   (LET* ((*PACKAGE* (FIND-PACKAGE 'XCL-TEST))
          (IL:*TEST-FILE-NAME* NIL)
          (IL:TEST-FORMS (IL:CL-READFILE IL:FILENAME IL:CMLRDTBL))
          (IL:*ANY-ERRORS* NIL))
         (IL:DO-TEST-LIST IL:TEST-FORMS)
         (IL:|if| IL:*ANY-ERRORS*
             IL:|then| (TERPRI *ERROR-OUTPUT*))
         (NOT IL:*ANY-ERRORS*)))

(DEFUN IL:DO-TEST-LIST (IL:TEST-FORMS &OPTIONAL IL:OPTIONS IL:NAME)

   (IL:* IL:|;;| "Runs thru a list of test froms from a file, executing them one-by-one.  If it finds non-test-looking forms, it warns you, but evaluates the forms anyhow.")

   (LET
    ((IL:DFNFLG NIL))
    (DECLARE (SPECIAL IL:DFNFLG))
    (IL:|if| (NULL IL:TEST-FORMS)
        IL:|then| (FORMAT *ERROR-OUTPUT* "~%(Trouble reading ~A)~%" (IL:CURRENT-FILE-NAME))
              (SETQ IL:*ANY-ERRORS* T)
      IL:|else|
      (IL:|for| IL:FORM IL:|in| IL:TEST-FORMS
         IL:|do|
         (IL:BLOCK 0)
         (IF (AND (CONSP IL:FORM)
                  (IL:FMEMB (CAR IL:FORM)
                         '(IL:DO-TEST IL:DO-TEST-GROUP DEFTEST DEFTESTGROUP IL:DEFTEST 
                                 IL:DEFTESTGROUP)))
             (HANDLER-BIND
              ((WARNING #'(LAMBDA (IL:THE-WARNING)
                                 (FLET ((TEST-NAME NIL (LET ((IL:X (SECOND IL:FORM)))
                                                            (IF (CONSP IL:X)
                                                                (FIRST IL:X)
                                                                IL:X))))
                                       (FORMAT *ERROR-OUTPUT* 
                                              "~&Warning in test ~S in file ~S:~&  ~A~%" (TEST-NAME)
                                              (IL:CURRENT-FILE-NAME)
                                              IL:THE-WARNING)
                                       (MUFFLE-WARNING)))))
              (IF IL:*TEST-COMPILE*
                  (BLOCK COMPILER-PUNT
                      (LET ((IL:COMPILED-FORM (IF (EQ IL:*TEST-MODE* :INTERACTIVE)
                                                  (COMPILE NIL `(LAMBDA NIL ,IL:FORM))
                                                  (IGNORE-ERRORS (COMPILE NIL
                                                                        `(LAMBDA NIL ,IL:FORM))))))
                           (IF (NULL (COMPILED-FUNCTION-P IL:COMPILED-FORM))
                               (LET ((*PRINT-LEVEL* 3)
                                     (*PRINT-LENGTH* 3))
                                    (FORMAT *ERROR-OUTPUT* 
                                           "Compilation of this form in file ~S failed:~%   ~S~%"
                                           (IL:CURRENT-FILE-NAME)
                                           IL:FORM)
                                    (RETURN-FROM COMPILER-PUNT))
                               (IF (NULL (IF (EQ IL:*TEST-MODE* :INTERACTIVE)
                                             (PROGN (FUNCALL IL:COMPILED-FORM)
                                                    T)
                                             (IGNORE-ERRORS (PROGN (FUNCALL IL:COMPILED-FORM)
                                                                   T))))
                                   (LET ((*PRINT-LEVEL* 3)
                                         (*PRINT-LENGTH* 3))
                                        (FORMAT *ERROR-OUTPUT* 
                                              "Compiled code failed for this form in file ~S :~%~S~%"
                                               (IL:CURRENT-FILE-NAME)
                                               IL:FORM))))))
                  (EVAL IL:FORM)))
             (PROGN (UNLESS (MEMBER (CAR IL:FORM)
                                   '(IL:DEFINE-FILE-INFO IL:FILECREATED IL:PRETTYCOMPRINT 
                                           IL:FILESLOAD IL:RPAQQ IL:RPAQ IL:RPAQ? IL:*))
                        (LET ((*PRINT-LEVEL* 3)
                              (*PRINT-LENGTH* 3))
                             (FORMAT *ERROR-OUTPUT* "Non DO-TEST form at top level in ~S~%~S~%"
                                    (IL:CURRENT-FILE-NAME)
                                    IL:FORM)))

                    (IL:* IL:|;;| "Evaluate the form anyway.")

                    (EVAL IL:FORM)))))))



(IL:* IL:|;;| "For compiled tests:")


(DEFOPTIMIZER IL:DO-TEST (IL:NAME-AND-OPTIONS &BODY IL:BODY)

                         (IL:* IL:|;;| "This is the version of DO-TEST for compiling tests.  It DOESN'T check to see if this is a compiled-only test, but DOES 9or will) check to see if it's an interpreted-only test.")

                         (IL:* IL:|;;| 
                      "!!!!!*****If you change the semantics of this, change the MACRO too*****!!!!!")

                         (LET ((IL:NAME NIL)
                               (IL:OPTIONS NIL))
                              (COND
                                 ((CONSP IL:NAME-AND-OPTIONS)
                                  (SETQ IL:NAME (CAR IL:NAME-AND-OPTIONS))
                                  (SETQ IL:OPTIONS (CDR IL:NAME-AND-OPTIONS)))
                                 (T (SETQ IL:NAME IL:NAME-AND-OPTIONS)))
                              (IF (OR (EQ IL:*TEST-MODE* :INTERACTIVE)
                                      (EQ IL:*TEST-MODE* :BATCH-VERBOSE))
                                  (FORMAT *ERROR-OUTPUT* "Testing... ~S~%" IL:NAME))
                              (COND
                                 ((OR (IL:FMEMB :INTERPRET IL:OPTIONS)
                                      (IL:FMEMB :INTERPRET-ONLY IL:OPTIONS)
                                      (IL:FMEMB :INTERPRETED-ONLY IL:OPTIONS)
                                      (IL:FMEMB :INTERPRETED IL:OPTIONS))
                                  `(FORMAT *ERROR-OUTPUT* 
                                          "Interpreted-only test \"~A\" in file \"~A\" not run.~%"
                                          ',IL:NAME
                                          (IL:CURRENT-FILE-NAME)))
                                 (T `(NOT (WHEN (NULL (IL:WITHOUT-BATCH-MODE-ERRORS ,@IL:BODY))
                                              (FORMAT *ERROR-OUTPUT* 
                                                     "Test \"~A\" failed in file \"~A\"~%"
                                                     ',IL:NAME
                                                     (IL:CURRENT-FILE-NAME))
                                              (IL:SETQ IL:*ANY-ERRORS* T)))))))



(IL:* IL:|;;| 
"Support for saving DO-TESTs onto files.  This defines the TESTS filepkg type, with definers DEFTEST and DEFTESTGROUP.  These expand directly into DO-TEST and DO-TEST-GROUP respectively."
)


(DEF-DEFINE-TYPE IL:TESTS "Tests for automated regression testing")



(IL:* IL:|;;| "Used to define tests:  These expand exactly into DO-TEST and DO-TEST-GROUP")


(DEFDEFINER (IL:DEFTEST (:NAME (IL:LAMBDA (IL:BODY)
                                 (COND
                                    ((IL:LISTP (CADR IL:BODY))
                                     (CAADR IL:BODY))
                                    (T (CADR IL:BODY)))))) IL:TESTS (IL:NAME-AND-OPTIONS &BODY 
                                                                           IL:BODY)
   (LET ((IL:NAME (COND
                     ((IL:LISTP IL:NAME-AND-OPTIONS)
                      (CAR IL:NAME-AND-OPTIONS))
                     (T IL:NAME-AND-OPTIONS)))
         (IL:TEST-FORM `(IL:DO-TEST ,IL:NAME-AND-OPTIONS ,@IL:BODY)))
        (SETF (GETHASH IL:NAME IL:*DEFINED-TESTS*)
              IL:TEST-FORM)
        `(IL:DO-TEST ,IL:NAME-AND-OPTIONS ,@IL:BODY)))

(DEFDEFINER (IL:DEFTESTGROUP (:NAME (IL:LAMBDA (IL:BODY)
                                      (COND
                                         ((IL:LISTP (CADR IL:BODY))
                                          (CAADR IL:BODY))
                                         (T (CADR IL:BODY)))))) IL:TESTS (IL:NAME-AND-OPTIONS &BODY 
                                                                                IL:BODY)
   (LET ((IL:NAME (COND
                     ((IL:LISTP IL:NAME-AND-OPTIONS (CAR IL:NAME-AND-OPTIONS)))
                     (T IL:NAME-AND-OPTIONS)))
         (IL:TEST-FORM `(IL:DO-TEST-GROUP ,IL:NAME-AND-OPTIONS ,@IL:BODY)))
        (SETF (GETHASH IL:NAME IL:*DEFINED-TESTS*)
              IL:TEST-FORM)
        `(IL:DO-TEST-GROUP ,IL:NAME-AND-OPTIONS ,@IL:BODY)))



(IL:* IL:|;;| "This command will run one or more")


(DEFCOMMAND "RUN" (&REST IL:TESTS) (IL:FOR IL:TEST IL:IN IL:TESTS
                                      IL:DO (IL:EVAL (GETHASH IL:TEST IL:*DEFINED-TESTS*))))

(IL:RPAQ IL:*DEFINED-TESTS* (MAKE-HASH-TABLE :SIZE 20 :TEST #'EQUAL))
(IL:DECLARE\: IL:DOEVAL@COMPILE IL:DONTCOPY

(IL:GLOBALVARS IL:*DEFINED-TESTS*)
)



(IL:* IL:|;;| "Master definition for VERIFIED-TESTS")


(DEF-DEFINE-TYPE VERIFIED-TESTS "verified regression test")

(DEFUN IL:TEST-EQUAL (IL:X IL:Y)
   (EQUAL IL:X IL:Y))

(DEFDEFINER IL:DEFINE-VERIFIED-TEST VERIFIED-TESTS (IL:NAME IL:MESSAGE &BODY IL:BODY)

   (IL:* IL:|;;| "Assumes the body is a form that returns a value or a list of values (comparable by equal) that may be computed at definition/compile time. NAME is a symbol and MESSAGE is a string to printed at success/failure")

   (LET ((VALUES (COMPILE-FORM `(PROGN ,@IL:BODY))))
        `(EVAL-WHEN (LOAD)
                (FORMAT *ERROR-OUTPUT* "~&Test: ~a, " ,IL:MESSAGE)
                (IF (IL:TEST-EQUAL ',VALUES (PROGN ,@IL:BODY))
                    (FORMAT *ERROR-OUTPUT* "succeeded.~%")
                    (FORMAT *ERROR-OUTPUT* "failed. ***********~%")))))

(DEFMACRO IL:MAKE-TEST-DEFUN (TEST-NAME)
   `(DEFUN ,TEST-NAME ()
       ,@(NTHCDR 3 (IL:GETDEF TEST-NAME 'VERIFIED-TESTS))))

(DEFUN IL:VERIFIED-TEST-TO-DO-TEST (IL:FILENAME PATHNAME &OPTIONAL (IL:LINELENGTH 60))
   (LET* ((IL:ROOT-NAME (INTERN (STRING IL:FILENAME)
                               (FIND-PACKAGE "INTERLISP")))
          (IL:MAKEFILE-ENVIRONMENT (GET IL:ROOT-NAME 'IL:MAKEFILE-ENVIRONMENT)))
         (LET ((*PACKAGE* (FIND-PACKAGE (OR (SECOND (MEMBER :PACKAGE IL:MAKEFILE-ENVIRONMENT :TEST
                                                           #'EQ))
                                            "INTERLISP")))
               (*READTABLE* (IL:FIND-READTABLE (OR (SECOND (MEMBER :READTABLE IL:MAKEFILE-ENVIRONMENT
                                                                  :TEST #'EQ))
                                                   "INTERLISP")))
               (*PRINT-BASE* (OR (SECOND (MEMBER :BASE IL:MAKEFILE-ENVIRONMENT :TEST #'EQ))
                                 10))
               (*PRINT-CASE* :DOWNCASE)
               (*PRINT-ARRAY* T)
               (*PRINT-LEVEL* NIL)
               (*PRINT-LENGTH* NIL)
               (*PRINT-STRUCTURE* T)

               (IL:* IL:|;;| "Interlisp gorp that controls pretty printing")

               (IL:*PRINT-SEMICOLON-COMMENTS* T)
               (IL:FONTCHANGEFLG NIL)
               (IL:\#RPARS NIL)
               (IL:**COMMENT**FLG NIL))
              (DECLARE (GLOBAL IL:FILELINELENGTH IL:PRETTYFLG))
              (DECLARE (SPECIAL IL:FONTCHANGEFLG IL:\#RPARS IL:**COMMENT**FLG 
                              IL:*PRINT-SEMICOLON-COMMENTS*))
              (WITH-OPEN-FILE (STREAM (MAKE-PATHNAME :TYPE "TEST" :VERSION :NEWEST :DEFAULTS PATHNAME
                                             )
                                     :DIRECTION :OUTPUT)
                     (IL:RESETVARS 

                      (IL:* IL:|;;| "Interlisp gorp that controls pretty printing")

                                   ((IL:FILELINELENGTH IL:LINELENGTH)
                                    (IL:PRETTYFLG T))

                      (IL:* IL:|;;| "Identifier")

                                   (FORMAT STREAM "~&;;; File converted on ~A from source ~A" (
                                                                                              IL:DATE
                                                                                               )
                                          IL:ROOT-NAME)
                                   (LET ((IL:DATES (GET IL:ROOT-NAME 'IL:FILEDATES)))
                                        (WHEN IL:DATES
                                            (FORMAT STREAM "~&;;; Original source ~A created ~A"
                                                   (CDAR IL:DATES)
                                                   (CAAR IL:DATES))))
                                   (TERPRI STREAM)
                                   (TERPRI STREAM)

                      (IL:* IL:|;;| "Copyright notice")

                                   (LET ((IL:OWNER (GET IL:ROOT-NAME 'IL:COPYRIGHT)))
                                        (WHEN (AND IL:OWNER (CONSP IL:OWNER))
                                            (FORMAT STREAM ";;; Copyright (c) ")
                                            (DO ((TAIL (CDR IL:OWNER)
                                                       (CDR TAIL)))
                                                ((NULL TAIL))
                                              (FORMAT STREAM "~4d" (CAR TAIL))
                                              (IF (CDR TAIL)
                                                  (PRINC ", " STREAM)))
                                            (FORMAT STREAM " by ~a~%" (CAR IL:OWNER))))
                                   (TERPRI STREAM)
                                   (DOLIST (IL:COM (SYMBOL-VALUE (IL:FILECOMS IL:ROOT-NAME)))
                                       (DOLIST (IL:FORM (IL:GET-FORMS IL:COM))
                                           (PPRINT IL:FORM STREAM)
                                           (TERPRI STREAM)
                                           (IL:BLOCK))))
                     (NAMESTRING STREAM)))))

(DEFUN IL:GET-FORMS (IL:COMMAND)
   (LET
    ((IL:UNSUPPORTED-TYPES '(IL:FNS IL:SPECVARS IL:GLOBALVARS IL:LOCALVARS IL:INITVARS IL:ALISTS 
                                   IL:DEFS IL:INITRECORDS IL:LISPXMACROS IL:MACROS IL:PROPS 
                                   IL:RECORDS IL:SYSRECORDS IL:USERMACROS IL:VARS IL:CONSTANTS EXPORT
                                   IL:RESOURCES IL:INITRESOURCES IL:GLOBALRESOURCES IL:I.S.OPRS 
                                   IL:HORRIBLEVARS IL:UGLYVARS IL:BITMAPS IL:CURSORS IL:ADVICE 
                                   IL:ADVISE IL:COURIERPROGRAMS IL:TEMPLATES IL:PROP IL:FILES 
                                   IL:DECLARE\:))
     (IL:FILEPKGTYPE (CAR IL:COMMAND)))
    (IF (MEMBER IL:FILEPKGTYPE IL:UNSUPPORTED-TYPES :TEST #'EQ)
        (PROGN (WARN "Filepkg type ~s not supported: ~s" IL:FILEPKGTYPE IL:COMMAND)
               NIL)
        (CASE IL:FILEPKGTYPE
            (IL:P (CDR IL:COMMAND))
            (IL:COMS 

               (IL:* IL:|;;| "Recurse")

               (MAPCAN #'(LAMBDA (IL:X)
                                (IL:GET-FORMS IL:X))
                      (CDR IL:COMMAND)))
            ((EVAL-WHEN IL:EVAL-WHEN) 
               `((EVAL-WHEN ,(MAPCAR #'(LAMBDA (IL:SYM)
                                              (INTERN (STRING IL:SYM)
                                                     (FIND-PACKAGE "LISP")))
                                    (SECOND IL:COMMAND))
                        ,@(IL:GET-FORMS (THIRD IL:COMMAND)))))
            ((IL:*) 

               (IL:* IL:|;;| "Comment ")

               (LIST IL:COMMAND))
            (T 
               (IL:* IL:|;;| "Should the filepkgtype of a definer")

               (LET
                ((IL:IGNORED-DEFINERS '(FILE-ENVIRONMENTS IL:DEFINE-TYPES OPTIMIZERS IL:SEDIT-FORMATS
                                              ADVISED-FUNCTIONS IL:COMMANDS IL:SPECIAL-FORMS PROFILES
                                              XCL::WALKER-TEMPLATES))
                 (IL:DEFINER-TYPE (IL:GETFILEPKGTYPE IL:FILEPKGTYPE 'IL:COMMANDS T)))
                (IF (MEMBER IL:DEFINER-TYPE IL:IGNORED-DEFINERS :TEST #'EQ)
                    (UNLESS (EQ IL:DEFINER-TYPE 'FILE-ENVIRONMENTS)
                        (PROGN (WARN "Ignoring definer coms: ~s" IL:COMMAND)
                               NIL))
                    (LET*
                     ((IL:GET-DEF-METHOD (AND IL:DEFINER-TYPE (GET IL:DEFINER-TYPE :DEFINED-BY)
                                              (GET IL:DEFINER-TYPE 'IL:GETDEF)))
                      (IL:DEFS (AND IL:GET-DEF-METHOD
                                    (MAPCAR #'(LAMBDA (IL:NAME)
                                                     (IF (IL:COMMENT-P IL:NAME)
                                                         IL:NAME
                                                         (FUNCALL IL:GET-DEF-METHOD IL:NAME 
                                                                IL:DEFINER-TYPE)))
                                           (CDR IL:COMMAND)))))
                     (CASE IL:DEFINER-TYPE
                         (VERIFIED-TESTS 
                            (SETQ
                             IL:DEFS
                             (MAPCAR
                              #'(LAMBDA
                                 (IL:DEF)
                                 (DESTRUCTURING-BIND
                                  (IL:TAG IL:NAME IL:MESSAGE &BODY IL:BODY)
                                  IL:DEF
                                  (LET
                                   ((VALUES (COMPILE-FORM (REMOVE-COMMENTS `(PROGN ,@IL:BODY)))))
                                   `(IL:DO-TEST ,IL:MESSAGE
                                           (EQUAL ',VALUES ,@(IF (EQ 1 (LENGTH IL:BODY))
                                                                 IL:BODY
                                                                 `((PROGN ,@IL:BODY))))))))
                              IL:DEFS))))
                     (OR IL:DEFS (PROGN (WARN "Can't parse: ~s" IL:COMMAND)
                                        NIL))))))))))

(DEFUN IL:COMMENT-P (IL:FORM)
   (AND (CONSP IL:FORM)
        (EQ (CAR IL:FORM)
            'IL:*)
        (CONSP (CDR IL:FORM))
        (MEMBER (CADR IL:FORM)
               '(IL:\; IL:|;;| IL:|;;;|)
               :TEST
               #'EQ)
        T))

(DEFUN IL:TYPE-NUMBER (TYPE)
   (IL:%CML-TYPE-TO-TYPENUMBER-EXPANDER TYPE))

(DEFMACRO IL:MAKE-TEST-DEFUN (TEST-NAME)
   `(DEFUN ,TEST-NAME ()
       ,@(NTHCDR 3 (IL:GETDEF TEST-NAME 'VERIFIED-TESTS))))

(DEFCOMMAND "COPY-TEST" (FROM TO) (IL:COPYDEF FROM TO 'VERIFIED-TESTS))

(DEFCOMMAND "E-TEST" (IL:NAME) (ED IL:NAME '(:DONTWAIT VERIFIED-TESTS)))

(IL:PUTPROPS IL:DO-TEST IL:FILETYPE :COMPILE-FILE)
(IL:PUTPROPS IL:DO-TEST IL:COPYRIGHT ("Venue" 1990))
(IL:DECLARE\: IL:DONTCOPY
  (IL:FILEMAP (NIL (5614 6827 (IL:DO-TEST 5614 . 6827)) (6829 11340 (IL:DO-TEST-GROUP 6829 . 11340)) (
11342 12441 (IL:MUNG-TEST-FILES 11342 . 12441)) (12443 12796 (IL:PREP-TEST-FILE 12443 . 12796)) (12798
 13145 (IL:RUN-COMPILED-TEST-FILES 12798 . 13145)) (13147 13818 (IL:TEST-DEFMACRO 13147 . 13818)) (
13820 14435 (IL:TEST-DEFUN 13820 . 14435)) (14437 14975 (IL:TEST-SETQ 14437 . 14975)) (14977 15150 (
IL:WITHOUT-BATCH-MODE-ERRORS 14977 . 15150)) (15152 15428 (IL:EXPECT-ERRORS 15152 . 15428)) (15430 
18263 (IL:DO-ALL-TESTS 15430 . 18263)) (18265 18329 (IL:CURRENT-FILE-NAME 18265 . 18329)) (18331 21370
 (IL:CL-READFILE 18331 . 21370)) (21372 21767 (IL:DO-TEST-FILE 21372 . 21767)) (21769 25792 (
IL:DO-TEST-LIST 21769 . 25792)) (30508 30566 (IL:TEST-EQUAL 30508 . 30566)) (31240 31369 (
IL:MAKE-TEST-DEFUN 31240 . 31369)) (31371 35495 (IL:VERIFIED-TEST-TO-DO-TEST 31371 . 35495)) (35497 
39628 (IL:GET-FORMS 35497 . 39628)) (39630 39888 (IL:COMMENT-P 39630 . 39888)) (39890 39969 (
IL:TYPE-NUMBER 39890 . 39969)) (39971 40100 (IL:MAKE-TEST-DEFUN 39971 . 40100)))))
IL:STOP
