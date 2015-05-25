;; Python mode Setting

(require 'python-mode)

(setq jedi:complete-on-dot t)
(setq py-install-directory (concat "~/.emacs.d/elpa/" (car (directory-files "~/.emacs.d/elpa/" nil "python-mode*"))))

(add-hook 'python-mode-hook 'jedi:setup)
(add-hook 'python-mode-hook '(lambda () (define-key python-mode-map "\C-m" 'newline-and-indent)))
