;;;
;;; this file should be `Index.lisp' and reside in the directory containing the
;;; tsdb(1) test suite skeleton databases (typically a subdirectory `skeletons'
;;; in the tsdb(1) database root directory `*tsdb-home*').
;;;
;;; the file should contain a single un-quote()d Common-Lisp list enumerating
;;; the available skeletons, e.g.
;;;
;;;   (((:path . "english") (:content . "English TSNLP test suite"))
;;;    ((:path . "csli") (:content . "CSLI (ERGO) test suite"))
;;;    ((:path . "vm") (:content . "English VerbMobil data")))
;;;
;;; where the individual entries are assoc() lists with at least two elements:
;;;
;;;   - :path --- the (relative) directory name containing the skeleton;
;;;   - :content --- a descriptive comment.
;;;
;;; the order of entries is irrelevant as the `tsdb :skeletons' command sorts
;;; the list lexicographically before output.
;;;

(((:path . "testsuite/lab2") (:content . "test suite lab 2"))
 ((:path . "testsuite/lab3") (:content . "test suite lab 3"))
 ((:path . "testsuite/lab4") (:content . "test suite lab 4"))
 ((:path . "testsuite/lab5") (:content . "test suite lab 5"))
 ((:path . "testsuite/lab6") (:content . "test suite lab 6"))
 ((:path . "testsuite/lab7") (:content . "test suite lab 7"))
 ((:path . "testsuite/lab8") (:content . "test suite lab 8"))
 ((:path . "testsuite/lab9") (:content . "test suite lab 9"))
 ((:path . "testcorpus/lab7") (:content . "test corpus lab 7"))
 ((:path . "testcorpus/lab8") (:content . "test corpus lab 8"))
 ((:path . "testcorpus/lab9") (:content . "test corpus lab 9")))
