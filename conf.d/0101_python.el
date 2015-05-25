;; Python mode Setting

(require 'python-mode)

(setq jedi:complete-on-dot t)

(add-hook 'python-mode-hook 'jedi:setup)
(add-hook 'python-mode-hook '(lambda () (define-key python-mode-map "\C-m" 'newline-and-indent)))
