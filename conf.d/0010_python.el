;; Python mode Setting

(add-hook 'python-mode-hook '(lambda () (define-key python-mode-map "\C-m" 'newline-and-indent)))

; jedi needs virtualenv installed.(pip install virtualenv)
(add-hook 'python-mode-hook 'jedi:setup)
