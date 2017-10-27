;;; General settings

(use-package sk-utils
  :defer t
  :commands (insert-date
             insert-date-and-time
             nuke-all-buffers
             hide-ctrl-M
             izero-insert
             idef-insert
             buffer-save-or-restore
             my-prog-nuke-trailing-whitespace
             sk-create-ch-file
             sk-create-c-file
             sk-create-h-file
             sk-clang-complete-make)
  :bind (("<f5>"       . sk-make)
         ("C-<f5>"     . sk-rebuild)
         ("M-p"        . jump-8-line-up)
         ("M-n"        . jump-8-line-down)
         ("M-S-<up>"   . move-line-up)
         ("M-S-<down>" . move-line-down)
         ("C-M-,"      . transpose-windows))
  :init
  (add-to-list 'auto-mode-alist '("Makefile\\..*" . makefile-gmake-mode))
  (add-hook 'before-save-hook 'my-prog-nuke-trailing-whitespace)
  (defmacro add-many-hook (hooks function)
    `(dolist (hook ,hooks)
       (add-hook hook ,function)))
  (bind-keys ("<f7>"   . (lambda () (interactive) (buffer-save-or-restore 7 t)))
             ("<f8>"   . (lambda () (interactive) (buffer-save-or-restore 8 t)))
             ("C-<f7>" . (lambda () (interactive) (buffer-save-or-restore 7)))
             ("C-<f8>" . (lambda () (interactive) (buffer-save-or-restore 8))))
  :config
  (require 'cc-cmds))

(use-package bind-key
  :ensure t
  :init
  (bind-keys ("C-z"              . nil)
             ("<mouse-1>"        . nil)
             ("<mouse-3>"        . nil)
             ("<down-mouse-1>"   . nil)
             ("<down-mouse-3>"   . nil)
             ("<drag-mouse-1>"   . nil)
             ("<drag-mouse-3>"   . nil)
             ("<C-down-mouse-1>" . nil)
             ("<M-down-mouse-1>" . nil)
             ("<S-down-mouse-1>" . nil)
             ("C-<backspace>"    . c-hungry-backspace)
             ("C-C <RET>"        . cua-set-rectangle-mark)
             ("C-,"              . other-window)))


(use-package diminish
  :ensure t)

(use-package eshell
  :defer t
  :config
  ;; Clear Eshell buffer
  (defun eshell/clear ()
    (interactive)
    (let ((inhibit-read-only t))
      (erase-buffer)
      (execute-kbd-macro (kbd "<RET>"))))

  (defun my-company-eshell-setup ()
    (progn
      (make-local-variable 'company-minimum-prefix-length)
      (setenv "TERM" "screen-256color")
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

(use-package company-irony-c-headers
  :ensure t
  :defer t
  :after irony
  :config
  (add-to-list 'company-backends 'company-irony-c-headers))

(use-package company-tern
  :ensure t
  :defer t
  :after tern
  :config
  (add-to-list 'company-backends 'company-tern)
  ;; Enable JavaScript completion between <script>...</script> etc.
  (defadvice company-tern (before web-mode-set-up-ac-sources activate)
    "Set `tern-mode' based on current language before running company-tern."
    (message "advice")
    (if (equal major-mode 'web-mode)
        (let ((web-mode-cur-language
               (web-mode-language-at-pos)))
          (if (or (string= web-mode-cur-language "javascript")
                  (string= web-mode-cur-language "jsx")
                  )
              (unless tern-mode (tern-mode))
            (if tern-mode (tern-mode -1)))))))

(use-package company-web
  :ensure t
  :defer t)

(use-package irony
  :ensure t
  :defer t
  :init
  (add-many-hook '(c++-mode-hook c-mode-hook objc-mode-hook)
                 'irony-mode)
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
  (add-many-hook '(c-mode-hook c++-mode-hook) 'flycheck-mode))

(use-package flycheck-irony
  :disabled t
  :ensure t
  :defer t
  :commands flycheck-irony-setup
  :init
  (add-many-hook '(c++-mode-hook c-mode-hook objc-mode-hook)
                 'flycheck-irony-setup)
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
  (bind-keys ("C-." . redo)
             ("C-c ." . redo)))

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
        helm-split-window-default-side 'right)

  (defvar my-helm-follow-sources ()
    "List of sources for which helm-follow-mode should be enabled")

  ;; Use helm-follow-mode for the following sources:
  (add-to-list 'my-helm-follow-sources 'helm-source-occur)

  (defun my-helm-set-follow ()
    "Enable helm-follow-mode for the sources specified in the list"
    (mapc (lambda (source)
            (when (memq source my-helm-follow-sources)
              (helm-attrset 'follow 1 (symbol-value source))))
          helm-sources))

  ;; Add hook to enable helm-follow mode for specified helm
  (add-hook 'helm-before-initialize-hook 'my-helm-set-follow))

(use-package helm-ag
  :ensure t
  :defer t
  :config
  (setq helm-ag-insert-at-point 'symbol
        helm-ag-use-grep-ignore-list t))

(use-package helm-projectile
  :ensure t
  :defer t
  :bind (("C-c j p" . helm-projectile-ag)
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
      (projectile-merge-known-projects)
      (message (concat
                (projectile-project-root)
                " has added into projectile projects.")))))


(use-package powerline
  :ensure t
  :init
  (require 'sk-powerline)
  :config
  (set-face-attribute 'powerline-active1 nil
                      :inherit 'mode-line
                      :background "grey22"
                      :foreground "white"))

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
                       (mode . makefile-gmake-mode)
                       (mode . asm-mode)
                       (mode . python-mode)
                       (mode . java-mode)
                       (mode . lisp-mode)
                       (mode . clojure-mode)
                       (mode . web-mode)
                       (mode . js2-mode)))
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
  (defun my-org-inline-css-hook (exporter)
    (when (eq exporter 'html)
      (make-local-variable 'org-html-head-include-default-style)
      (make-local-variable 'org-html-head)
      (setq org-html-head-include-default-style nil
            org-html-head (concat
                           "<style type=\"text/css\">\n"
                           "<!--/*--><![CDATA[/*><!--*/\n"
                           (with-temp-buffer
                             (insert-file-contents "~/.emacs.d/conf.d/sk-utils/org.css")
                             (buffer-string))
                           "/*]]>*/-->\n"
                           "</style>\n")))
    (when (eq exporter 'reveal)
      (make-local-variable 'org-export-with-toc)
      (setq org-export-with-toc nil)))
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
                                "\\(fn:[-_[:word:]]+\\)\\)"))
  (add-hook 'org-export-before-processing-hook 'my-org-inline-css-hook))

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
  :init
  (add-to-list 'magic-mode-alist
               '((lambda () (< large-file-warning-threshold (buffer-size)))
                 . fundamental-mode))
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
  :bind (("C-=" . er/expand-region)
         ("C-c =" . er/expand-region)))

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
         ("M-X" . smex-major-mode-commands))
  :config
  (defadvice smex (around space-inserts-hyphen activate compile)
    (let ((ido-cannot-complete-command
           `(lambda ()
              (interactive)
              (if (string= " " (this-command-keys))
                  (insert ?-)
                (funcall ,ido-cannot-complete-command)))))
      ad-do-it)))

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
  :after (:any ido helm)
  :config
  (recentf-mode t))

(use-package htmlize
  :ensure t
  :defer t
  :after org)

(use-package korean-holidays
  :ensure t
  :config
  (setq calendar-holidays korean-holidays))

(use-package visual-regexp
  :ensure t
  :defer t
  :bind (("C-c r" . vr/replace)
         ("C-c q" . vr/query-replace))
  :config
  (require 'visual-regexp-steroids))

(use-package visual-regexp-steroids
  :ensure t
  :defer t)

(use-package xref
  :defer t
  :config
  (defun my/do-then-quit (&rest args)
    (let ((win (selected-window)))
      (apply (car args) (rest args))
      (quit-window nil win)))
  (advice-add #'xref-goto-xref :around #'my/do-then-quit))

(use-package fzf
  :ensure t
  :defer t
  :bind (("C-c j o" . fzf)
         ("C-c j O" . fzf-here))
  :config
  (defun fzf-here ()
    (interactive)
    (fzf/start default-directory))
  (setq fzf/window-height 20))

(provide 'conf-general)
