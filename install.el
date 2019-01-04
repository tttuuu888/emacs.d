;;; Emacs setting initializing script
;;; start to initializing with below command.
;;; $ emacs -l ~/.emacs.d/install.el -batch -init

(setq package-archives
      '(("gnu"   . "http://elpa.gnu.org/packages/")
        ("org"   . "https://orgmode.org/elpa/")
        ("melpa" . "http://melpa.org/packages/")))
(package-initialize)


(defun get-package-list ()
  (let ((pkg-list (list 'use-package))
        (package-list nil))
    (require 'cl)
    (package-refresh-contents)
    (add-to-list 'load-path "~/.emacs.d/conf.d/")
    (add-to-list 'load-path "~/.emacs.d/conf.d/sk-utils/")

    (defmacro use-package (package &rest args)
      (unless (or (memq :disabled args)
                  (memq :ensure args))
        `(add-to-list 'pkg-list ',package)))

    (require 'conf-general)
    (require 'conf-dev)

    (dolist (pkg pkg-list)
      (when (not (require pkg nil t))
        (add-to-list 'package-list (symbol-name pkg))))
    package-list))


(defun init-function (&rest _)
  (delete-directory "~/.emacs.d/elpa" t)
  (setq package-list (get-package-list))

  (print (format "%s packages will be installed." (length package-list)))
  ;; (print package-list)

  (let* ((process-number 8)
         (length-of-args (max 1 (1+ (/ (length package-list) process-number))))
         (left-packages package-list)
         (packages nil)
         (output-buffer (generate-new-buffer "install package"))
         (proc-list nil))
    (while left-packages
      (setq packages
            (cl-subseq left-packages
                       0
                       (min (length left-packages) length-of-args)))
      ;; (print (format "len arg: %s, left pkg :%s, pkg : %s"
      ;;                length-of-args left-packages packages))
      (setq left-packages (nthcdr length-of-args left-packages))
      (apply
       #'start-process
       "Install"
       output-buffer
       "emacs" "-l" "~/.emacs.d/install.el" "-batch" "-install"
       packages)
      (add-to-list 'proc-list (get-buffer-process output-buffer)))

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
                (princ (format "%s %s..done.\n" pkg padding)))
              (setq log-left-packages (delete pkg log-left-packages)))))
        ;; (with-current-buffer output-buffer
        ;;   (message (buffer-substring 1 (point-max))))
        (sleep-for 2))))
  (message "Init done."))


(defun install-function (&rest r)
  ;; (print (format "install : %s" command-line-args-left))
  (dolist (pkg command-line-args-left)
    (let ((try-count 3))
      (while (> try-count 0)
        (setq try-count (- try-count 1))
        (package-install (intern pkg) t)))
    (print (format "SK %s - Package is installed." pkg))))


(add-to-list 'command-switch-alist '("-install" . install-function))
(add-to-list 'command-switch-alist '("-init" . init-function))
