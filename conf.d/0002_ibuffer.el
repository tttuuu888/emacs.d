;; Ibuffer Setting

(use-package ibuffer
    :defer t
    :bind ("C-x C-b" . ibuffer)

    :config
    (setq ibuffer-saved-filter-groups
          '(("home"
             ("Emacs-config" (or (filename . ".emacs")
                                 (filename . ".emacs.d")
                                 (filename . "emacs-config")))
             ("Org / MD" (or (mode . org-mode)
                             (mode . markdown-mode)
                             (filename . "OrgMode")))
             ("Code" (or (mode . c-mode)
                         (mode . c++-mode)
                         (mode . asm-mode)
                         (mode . python-mode)
                         (mode . java-mode)
                         (mode . lisp-mode)
                         (mode . clojure-mode)))
             ("Dired" (mode . dired-mode))
             ("Magit" (name . "\*magit"))
             ("Help" (or (name . "\*Help\*")
                         (name . "\*Apropos\*")
                         (name . "\*info\*"))))))
    (setq ibuffer-expert t)
    (defun my-ibuffer-unmark-all ()
      "Unmark all immdiately"
      (interactive)
      (ibuffer-unmark-all ?\s))

    (defun my-ibuffer-mode-hook ()
      (define-key ibuffer-mode-map (kbd "* *") 'my-ibuffer-unmark-all))

    (add-hook 'ibuffer-mode-hook
          '(lambda ()
            (ibuffer-auto-mode 1)
            (ibuffer-switch-to-saved-filter-groups "home")
            (my-ibuffer-mode-hook)))
    )

