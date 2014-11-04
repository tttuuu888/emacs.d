;; Python mode Setting

; jedi needs virtualenv installed.(pip install virtualenv)
(add-hook 'python-mode-hook 'jedi:setup)
