;; General settings

(use-package bind-key
    :ensure t
    :config
    (unbind-key "C-z")
    (bind-key "C-x C-r" 'recentf-open-files))

(use-package diminish
    :ensure t)

(use-package zenburn-theme
    :ensure t
    :init
    (eval-after-load "avy"
      '(progn
        (set-face-attribute 'avy-lead-face nil :background "chocolate")
        (set-face-attribute 'avy-lead-face-0 nil :background "DarkViolet")))
    :config
    (set-face-attribute 'region nil :background "chocolate")
    (set-face-attribute 'lazy-highlight nil :weight 'bold :background "DarkViolet")
    (set-face-attribute 'isearch nil :weight 'bold :background "chocolate"))

(use-package company
    :ensure t
    :diminish company-mode
    :init
    (global-company-mode 1)
    (setq company-idle-delay 0.1)
    (setq company-minimum-prefix-length 2)
    (defun my-company-eshell-setup ()
      (progn
        (make-local-variable 'company-minimum-prefix-length)
        (setq company-minimum-prefix-length 3)))
    (add-hook 'eshell-mode-hook 'my-company-eshell-setup)
    (add-hook 'shell-mode-hook 'my-company-eshell-setup)
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

(use-package flycheck
    :disabled t
    :ensure t
    :defer t
    :init
    (add-hook 'c++-mode-hook 'flycheck-mode)
    (add-hook 'c-mode-hook 'flycheck-mode))

(use-package flycheck-irony
    :disabled t
    :ensure t
    :defer t
    :commands flycheck-irony-setup
    :init
    (add-hook 'c++-mode-hook 'flycheck-irony-setup)
    (add-hook 'c-mode-hook 'flycheck-irony-setup)
    (add-hook 'objc-mode-hook 'flycheck-irony-setup))

(use-package jedi-core
    :ensure t
    :defer t)

(use-package company-jedi
    :ensure t
    :defer t
    :init
    (add-to-list 'company-backends 'company-jedi))

(use-package redo+
    :ensure t
    :init
    (bind-keys ("C-." . redo)))

(use-package helm-git-grep
    :ensure t
    :defer t
    :bind ("C-c p" . helm-git-grep-at-point) ;greP
    :config (helm-autoresize-mode 1))

(use-package helm-ls-git
    :ensure t
    :defer t
    :bind ("C-c o" . helm-ls-git-ls)          ;Open file
    :config (helm-autoresize-mode 1))

(use-package helm
    :ensure t
    :defer t
    :bind (("C-c y" . helm-show-kill-ring)
           ("C-c i" . helm-semantic-or-imenu)
           ("M-s o" . helm-occur)
           ("M-s r" . helm-resume))
    :init
    (add-hook 'eshell-mode-hook
              (lambda ()
                (bind-keys :map eshell-mode-map ("C-c C-l" . helm-eshell-history))))
    (setq helm-imenu-execute-action-at-once-if-one nil
          helm-split-window-default-side 'right)
    :config
    (helm-autoresize-mode 1))

(use-package helm-ag
    :ensure t
    :defer t)

(use-package helm-projectile
    :ensure t
    :defer t
    :bind (("C-c j p" . helm-projectile-ag)
           ("C-c j o" . helm-projectile-find-file)
           ("C-c j s" . helm-projectile-switch-project)
           ("C-c j b" . helm-projectile-switch-to-buffer)))

(use-package projectile
    :ensure t
    :defer t
    :commands projectile-project-root my-projectile-add-project
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
        (projectile-merge-known-projects))))


(use-package powerline
    :ensure t
    :init
    (use-package sk-powerline)
    :config
    (set-face-attribute 'powerline-active1 nil :inherit 'mode-line :background "grey22" :foreground "white"))

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
                (use-package ox-reveal)))
    :config
    (bind-keys :map org-mode-map
               ("C-c l" . org-store-link)
               ("C-c a" . org-agenda)
               ("C-c b" . org-iswitchb)
               ("C-c r" . org-remember)
               ("C-c u" . org-up-element))
    (setq org-log-done t))

(use-package ox-reveal
    :ensure t
    :defer t
    :config
    (setq org-reveal-root "http://cdn.jsdelivr.net/reveal.js/3.0.0/"
          org-reveal-title-slide-template "<h1>%t</h1><h4>%a</h4><h4>%e</h4><h4>%d</h4>"
          org-reveal-theme "sky"
          org-reveal-hlevel 2))


(use-package dired
    :defer t
    :init
    (use-package sk-dired)
    (setq dired-listing-switches "-alh"))

(use-package neotree
    :ensure t
    :defer t
    :commands my-neotree-directory
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

(use-package ido-vertical-mode
    :ensure t
    :init
    (ido-mode 1)
    (ido-vertical-mode 1)
    (setq ido-vertical-define-keys 'C-n-C-p-up-down-left-right))

(use-package smex
    :ensure t
    :defer t
    :bind (("M-x" . smex)
           ("M-X" . smex-major-mode-commands)))


(use-package sk-etc-utils
    :init
  (bind-keys
   ("<f5>" . (lambda nil (interactive) (jump-to-register ?5)
                     (message "Windows are Restored by F5")))
   ("<f6>" . (lambda nil (interactive) (jump-to-register ?6)
                     (message "Windows are Restored by F6")))
   ("<f7>" . (lambda nil (interactive) (jump-to-register ?7)
                     (message "Windows are Restored by F7")))
   ("<f8>" . (lambda nil (interactive) (jump-to-register ?8)
                     (message "Windows are Restored by F8")))
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
