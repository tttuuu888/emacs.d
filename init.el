;; SK Emacs Setting -*- lexical-binding: t -*-

(let ((file-name-handler-alist nil)
      (gc-cons-threshold most-positive-fixnum))

  (package-initialize)
  (setq package-archives
        '(("gnu"   . "http://elpa.gnu.org/packages/")
          ;; ("org" . "https://orgmode.org/elpa/")
          ("melpa" . "http://melpa.org/packages/")))

  (add-to-list 'load-path "~/.emacs.d/conf.d/")
  (add-to-list 'load-path "~/.emacs.d/conf.d/sk-utils/")

  ;; custom file
  (setq custom-file "~/.emacs.d/custom.el")
  (load custom-file)

  (require 'conf-init))
