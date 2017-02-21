;; General settings

(use-package bind-key
    :ensure t
    :init
    (global-unset-key (kbd "C-z"))
    (global-unset-key (kbd "<mouse-1>"))
    (global-unset-key (kbd "<mouse-3>"))
    (global-unset-key (kbd "<down-mouse-1>"))
    (global-unset-key (kbd "<down-mouse-3>"))
    (global-unset-key (kbd "<drag-mouse-1>"))
    (global-unset-key (kbd "<drag-mouse-3>"))
    (global-unset-key (kbd "<C-down-mouse-1>"))
    (global-unset-key (kbd "<M-down-mouse-1>"))
    :config
    (defun jump-10-line-down ()
      (interactive)
      (dotimes (i 10) (next-line)))
    (defun jump-10-line-up ()
      (interactive)
      (dotimes (i 10) (previous-line)))
    (bind-keys ("C-x C-r" . recentf-open-files)
               ("<f7>" . (lambda nil (interactive) (jump-to-register ?7)
                                 (message "Windows are Restored by F7")))
               ("<f8>" . (lambda nil (interactive) (jump-to-register ?8)
                                 (message "Windows are Restored by F8")))
               ("C-<f7>" . (lambda nil (interactive)
                                   (window-configuration-to-register ?7)
                                   (message "Windows are saved to F7")))
               ("C-<f8>" . (lambda nil (interactive)
                                   (window-configuration-to-register ?8)
                                   (message "Windows are saved to F8")))
               ("M-p" . jump-10-line-up)
               ("M-n" . jump-10-line-down)))

(use-package diminish
    :ensure t)

(use-package sk-etc-utils
    :commands (insert-date
               insert-date-and-time
               nuke-all-buffers
               hide-ctrl-M
               eshell/clear))

(use-package eshell
    :defer t
    :config
    (defun my-company-eshell-setup ()
      (progn
        (make-local-variable 'company-minimum-prefix-length)
        (setq company-minimum-prefix-length 3)
        (bind-keys :map eshell-mode-map
                   ("C-c C-l" . helm-eshell-history))))
    (add-hook 'eshell-mode-hook 'my-company-eshell-setup))

(use-package shell
    :defer t
    :config
    (bind-keys :map shell-mode-map
               ("C-c C-l" . helm-comint-input-ring))
    (defun my-company-shell-setup ()
      (progn
        (make-local-variable 'company-minimum-prefix-length)
        (setq company-minimum-prefix-length 3)))
    (add-hook 'shell-mode-hook 'my-company-shell-setup))

(use-package company
    :ensure t
    :diminish company-mode
    :init
    (global-company-mode 1)
    (setq company-idle-delay 0.1
          company-minimum-prefix-length 2))

(use-package company-irony
    :ensure t
    :defer t
    :after irony
    :config
    (add-to-list 'company-backends 'company-irony))

(use-package company-tern
    :ensure t
    :defer t
    :after web-mode
    :config
    (add-to-list 'company-backends 'company-tern))

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
    (add-hook 'objc-mode-hook 'flycheck-irony-setup)
    :config
    (setq flycheck-checker 'irony))

(use-package jedi-core
    :ensure t
    :defer t)

(use-package company-jedi
    :ensure t
    :defer t
    :after python
    :config
    (add-to-list 'company-backends 'company-jedi))

(use-package company-go
    :ensure t
    :defer t
    :after go-mode
    :config
    (add-to-list 'company-backends 'company-go))

(use-package redo+
    :ensure t
    :init
    (bind-keys ("C-." . redo)))

(use-package wgrep
    :ensure t
    :defer t
    :commands wgrep-change-to-wgrep-mode
    :config
    (bind-keys :map helm-git-grep-mode-map
               ("C-c C-e" . wgrep-change-to-wgrep-mode)
               ("C-c C-s" . wgrep-save-all-buffers)))

(use-package helm-git-grep
    :ensure t
    :defer t
    :bind ("C-c p" . helm-git-grep-at-point))

(use-package helm-ls-git
    :ensure t
    :defer t
    :bind ("C-c o" . helm-ls-git-ls))

(use-package helm
    :ensure t
    :defer t
    :bind (("C-c y" . helm-show-kill-ring)
           ("C-c i" . helm-semantic-or-imenu)
           ("M-s o" . helm-occur)
           ("M-s r" . helm-resume))
    :config
    (helm-autoresize-mode 1)
    (setq helm-imenu-execute-action-at-once-if-one nil
          helm-split-window-default-side 'right))

(use-package helm-ag
    :ensure t
    :defer t)

(use-package helm-projectile
    :ensure t
    :defer t
    :bind (("C-c j p" . helm-projectile-ag)
           ("C-c j o" . helm-projectile-find-file)
           ("C-c j d" . helm-projectile-find-dir)
           ("C-c j s" . helm-projectile-switch-project)
           ("C-c j b" . helm-projectile-switch-to-buffer)))

(use-package projectile
    :ensure t
    :defer t
    :commands (my-projectile-add-project projectile-project-root)
    :bind (("C-c j k" . projectile-kill-buffers)
           ("C-c j S" . projectile-save-project-buffers))
    :init
    (setq projectile-keymap-prefix (kbd "C-c j")
          projectile-switch-project-action 'projectile-dired
          projectile-require-project-root nil)
    :config
    (defun my-projectile-add-project ()
      (interactive)
      (when (projectile-project-p)
        (projectile-add-known-project (projectile-project-root))
        (projectile-merge-known-projects))))


(use-package powerline
    :ensure t
    :init
    (require 'sk-powerline)
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
                         (mode . clojure-mode)
                         (mode . web-mode)
                         (mode . js-mode)))
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

(use-package markdown-mode
    :ensure t
    :defer t)

(use-package markdown-toc
    :ensure t
    :defer t)

(use-package org
    :defer t
    :mode ("\\.org\\'" . org-mode)
    :config
    (defun org-insert-src-block (src-code-type)
      "Insert a `SRC-CODE-TYPE' type source code block in org-mode."
      (interactive
       (let ((src-code-types
              '("emacs-lisp" "python" "c" "sh" "java" "js" "clojure" "c++"
                "css" "html" "calc" "asymptote" "dot" "gnuplot"
                "octave" "R" "sass" "sql" "awk" "ditaa"
                "haskell" "latex" "lisp" "matlab" "org" "perl" "ruby"
                "scheme" "sqlite" )))
         (list (ido-completing-read "Source code type: " src-code-types))))
      (progn
        (insert (format "#+BEGIN_SRC %s\n" src-code-type))
        (newline-and-indent)
        (insert "#+END_SRC\n")
        (previous-line 2)
        (org-edit-src-code)))
    (bind-keys :map org-mode-map
               ("C-c a" . org-agenda)
               ("C-c b" . org-iswitchb)
               ("C-c l" . org-store-link)
               ("C-c r" . org-remember)
               ("C-c t" . org-table-create)
               ("C-c u" . org-up-element)
               ("C-c s e" . org-edit-src-code)
               ("C-c s i" . org-insert-src-block))
    (setq org-footnote-definition-re "^\\[fn:[-_[:word:]]+\\]"
          org-footnote-re (concat "\\[\\(?:fn:\\([-_[:word:]]+\\)?:"
                                  "\\|"
                                  "\\(fn:[-_[:word:]]+\\)\\)")))

(use-package ox-reveal
    :ensure t
    :defer t
    :after org
    :config
    (setq org-reveal-root "http://cdn.jsdelivr.net/reveal.js/3.0.0/"
          org-reveal-title-slide-template "<h1>%t</h1><h4>%a</h4><h4>%e</h4><h4>%d</h4>"
          org-reveal-plugins '(classList markdown highlight zoom notes)
          org-reveal-theme "sky"
          org-reveal-hlevel 2
          org-reveal-center nil))


(use-package dired
    :defer t
    :config
    (require 'sk-dired)
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
    :bind ("<f12>" . magit-status))

(use-package avy
    :ensure t
    :defer t
    :bind ("C-c C-SPC" . avy-goto-subword-1))

(use-package expand-region
    :ensure t
    :defer t
    :bind ("C-=" . er/expand-region))

(use-package ido
    :defer t
    :bind (("C-x d" . ido-dired)
           ("C-x C-f" . ido-find-file)
           ("C-x b" . ido-switch-buffer))
    :config
    (ido-mode 1)
    (ido-vertical-mode 1))

(use-package ido-vertical-mode
    :ensure t
    :defer t
    :config
    (setq ido-vertical-define-keys 'C-n-C-p-up-down-left-right
          ido-auto-merge-work-directories-length -1))

(use-package smex
    :ensure t
    :defer t
    :bind (("M-x" . smex)
           ("M-X" . smex-major-mode-commands)))

(use-package anzu
    :ensure t
    :diminish anzu-mode
    :init (global-anzu-mode t)
    :config
    (setq anzu-search-threshold 1000
          anzu-replace-threshold 1000))

(use-package tramp
    :defer t
    :init
    ;; For speeding up SSH session creation
    (setq tramp-ssh-controlmaster-options
          "-o ControlMaster=auto -o ControlPath='tramp.%%C' -o ControlPersist=no"))

(use-package multiple-cursors
    :ensure t
    :defer t
    :bind (("C->" . mc/mark-next-like-this)
           ("C-<" . mc/mark-previous-like-this)
           ("C-c C->" . mc/mark-all-like-this)
           ("C-S-<mouse-1>" . mc/add-cursor-on-click)))

(use-package recentf
    :defer t
    :bind ("C-x C-r" . recentf-open-files)
    :config
    (recentf-mode t))

(use-package htmlize
    :ensure t
    :defer t
    :after org)


(provide 'conf-general)
