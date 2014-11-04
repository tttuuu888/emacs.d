;; Cygwin Setting

(when win32p (defvar cygwin-use t))

;; cygwin shell
(when (and win32p cygwin-use)
  (progn (require 'cygwin-mount)
         (cygwin-mount-activate)
         (setenv "LC_ALL" "C")))
