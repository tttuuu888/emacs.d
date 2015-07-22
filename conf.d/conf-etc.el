;; Etectra settings

(use-package auto-complete
    :ensure t
    :init
    (require 'auto-complete-config)
    (global-auto-complete-mode 1)
    (ac-config-default))

(use-package redo+
    :ensure t
    :init
    (bind-keys ("C-." . redo)))


(use-package helm
    :ensure t
    :defer t
    :bind (("C-c y" . helm-show-kill-ring)
           ("C-c i" . helm-semantic-or-imenu)
           ("C-c o" . helm-git-files)          ;Open file
           ("C-c p" . helm-git-grep-at-point)) ;greP
    :init
    (add-hook 'eshell-mode-hook (lambda ()
                                  (bind-keys :map eshell-mode-map ("C-c C-l" . helm-eshell-history))))
    :config
    (helm-autoresize-mode 1))


;; Projectile is only used for the directory not controlled by git.
(use-package helm-projectile
    :ensure t
    :defer t
    :bind (("C-c h o" . helm-projectile-find-file)
           ("C-c h p" . helm-projectile-ag))
    :config
    (setq projectile-require-project-root nil))


(use-package powerline
    :ensure t
    :init
    (use-package sk-powerline))

(use-package ibuffer
    :ensure t
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


(use-package org
    :defer t
    :mode ("\\.org\\'" . org-mode)
    :config
    (bind-keys :map org-mode-map
               ("C-c l" . org-store-link)
               ("C-c a" . org-agenda)    
               ("C-c b" . org-iswitchb)  
               ("C-c r" . org-remember))
    (setq org-log-done t))

(use-package dired
    :defer t
    :config
    (use-package sk-dired))


(use-package magit
    :ensure t
    :defer t
    :init
    (global-set-key (kbd "<f12>") 'magit-status)
    (setq magit-last-seen-setup-instructions "1.4.0"))


(use-package avy
    :ensure t
    :defer t
    :bind ("C-c C-SPC" . avy-goto-subword-1))

(use-package expand-region
    :ensure t
    :defer t
    :bind ("C-=" . er/expand-region))

(use-package sk-util)


(provide 'conf-etc)
