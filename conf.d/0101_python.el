;; Python mode Setting

(use-package python
    :commands jedi:setup
    :init
    (add-hook 'python-mode-hook 'jedi:setup)
    :mode ("\\.py\\'" . python-mode)
    :interpreter ("python" . python-mode)
    :config
    (setq py-shell-name "python")
    (setq py-split-windows-on-execute-function (quote split-window-horizontally))
    (setq py-install-directory
          (concat "~/.emacs.d/elpa/" (car (directory-files "~/.emacs.d/elpa/" nil "python-mode*"))))
    (setq jedi:complete-on-dot t)
    (use-package python-mode))
