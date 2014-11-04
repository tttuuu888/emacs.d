;; Eassist Setting

(add-to-list 'load-path "~/.emacs.d/util")

(require 'eassist)
(defun my-c-mode-common-hook ()
  (define-key c-mode-base-map (kbd "M-o") 'eassist-switch-h-cpp)
  (define-key c-mode-base-map (kbd "M-m") 'eassist-list-methods))
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

(defun my-python-mode-hook ()
  (define-key python-mode-map (kbd "M-m") 'eassist-list-methods))
(add-hook 'python-mode-hook 'my-python-mode-hook)
(define-key lisp-mode-shared-map (kbd "M-m") 'eassist-list-methods)
