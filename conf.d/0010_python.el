;; Python mode Setting

; jedi needs virtualenv installed.(pip install virtualenv)
(add-hook 'python-mode-hook 'jedi:setup)

(setq jedi:complete-on-dot t)
(setq jedi:get-in-function-call-delay 100)
