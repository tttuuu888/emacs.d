;;; My emacs setting initializing script
;;; start to initializing with below command.
;;; $ emacs -l ~/.emacs.d/install.el -batch -init

(setq package-archives
      '(("gnu"   . "http://elpa.gnu.org/packages/")
        ("org"   . "https://orgmode.org/elpa/")
        ("melpa" . "http://melpa.org/packages/")))
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/conf.d/")
(add-to-list 'load-path "~/.emacs.d/conf.d/sk-utils/")


(defun install-function (&rest r)
  (message (format "install : %s" command-line-args-left))
  ;; (package-refresh-contents)
  ;; (package-read-all-archive-contents)
  ;; (package--build-compatibility-table)
  (message (format "install : %s" command-line-args-left))
  ;; (print (format "install : %s" command-line-args-left))
  (dolist (pkg command-line-args-left)
    (let ((result "")
          (try-count 3))
      (while (and (not (equal (last (split-string result "install")) "ed"))
                  (> try-count 0))
        (setq try-count (- try-count 1))
        (package-install (intern pkg)t)))
    (print (concat pkg " ...done")))
  )


(defun init-function (&rest _)
  (require 'cl)
  (defvar pkg-list (list 'use-package))
  (package-refresh-contents)
  (defmacro use-package (package &rest args)
    (unless (or (memq :disabled args)
                (memq :ensure args))
      `(add-to-list 'pkg-list ',package)))

  (require 'conf-general)
  (require 'conf-dev)

  (print pkg-list)

  (setq package-list nil)
  (dolist (pkg pkg-list)
    (when (not (require pkg nil t))
      (add-to-list 'package-list (symbol-name pkg))))

  (print (format "pkg num : %s" (length package-list)))
  (print package-list)

  (let* ((process-number 8)
         (length-of-args (max 1 (1+ (/ (length package-list) process-number))))
         (left-packages package-list)
         (packages nil)
         (output-buffer (generate-new-buffer "install package"))
         (proc
          (progn

            ;; (dolist (pkg package-list)
            ;;   (start-process
            ;;    pkg output-buffer
            ;;    "emacs" "-l" "~/.emacs.d/install.el" "-batch" "-install" pkg)
            ;;   (print (concat pkg " - success")))

            (while left-packages
              (setq packages
                    (cl-subseq left-packages
                               0
                               (min (length left-packages) length-of-args)))
              (print (format "len arg: %s, lef pkg :%s, pkg : %s" length-of-args left-packages packages))
              (setq left-packages (nthcdr length-of-args left-packages))
              (apply
               #'start-process
               "Install"
               output-buffer
               "emacs" "-l" "~/.emacs.d/install.el" "-batch" "-install"
               packages
               )

              ;; (start-process
              ;;  "Install"
              ;;  output-buffer
              ;;  "emacs" "-l" "~/.emacs.d/install.el" "-batch" "-install"
              ;;  packages)
              )

            (get-buffer-process output-buffer))))
    (while (process-live-p proc)
      ;; (message "wait...")
      (with-current-buffer output-buffer
        (message (buffer-substring 1 (point-max))))
      (sleep-for 1)))
  (message "Init done.")
  )


(add-to-list 'command-switch-alist '("-install" . install-function))
(add-to-list 'command-switch-alist '("-init" . init-function))
