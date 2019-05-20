;;; install.el --- Parallel package install script

;; Copyright (C) 2019 SeungKi Kim

;; Author: SeungKi Kim <tttuuu888@gmail.com>
;; URL: https://github.com/tttuuu888/.emacs.d
;; Version: 0.5.0

;;; Commentary

;; This script installs all external packages managed by `use-package' as
;; parallel processes.

;; Usage:
;; Start parallel install with below command.
;;  $ emacs -l ~/.emacs.d/install.el -batch -init

;;; Code:

(require 'cl)

(defvar number-of-process 8)

(defun package-archives-init ()
  (setq package-archives
        '(("gnu"   . "http://elpa.gnu.org/packages/")
          ("org"   . "https://orgmode.org/elpa/")
          ("melpa" . "http://melpa.org/packages/")))
  (package-initialize))

(package-archives-init)

(defun get-package-list ()
  (let ((package-list (list 'use-package)))
    (defmacro use-package (pkg &rest args)
      (let ((ensure (memq :ensure args))
            (disabled (memq :disabled args))
            (always-ensure (bound-and-true-p use-package-always-ensure)))
        (unless (or disabled
                    (if always-ensure
                        (and ensure (eq nil (cadr ensure)))
                      (or (not ensure) (eq nil (cadr ensure)))))
          `(add-to-list 'package-list ',pkg))))

    (provide 'use-package)
    (defun package-install (&rest _) nil)
    (defun package-refresh-contents (&rest _) nil)

    (load "~/.emacs.d/init.el")

    (package-archives-init)

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
                (mapcar (lambda (x)
                          (setq target-packages (delq x target-packages)))
                        base-packages)
                (setcar (nthcdr dep result) target-packages))))
          (remove-duplicate-packages-in-depth result (1+ base-depth)))
      packages)))

(defun get-dependency-package-list ()
  (let* ((all-package-list (get-package-list))
         (dep-packages all-package-list)
         (no-dep-packages (list))
         (result (list (seq-filter (lambda (x) (not (package-installed-p x)))
                                   all-package-list))))
    (while dep-packages
      (let ((deps
             (cl-delete-duplicates
              (mapcan
               (lambda (pkg)
                 (let* ((desc (car (cdr (assq pkg package-archive-contents))))
                        (reqs (when desc
                                (seq-filter
                                 (lambda (x) (not (package-installed-p x)))
                                 (mapcar #'car (package-desc-reqs desc))))))
                   (when (and (not reqs) (not (package-installed-p pkg)))
                     (add-to-list 'no-dep-packages pkg))
                   reqs))
               dep-packages))))
        (setq dep-packages deps)
        (when deps (add-to-list 'result deps))))
    (when (or result no-dep-packages)
      (setcar (nthcdr 0 result) (cl-delete-duplicates
                                 (append no-dep-packages (car result)))))
    result))

(defun print-package-installed (package)
  (let* ((pkg-len (length pkg))
         (padding (make-string (max 1 (- 25 pkg-len)) ?.)))
    (message (format "%s %s..done." pkg padding))))

(defun packages-installed-p (left-packages)
  (let ((pkg-list left-packages)
        (pkg-dirs (directory-files package-user-dir)))
    (dolist (pkg pkg-list)
      (let ((directory
             (car (seq-filter
                   (lambda (x) (string= pkg (car (split-string x "-[0-9]"))))
                   pkg-dirs))))
        (when (and directory
                   (seq-filter
                    (lambda (f) (string-match "\.elc$" f))
                    (directory-files
                     (concat (file-name-as-directory package-user-dir)
                             directory))))
          (print-package-installed pkg)
          (setq left-packages (remove pkg left-packages))))))
  left-packages)

(defun init-process-check (package-list proc-list)
  (let ((left-packages (mapcar #'symbol-name package-list)))
    (while (seq-filter (lambda (proc) (process-live-p proc)) proc-list)
      (setq left-packages (packages-installed-p left-packages))
      (sleep-for 1))
    (packages-installed-p left-packages)))

(defun async-install-packages (package-list)
  (let* ((default-args-len (1+ (/ (length package-list) number-of-process)))
         (left-packages package-list)
         (output-buffer (generate-new-buffer "*install-packages*"))
         (proc-list nil))
    (while left-packages
      (let* ((args-len (min default-args-len (length left-packages)))
             (packages (mapcar #'symbol-name
                               (cl-subseq left-packages 0 args-len))))
        (setq left-packages (nthcdr args-len left-packages))
        (apply
         #'start-process
         "Install"
         output-buffer
         "emacs" "-l" "~/.emacs.d/install.el" "-batch" "-install"
         packages)
        (add-to-list 'proc-list (get-buffer-process output-buffer))))
    (init-process-check package-list proc-list)
    ;; (with-current-buffer output-buffer
    ;;   (message (buffer-substring 1 (point-max))))
    ))

(defun init-function (&rest _)
  (delete "-init" command-line-args)
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
  (delete "-install" command-line-args)
  (dolist (pkg command-line-args-left)
    (dotimes (try-count 2)
      (print (format "try %s for %s" try-count pkg))
      (package-install (intern pkg) t))))


(add-to-list 'command-switch-alist '("-install" . install-function))
(add-to-list 'command-switch-alist '("-init" . init-function))
