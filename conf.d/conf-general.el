;; General settings

(use-package company
    :ensure t
    :init
    (global-company-mode 1)
    (setq company-idle-delay 0.1)
    (setq company-minimum-prefix-length 2)
    (defun my-company-eshell-setup ()
      (require 'cl-lib)
      (make-local-variable 'company-backends)
      (let* ((to-remove '(company-capf company-dabbrev))
             (new-backends (cl-remove-if (lambda (x) (member x to-remove)) company-backends)))
        (setq company-backends new-backends)))
    (add-hook 'eshell-mode-hook 'my-company-eshell-setup)
    :config
    (add-to-list 'company-backends 'company-irony))

(use-package company-irony
    :ensure t
    :defer t)


(use-package irony
    :ensure t
    :defer t
    :init
    (add-hook 'c++-mode-hook 'irony-mode)
    (add-hook 'c-mode-hook 'irony-mode)
    (add-hook 'objc-mode-hook 'irony-mode)
    :config
    (defun my-irony-mode-hook ()
      (define-key irony-mode-map [remap completion-at-point]
        'irony-completion-at-point-async)
      (define-key irony-mode-map [remap complete-symbol]
        'irony-completion-at-point-async)
      (local-set-key (kbd "TAB") 'company-indent-or-complete-common))
    (add-hook 'irony-mode-hook 'my-irony-mode-hook)
    (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options))


(use-package jedi-core
    :ensure t
    :defer t)

(use-package company-jedi
    :ensure t
    :defer t)

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
    (setq helm-imenu-execute-action-at-once-if-one nil
          helm-split-window-default-side 'right)
    :config
    (helm-autoresize-mode 1))

(use-package helm-ag
    :ensure t
    :defer t
    :commands helm-do-ag
    :bind ("C-c j p" . helm-projectile-ag))

;; Projectile is only used for the directory not controlled by git.
(use-package helm-projectile
    :ensure t
    :defer t
    :bind (("C-c j o" . helm-projectile-find-file)
           ("C-c j r" . helm-projectile-switch-project)
           ("C-c j b" . helm-projectile-switch-to-buffer))
    )

(use-package projectile
    :ensure t
    :defer t
    :init
    (setq projectile-keymap-prefix (kbd "C-c j"))
    (setq projectile-switch-project-action 'projectile-dired)
    ;;(setq projectile-enable-caching t)
    :config
    (setq projectile-require-project-root nil)
    (defun my-projectile-add-project ()
      (interactive)
      (when (projectile-project-p)
        (projectile-add-known-project (projectile-project-root))
        (projectile-merge-known-projects)))
    )


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
    (setq ibuffer-expert t
          ibuffer-default-sorting-mode 'major-mode)
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
    :init
    (add-hook 'org-mode-hook
              (lambda ()
                (use-package ox-ioslide)
                (use-package ox-ioslide-helper)))
    :config
    (bind-keys :map org-mode-map
               ("C-c l" . org-store-link)
               ("C-c a" . org-agenda)
               ("C-c b" . org-iswitchb)
               ("C-c r" . org-remember))
    (setq org-log-done t))

(use-package ox-ioslide
    :ensure t
    :defer t)


(use-package dired
    :defer t
    :init
    (use-package sk-dired)
    (setq dired-listing-switches "-alh"))

(use-package neotree
    :ensure t
    :defer t
    :bind ("C-c n" . my-neotree-directory)
    :config
    (defun my-neotree-directory ()
      (interactive)
      (if (neo-global--window-exists-p)
          (neotree-hide)
          (neotree-dir (projectile-project-root)))))

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

(use-package aes
    :ensure t
    :defer t
    :commands aes-toggle-encryption
    :config
    (aes-enable-auto-decryption))

(use-package ido-vertical-mode
    :ensure t
    :init
    (ido-mode 1)
    (ido-vertical-mode 1)
    (setq ido-vertical-define-keys 'C-n-C-p-up-down-left-right)
    ;;(setq ido-vertical-define-keys 'C-n-and-C-p-only)
    )


(use-package sk-etc-utils
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

(use-package sk-bit-util
    :defer t
    :commands sk-bit-print)


(provide 'conf-general)
