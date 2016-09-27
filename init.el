;; SK Emacs Setting

(let ((file-name-handler-alist nil)
      (gc-cons-threshold most-positive-fixnum))

  (package-initialize)
  (setq package-archives
        '(("gnu" . "http://elpa.gnu.org/packages/")
          ("melpa" . "http://melpa.milkbox.net/packages/")))

  ;; use-package
  (when (not (package-installed-p 'use-package))
    (package-refresh-contents)
    (package-install 'use-package))

  (add-to-list 'load-path "~/.emacs.d/conf.d/")
  (add-to-list 'load-path "~/.emacs.d/conf.d/sk-utils/")

  ;; custom file
  (setq custom-file "~/.emacs.d/custom.el")
  (load custom-file)

  (require 'use-package)
  (require 'conf-init)

  ;; To be removed after emacs updated.
  (setq package--initialized nil)

  (recentf-open-files))
