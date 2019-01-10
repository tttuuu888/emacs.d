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

(require 'cl)

(defvar number-of-process 8)

(setq package-archives
      '(("gnu"   . "http://elpa.gnu.org/packages/")
        ("org"   . "https://orgmode.org/elpa/")
        ("melpa" . "http://melpa.org/packages/")))

(package-initialize)

(defun get-package-list ()
  (let ((package-list (list 'use-package)))
    (defmacro use-package (package &rest args)
      (unless (or (memq :disabled args)
                  (memq :ensure args))
        `(add-to-list 'package-list ',package)))

    (provide 'use-package)
    (defun package-install (&rest _) nil)
    (defun package-refresh-contents (&rest _) nil)

    (load "~/.emacs.d/init.el")

    package-list))

(defun remove-duplicate-packages-in-depth (packages &optional depth)
  (let* ((result packages)
         (base-depth (if depth depth 0))
         (base-packages (nth-value base-depth packages)))
    (if (< base-depth (length packages))
        (progn
          (dotimes (dep (length packages))
            (when (> dep base-depth)
              (let ((target-packages (nth-value dep result)))
                (mapcar (lambda (x) (delete x target-packages)) base-packages)
                (setcar (nthcdr dep result) target-packages))))
          (remove-duplicate-packages-in-depth result (1+ base-depth)))
      packages)))

(defun get-dependency-package-list ()
  (let* ((package-list (get-package-list))
         (dep-packages package-list)
         (result (list package-list)))
    (while dep-packages
      (let ((deps
             (cl-delete-duplicates
              (mapcan
               (lambda (pkg)
                 (unless (package-installed-p pkg)
                   (let* ((tr (package-compute-transaction () (list (list pkg))))
                          (pkg-desc (car (last tr)))
                          (deps
                           (seq-filter
                            (lambda (x) (not (package-installed-p x)))
                            (mapcar #'car (package-desc-reqs pkg-desc)))))
                     deps)))
               dep-packages))))
        (setq dep-packages deps)
        (when deps
          (add-to-list 'result deps))))
    result))

(defun print-package-installed (package)
  (let* ((pkg-len (length pkg))
         (padding (make-string (max 1 (- 25 pkg-len)) ?.)))
    (message (format "%s %s..done." pkg padding))))

(defun packages-installed-p (left-packages output-buffer)
  (let ((pkg-list left-packages)
        (pkg-dirs (directory-files "~/.emacs.d/elpa")))
    (dolist (pkg pkg-list)
      (let ((directory
             (car (seq-filter
                   (lambda (x) (string= pkg (car (split-string x "-[0-9]"))))
                   pkg-dirs))))
        (when (and directory
                   (seq-filter
                    (lambda (f) (string-match "\.elc$" f))
                    (directory-files (concat "~/.emacs.d/elpa/" directory))))
          (print-package-installed pkg)
          (setq left-packages (remove pkg left-packages))))))
  left-packages)

(defun init-process-check (package-list proc-list output-buffer)
  (let ((left-packages (mapcar #'symbol-name package-list)))
    (while (seq-filter (lambda (proc) (process-live-p proc)) proc-list)
      (setq left-packages (packages-installed-p left-packages output-buffer))
      ;; (with-current-buffer output-buffer
      ;;   (message (buffer-substring 1 (point-max))))
      (sleep-for 1))
    (packages-installed-p left-packages output-buffer)))

(defun async-install-packages (package-list)
  (let* ((length-of-args (1+ (/ (length package-list) number-of-process)))
         (left-packages package-list)
         (packages nil)
         (output-buffer (generate-new-buffer "install package"))
         (proc-list nil))
    (while left-packages
      (setq packages
            (mapcar #'symbol-name
                    (cl-subseq left-packages
                               0
                               (min (length left-packages) length-of-args))))
      (setq left-packages (nthcdr length-of-args left-packages))
      (apply
       #'start-process
       "Install"
       output-buffer
       "emacs" "-l" "~/.emacs.d/install.el" "-batch" "-install"
       packages)
      (add-to-list 'proc-list (get-buffer-process output-buffer)))
    (init-process-check package-list proc-list output-buffer)))

(defun init-function (&rest _)
  (delete-directory "~/.emacs.d/elpa" t)
  (package-refresh-contents)
  (let* ((deps-list (get-dependency-package-list))
         (packages-list (remove-duplicate-packages-in-depth deps-list))
         (all-packages-count (length (apply #'append packages-list))))
    ;; (print packages-list)
    (message (format "\n%s packages will be installed.\n" all-packages-count))
    (dolist (packages packages-list)
      (async-install-packages packages))

    (message "Init done.")))

(defun install-function (&rest r)
  (dolist (pkg command-line-args-left)
    (dotimes (try-count 3)
      (print (format "try %s for %s" try-count pkg))
      (package-install (intern pkg) t))))


(add-to-list 'command-switch-alist '("-install" . install-function))
(add-to-list 'command-switch-alist '("-init" . init-function))
