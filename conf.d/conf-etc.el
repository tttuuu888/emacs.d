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

(use-package helm-git-grep
    :ensure t
    :defer t
    :bind ("C-c p" . helm-git-grep-at-point) ;greP
    :config (helm-autoresize-mode 1))

(use-package helm-git-files
    :ensure t
    :defer t
    :bind ("C-c o" . helm-git-files)          ;Open file
    :config (helm-autoresize-mode 1))

(use-package helm
    :ensure t
    :defer t
    :bind (("C-c y" . helm-show-kill-ring)
           ("C-c i" . helm-semantic-or-imenu))

    :init
    (add-hook 'eshell-mode-hook (lambda ()
                                  (bind-keys :map eshell-mode-map ("C-c C-l" . helm-eshell-history))))
    :config
    (helm-autoresize-mode 1))

(use-package helm-ag
    :ensure t
    :defer t
    :commands helm-ag)

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
            (my-ibuffer-mode-hook))))

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

(use-package direx
    :ensure t
    :defer t
    :bind ("C-c C-j" . my-direx-directory)
    :init
    (setq
     direx:leaf-icon "  "
     direx:open-icon "▾ "
     direx:closed-icon "▸ "
     direx:ignored-files-regexp
     (concat "\\(?:" (regexp-opt completion-ignored-extensions) "\\|#\\)$"))

    :config
    (let ((map direx:direx-mode-map))
      (define-key map (kbd ".") 'direx:up-item)
      (define-key map (kbd "N") 'direx:next-sibling-item)
      (define-key map (kbd "P") 'direx:previous-sibling-item))
    (defun my-direx-directory ()
      (interactive)
      (let ((my-root-dir
             (sk-find-project-root (file-name-directory default-directory))))
        (direx:find-directory my-root-dir))))

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

(use-package sk-utils
    :init
  (bind-keys
   ("<f5>" . (lambda nil (interactive) (jump-to-register ?5) (message "Windows are Restored by F5")))
   ("<f6>" . (lambda nil (interactive) (jump-to-register ?6) (message "Windows are Restored by F6")))
   ("<f7>" . (lambda nil (interactive) (jump-to-register ?7) (message "Windows are Restored by F7")))
   ("<f8>" . (lambda nil (interactive) (jump-to-register ?8) (message "Windows are Restored by F8")))
   ("C-<f5>" . (lambda nil (interactive)
                                 (window-configuration-to-register ?5)
                                 (message "Windows configuration saved to F5")))
   ("C-<f6>" . (lambda nil (interactive)
                                 (window-configuration-to-register ?6)
                                 (message "Windows configuration saved to F6")))
   ("C-<f7>" . (lambda nil (interactive)
                                 (window-configuration-to-register ?7)
                                 (message "Windows configuration saved to F7")))
   ("C-<f8>" . (lambda nil (interactive)
                                 (window-configuration-to-register ?8)
                                 (message "Windows configuration saved to F8")))))


(provide 'conf-etc)
