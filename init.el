;; SK Emacs Setting -*- lexical-binding: t -*-

(let ((file-name-handler-alist nil)
      (gc-cons-threshold most-positive-fixnum)
      (sk-config-el  (expand-file-name "config.el"  user-emacs-directory))
      (sk-config-org (expand-file-name "config.org" user-emacs-directory)))

  (when (or (not (file-exists-p sk-config-el))
            (file-newer-than-file-p sk-config-org sk-config-el))
    (package-initialize)
    (require 'org)
    (org-babel-tangle-file sk-config-org))

  (require 'config sk-config-el))
