;; SK Emacs Setting

(let ((file-name-handler-alist nil)
      (gc-cons-threshold most-positive-fixnum))

  (package-initialize)
  (setq package-archives
        '(("gnu" . "http://elpa.gnu.org/packages/")
          ("melpa" . "http://melpa.milkbox.net/packages/")))

  ;; use-package
  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))

  (add-to-list 'load-path "~/.emacs.d/conf.d/")
  (add-to-list 'load-path "~/.emacs.d/conf.d/sk-utils/")

  ;; User Info
  (let ((name (getenv "USER_FULL_NAME"))
        (mail (getenv "USER_MAIL_ADDRESS")))
    (if name (setq user-full-name name))
    (if mail (setq user-mail-address mail)))

  ;; custom file
  (setq custom-file "~/.emacs.d/custom.el")
  (load custom-file)

  (require 'use-package)
  (require 'conf-init))
