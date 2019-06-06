;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; Slime tutorial                       ;;;
;;;;;; http://www.guba.com/watch/3000054867 ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; SET-UP
;;;; 1. require ASDF on .sbclrc and point to registry directory
;;;; 2. ln -s swank.asd in the registry directory
;;;; 3. On remote machine, start SBCL, (asdf:oos 'asdf:load-op :swank)
;;;; 4. On local machine, ssh -L4005:127.0.0.1:4005 tjw23@remote.machine.edu
;;;; 5. On remote machine, (swank:create-swank-server)
;;;; 6. On local machine, start emacs, M-x slime-connect
;;;;;;
;;;;;; Emacs short-cut keys:
;;;;;;
;;; M-x describe-key
;;;; describe-key combinations

;;; Eval (buffer-file-name)
;;;; tell what file a buffer is accessing

;;; C-M-q
;;;; indent entire form

;;; M-2
;;;; run 2 times the command following it

;;;;;;
;;;;;; Slime short-cut keys
;;;;;;
;;; *
;;; **
;;; ***
;;;; previous evaluated value

;;; C-c C-d d
;;;; describe function in emacs

;;; C-c C-d h
;;;; describe function in hypertext

;;; M-x slime-selector
;;;; short-keys to access buffers and functions for Slime

;;;; REPL commands need slime-repl buffer which is not loaded by default anymore
;;;; In .emacs file, instead of (slime-setup), slime-repl needs:
;;;; (slime-setup '(slime-fancy slime-asdf))
;;;; Or
;;;; (slime-setup '(slime-repl))
;;;; http://thread.gmane.org/gmane.lisp.slime.devel/8128
;;;; REPL commands
;;;; http://common-lisp.net/project/slime/doc/html/Shortcuts.html#Shortcuts
;;; TAB
;;;; Slime completion for keywords and functions
;;; M-p / M-n
;;;; previous / next item/note of Slime REPL buffer in history
;;; t
;;;; In SLDB debugger, show values; can use mouse to click too
;;; v
;;;; In SLDB debugger, show source codes of the corresponding frame
;;; a
;;;; In SLDB debugger, abort and restart, in most cases equal to 0
;;; i
;;;; In SLDB debugger, inspect in frame, test any dynamic values

;;;; others, misc
;;;; *package*, *standard-output*, (make-hash-table)

;;;; morse.asd is defined:
;;;; this package can be loaded by the following in the REPL
;(asdf:operate 'asdf:load-op 'morse)

;;; declaim
;;;; In SBCL, compile optimization preferences
;;;; tell sbcl to care most about safety and debug information, not about speed
;;; C-x C-e
;;;; eval the form immediately preceding the cursor
(declaim (optimize (speed 0) (safety 3) (debug 3)))

;;; C-M-x
;;;; eval the top level form at the position where the cursor is currently inside
(defpackage :morse
  (:use :common-lisp))

;;; , change-package (to change to package :morse)
;;; can also be done in slime-repl by typing ", in RET"
(in-package :morse)

;;; C-c C-c
;;;; compile defun up to top level frame, print only error(s) if any

(defparameter *morse-mapping*
'((#\A ".-")
  (#\B "-...")
  (#\C "-.-.")
  (#\D "-..")
  (#\E ".")
  (#\F "..-.")
  (#\G "--.")
  (#\H "....")
  (#\I "..")
  (#\J ".---")
  (#\K "-.-")
  (#\L ".-..")
  (#\M "--")
  (#\N "-.")
  (#\O "---")
  (#\P ".--.")
  (#\Q "--.-")
  (#\R ".-.")
  (#\S "...")
  (#\T "-")
  (#\U "..-")
  (#\V "...-")
  (#\W ".--")
  (#\X "-..-")
  (#\Y "-.--")
  (#\Z "--..")
  (#\0 "-----")
  (#\1 ".----")
  (#\2 "..---")
  (#\3 "...--")
  (#\4 "....-")
  (#\5 ".....")
  (#\6 "-....")
  (#\7 "--...")
  (#\8 "---..")
  (#\9 "----.")
  (#\. ".-.-.-")
  (#\, "--..--")
  (#\? "..--..")))

;;; C-c C-k
;;;; compile the whole file

;;; C-c <
;;;; slime-list-callers, list callers of a function
;;; C-c >
;;;; slime-list-callees, list callees of a function
(defun character-to-morse (character)
  (second (assoc character *morse-mapping* :test #'char-equal)))

;;; M-x forward-sexp / C-M-f
;;; M-x backward-sexp / C-M-b
;;; M-x transpose-sexps / C-M-t (swap 2 forms)
;;; M-x kill-sexp / C-M-k / e.g. M-2 C-M-k (kill 2 following forms)
(defun morse-to-character (morse-string)
  (first (find morse-string *morse-mapping* :test #'string= :key #'second)))

;;; C-c RET (macro expansion)
;;;; slime-macroexpand-1 display the macro expansion of the form at point

;;; M-.
;;;; jump to source code

;;; C-c C-t
;;;; hit C-c C-t on a function in source to obtain trace outputs
;;;; (untrace) in Slime REPL buffer to cancel tracing
(defun string-to-morse (string)
  (with-output-to-string (morse)
    (write-string (character-to-morse (aref string 0)) morse)
    (loop
       for char across (subseq string 1)
       do (write-char #\Space morse)
       do (write-string (character-to-morse char) morse))))

;;; (require :asdf-install)
;;; (asdf-install:install :split-sequence)
;;;; install and load package :split-sequence from the internet
;;;; or use
;;; (asdf:oos 'asdf:load-op :split-sequence)
;;;; for loading packages that have already been installed

;;; C-c I (Capital letter 'I' in the REPL)
;;;; inspect a package to see what symbols and functions are there
;;;; can use * for the package you have just (find-package)
;;;; can go deeper to look into the symbols and functions documentions

;;; M-n and M-p
;;;; browse (next and previous) compilation notes
(defun morse-to-string (string)
  (with-output-to-string (character-stream)
    (loop
       for morse-char in (split-sequence:split-sequence #\Space string
							:remove-empty-subseqs t)
       do (write-char (morse-to-character morse-char) character-stream))))
