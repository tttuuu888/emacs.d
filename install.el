;;; install.el --- Parallel package install script

;; Copyright (C) 2019 SeungKi Kim

;; Author: SeungKi Kim <tttuuu888@gmail.com>
;; URL: https://github.com/tttuuu888/.emacs.d
;; Version: 0.3.0

;;; Commentary

;; This script installs packages with parallel processes.
;; This script will work with below conditions.
;; 1. All packages are maintained by 'use-package'
;; 2. (setq use-package-always-ensure t) is included in config;
;;    so that 'use-package' does not have ':ensure t' keyword.

;; Usage:
;; Start initializing with below command.
;; $ emacs -l ~/.emacs.d/install.el -batch -init

(defvar number-of-process 8)

(setq package-archives
      '(("gnu"   . "http://elpa.gnu.org/packages/")
        ("org"   . "https://orgmode.org/elpa/")
        ("melpa" . "http://melpa.org/packages/")))
(package-initialize)


(defun get-package-list ()
  (let ((package-list (list "use-package")))
    (defmacro use-package (package &rest args)
      (unless (or (memq :disabled args)
                  (memq :ensure args))
        `(add-to-list 'package-list (symbol-name ',package))))

    (provide 'use-package)
    (defun package-install (&rest _) nil)
    (defun package-refresh-contents (&rest _) nil)

    (load "~/.emacs.d/init.el")

    package-list))


(defun init-process-check (package-list proc-list output-buffer)
  (let ((any-live-proc t)
        (log-left-packages package-list))
    (while any-live-proc
      (setq any-live-proc nil)
      (dolist (proc proc-list)
        (when (process-live-p proc)
          (setq any-live-proc t)))
      (let ((local-pkg-list log-left-packages)
            (content
             (with-current-buffer output-buffer
               (save-restriction
                 (widen)
                 (buffer-substring-no-properties
                  (point-min)
                  (point-max))))))
        (dolist (pkg local-pkg-list)
          (when (string-match
                 (format "SK %s - Package is installed." pkg)
                 content)
            (let* ((pkg-len (length pkg))
                   (padding (make-string (max 1 (- 25 pkg-len)) ?.)))
              (message (format "%s %s..done." pkg padding)))
            (setq log-left-packages (delete pkg log-left-packages)))))
      ;; (with-current-buffer output-buffer
      ;;   (message (buffer-substring 1 (point-max))))
      (sleep-for 2))))


(defun init-function (&rest _)
  (require 'cl)
  (delete-directory "~/.emacs.d/elpa" t)
  (package-refresh-contents)

  (let* ((package-list (get-package-list))
         (length-of-args (1+ (/ (length package-list) number-of-process)))
         (left-packages package-list)
         (packages nil)
         (output-buffer (generate-new-buffer "install package"))
         (proc-list nil))
    (message (format "\n%s packages will be installed.\n" (length package-list)))
    ;; (print package-list)

    (while left-packages
      (setq packages
            (cl-subseq left-packages
                       0
                       (min (length left-packages) length-of-args)))
      ;; (message (format "len : %s, pkg : %s" length-of-args packages))
      (setq left-packages (nthcdr length-of-args left-packages))
      (apply
       #'start-process
       "Install"
       output-buffer
       "emacs" "-l" "~/.emacs.d/install.el" "-batch" "-install"
       packages)
      (add-to-list 'proc-list (get-buffer-process output-buffer)))

    (init-process-check package-list proc-list output-buffer)
    (message "Init done.")))


(defun install-function (&rest r)
  ;; (message (format "install : %s" command-line-args-left))
  (dolist (pkg command-line-args-left)
    (let ((try-count 3))
      (while (> try-count 0)
        (setq try-count (- try-count 1))
        (package-install (intern pkg) t)))
    (message (format "SK %s - Package is installed." pkg))))


(add-to-list 'command-switch-alist '("-install" . install-function))
(add-to-list 'command-switch-alist '("-init" . init-function))
