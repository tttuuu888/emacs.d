;;; General settings

(use-package sk-utils
  :commands (insert-date
             insert-date-and-time
             nuke-all-buffers
             hide-ctrl-M
             izero-insert
             idef-insert
             buffer-save-or-load
             sk-create-ch-file
             sk-create-c-file
             sk-create-h-file
             sk-clang-complete-make
             sk-byte-recompile-conf-dir)
  :bind (("<f5>"       . sk-make)
         ("C-<f5>"     . sk-rebuild)
         ("M-S-<up>"   . move-line-up)
         ("M-S-<down>" . move-line-down)
         ("C-M-,"      . transpose-windows))
  :init
  (bind-keys ("M-p"    . (lambda () (interactive) (line-move -8)))
             ("M-n"    . (lambda () (interactive) (line-move  8)))
             ("<f7>"   . (lambda () (interactive) (buffer-save-or-load 7 t)))
             ("<f8>"   . (lambda () (interactive) (buffer-save-or-load 8 t)))
             ("C-<f7>" . (lambda () (interactive) (buffer-save-or-load 7)))
             ("C-<f8>" . (lambda () (interactive) (buffer-save-or-load 8)))))

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
             ("C-,"              . other-window)))

(use-package cua-base
  :bind (("<C-return>" . cua-set-rectangle-mark)
         ("C-c RET"    . cua-set-rectangle-mark))
  :init
  (setq cua-enable-cua-keys nil)
  (cua-mode t))

(use-package hl-line
  :init
  (global-hl-line-mode t))

(use-package paren
  :init
  (show-paren-mode t))

(use-package cc-cmds
  :bind (("C-<backspace>" . c-hungry-backspace)
         ("C-c <DEL>"     . c-hungry-backspace)))

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
      (setenv "TERM" "screen-256color")
      (setq-local company-minimum-prefix-length 3)
      (bind-key "C-c C-l" 'helm-eshell-history eshell-mode-map)))
  (add-hook 'eshell-mode-hook 'my-company-eshell-setup))

(use-package shell
  :defer t
  :config
  (bind-key "C-c C-l" 'helm-comint-input-ring shell-mode-map)
  (add-hook 'shell-mode-hook
            '(lambda () (setq-local company-minimum-prefix-length 3))))

(use-package company
  :ensure t
  :init
  (global-company-mode 1)
  (setq company-idle-delay 0.1
        company-minimum-prefix-length 2))

(use-package company-irony
  :ensure t
  :after irony
  :config
  (add-to-list 'company-backends 'company-irony))

(use-package company-irony-c-headers
  :ensure t
  :after irony
  :config
  (add-to-list 'company-backends 'company-irony-c-headers))

(use-package company-tern
  :ensure t
  :after tern
  :config
  (defun advice-company-tern (&rest args)
    (if (equal major-mode 'web-mode)
        (let ((web-mode-cur-language
               (web-mode-language-at-pos)))
          (if (or (string= web-mode-cur-language "javascript")
                  (string= web-mode-cur-language "jsx"))
              (unless tern-mode (tern-mode))
            (if tern-mode (tern-mode -1))))))
  (advice-add 'company-tern :before #'advice-company-tern)
  (add-to-list 'company-backends 'company-tern))

(use-package company-web
  :ensure t
  :defer t)

(use-package company-sql
  :init
  (add-many-hook '(sql-mode-hook sql-interactive-mode-hook)
                 'my-sql-mode-hook)
  :config
  (defun my-sql-mode-hook ()
    (add-to-list 'company-backends 'company-sql)
    (local-set-key (kbd "TAB") 'company-indent-or-complete-common)))

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

(use-package company-go
  :ensure t
  :after go-mode
  :config
  (add-to-list 'company-backends 'company-go))

(use-package redo+
  :bind (("C-." . redo+-redo)
         ("M-_" . redo+-redo)
         ("C-_" . redo+-undo)
         ("C-/" . redo+-undo)))

(use-package wgrep
  :ensure t
  :commands wgrep-change-to-wgrep-mode
  :config
  (bind-keys :map helm-git-grep-mode-map
             ("C-c C-e" . wgrep-change-to-wgrep-mode)
             ("C-c C-s" . wgrep-save-all-buffers)))

(use-package helm-git-grep
  :ensure t
  :bind ("C-c p" . helm-git-grep-at-point))

(use-package helm
  :ensure t
  :bind (("C-c i"   . helm-semantic-or-imenu)
         ("C-x C-r" . helm-recentf)
         ("C-c h y" . helm-show-kill-ring)
         ("C-c h o" . helm-occur)
         ("C-c h r" . helm-resume))
  :config
  (helm-autoresize-mode 1)
  (setq helm-imenu-execute-action-at-once-if-one nil
        helm-split-window-default-side 'right))

(use-package helm-ag
  :ensure t
  :defer t
  :config
  (setq helm-ag-insert-at-point 'symbol
        helm-ag-use-grep-ignore-list t))

(use-package helm-projectile
  :ensure t
  :bind (("C-c j p" . helm-projectile-ag)
         ("C-c j P" . helm-do-grep-ag)))

(use-package projectile
  :ensure t
  :commands (my-add-project my-remove-project projectile-project-root)
  :bind (("C-c j d" . projectile-find-dir)
         ("C-c j k" . projectile-kill-buffers)
         ("C-c j b" . projectile-switch-to-buffer)
         ("C-c j s" . projectile-switch-project)
         ("C-c j S" . projectile-save-project-buffers))
  :init
  (setq projectile-keymap-prefix (kbd "C-c j")
        projectile-switch-project-action 'projectile-dired
        projectile-require-project-root nil
        projectile-completion-system 'ivy)
  :config
  (defalias 'my-add-project 'projectile-add-known-project)
  (defalias 'my-remove-project 'projectile-remove-known-project))


(use-package ibuffer
  :ensure t
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
           ("Magit" (mode . magit-status-mode))
           ("Code" (or (mode . c-mode)
                       (mode . c++-mode)
                       (mode . makefile-gmake-mode)
                       (mode . asm-mode)
                       (mode . python-mode)
                       (mode . java-mode)
                       (mode . lisp-mode)
                       (mode . clojure-mode)
                       (mode . scheme-mode)
                       (mode . web-mode)
                       (mode . js2-mode)
                       (mode . go-mode)))
           ("Dired" (mode . dired-mode))
           ("Help" (or (name . "\*Help\*")
                       (name . "\*Apropos\*")
                       (name . "\*info\*"))))))
  (setq ibuffer-expert t
        ibuffer-sorting-mode 'alphabetic
        ibuffer-default-sorting-mode 'major-mode)
  (defun my-ibuffer-unmark-all ()
    "Unmark all immdiately"
    (interactive)
    (ibuffer-unmark-all ?\s))
  (define-key ibuffer-mode-map (kbd "* *") 'my-ibuffer-unmark-all)
  (define-ibuffer-column size
    (:name "Size" :inline t)
    (cond
     ((> (buffer-size) 1000000) (format "%7.1fM" (/ (buffer-size) 1000000.0)))
     ((> (buffer-size) 1000) (format "%7.1fk" (/ (buffer-size) 1000.0)))
     (t (format "%8d" (buffer-size)))))

  (add-hook 'ibuffer-mode-hook
            '(lambda ()
               (ibuffer-auto-mode 1)
               (ibuffer-switch-to-saved-filter-groups "home"))))

(use-package markdown-mode
  :ensure t
  :defer t)

(use-package markdown-toc
  :ensure t
  :defer t)

(use-package org
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
      (line-move -2)
      (org-edit-src-code)))
  (defun my-org-inline-css-hook (exporter)
    (when (eq exporter 'html)
      (setq-local org-html-head-include-default-style nil)
      (setq-local org-html-head (concat
                                 "<style type=\"text/css\">\n"
                                 "<!--/*--><![CDATA[/*><!--*/\n"
                                 (with-temp-buffer
                                   (insert-file-contents
                                    "~/.emacs.d/conf.d/sk-utils/org.css")
                                   (buffer-string))
                                 "/*]]>*/-->\n"
                                 "</style>\n")))
    (when (eq exporter 'reveal)
      (setq-local org-export-with-toc nil)))
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
  :after org
  :config
  (setq org-reveal-root "https://cdnjs.cloudflare.com/ajax/libs/reveal.js/3.5.0"
        org-reveal-title-slide "<h1>%t</h1><h4>%a&nbsp(%e)</h4>"
        org-reveal-plugins '(classList markdown highlight zoom notes)
        org-reveal-theme "moon"
        org-reveal-transition-speed "fast"
        org-reveal-transition "linear"
        org-reveal-center nil))


(use-package dired
  :defer t
  :init
  (add-to-list 'magic-mode-alist
               '((lambda () (< large-file-warning-threshold (buffer-size)))
                 . fundamental-mode))
  :config
  (require 'dired-x)

  ;; win32 hiding gid, uid in dired mode
  (when windowsp
    (setq ls-lisp-verbosity (delq 'uid ls-lisp-verbosity))
    (setq ls-lisp-verbosity (delq 'gid ls-lisp-verbosity)))

  (put 'dired-find-alternate-file 'disabled nil)

  "Sort dired listings with directories first."
  (advice-add 'dired-readin :after
            (lambda (&rest args)
              (save-excursion
                (let (buffer-read-only)
                  (forward-line 2) ;; beyond dir. header
                  (sort-regexp-fields t "^.*$" "[ ]*." (point) (point-max)))
                (set-buffer-modified-p nil))))

  (add-hook 'dired-mode-hook (lambda () (dired-omit-mode)))

  (bind-keys :map dired-mode-map
             ("M-o" . dired-omit-mode)
             ("^" . dired-up-and-close-dir)
             ("<DEL>" . dired-up-and-close-dir)
             ("<RET>" . (lambda ()
                          (interactive)
                          (if (file-directory-p (dired-get-filename nil t))
                              (dired-find-alternate-file)
                            (dired-find-file-other-window)))))

  (defun dired-up-and-close-dir (&optional other-window)
    (interactive "P")
    (let ((dir (buffer-name)))
      (dired-up-directory other-window)
      (kill-buffer dir)))

  (setq dired-listing-switches "-alh"
        dired-omit-extensions '("~")
        dired-omit-files "^\\.?#\\|^\\.$\\|^\\.\\.$\\|^\\..+$"))


(use-package neotree
  :ensure t
  :commands my-neotree-directory
  :bind ("C-c n" . my-neotree-directory)
  :config
  (bind-keys :map neotree-mode-map
             ("u" . neotree-select-up-node)
             ("y" . (lambda ()
                      "Copy the absolute path of the node at point."
                      (interactive)
                      (message "Copied path : %s"
                               (neotree-copy-filepath-to-yank-ring)))))
  (defun my-neotree-directory ()
    (interactive)
    (if (neo-global--window-exists-p)
        (neotree-hide)
      (neotree-dir (projectile-project-root)))))

(use-package magit
  :ensure t
  :bind ("<f12>" . magit-status)
  :config
  (setq magit-log-section-commit-count 5
        magit-completing-read-function #'ivy-completing-read))

(use-package avy
  :ensure t
  :bind ("C-c C-SPC" . avy-goto-subword-1))

(use-package expand-region
  :ensure t
  :bind (("C-=" . er/expand-region)
         ("C-c =" . er/expand-region)))

(use-package ido
  :bind (("C-x d"   . ido-dired)
         ("C-x C-f" . ido-find-file))
  :config
  (ido-mode 1)
  (ido-vertical-mode 1)
  (setq ido-case-fold 1))

(use-package ido-vertical-mode
  :ensure t
  :defer t
  :config
  (setq ido-vertical-define-keys 'C-n-C-p-up-down-left-right
        ido-auto-merge-work-directories-length -1))

(use-package smex
  :ensure t
  :bind (("M-x" . smex)
         ("M-X" . smex-major-mode-commands))
  :config
  (advice-add 'smex :around
              (lambda (func &rest args)
                (let ((ido-cannot-complete-command
                       `(lambda ()
                          (interactive)
                          (if (string= " " (this-command-keys))
                              (insert ?-)
                            (funcall ,ido-cannot-complete-command)))))
                  (apply func args)))))

(use-package anzu
  :ensure t
  :defer t
  :init
  (defun isearch-anzu-advice (&rest args)
    (global-anzu-mode t))
  (advice-add #'isearch-forward :before #'isearch-anzu-advice)
  (advice-add #'isearch-backward :before #'isearch-anzu-advice)
  :config
  (setq anzu-search-threshold 1000
        anzu-replace-threshold 1000)
  (advice-remove #'isearch-forward #'isearch-anzu-advice)
  (advice-remove #'isearch-backward #'isearch-anzu-advice))

(use-package recentf
  :after (:any ido helm)
  :config
  (recentf-mode t))

(use-package htmlize
  :ensure t
  :after org)

(use-package korean-holidays
  :ensure t
  :config
  (setq calendar-holidays korean-holidays))

(use-package visual-regexp
  :ensure t
  :bind (("C-c r" . vr/replace)
         ("C-c q" . vr/query-replace))
  :config
  (require 'visual-regexp-steroids))

(use-package visual-regexp-steroids
  :ensure t
  :defer t)

(use-package xref
  :commands xref-find-reference-here
  :config
  (defun my/do-then-quit (&rest args)
    (let ((win (selected-window)))
      (apply (car args) (cdr args))
      (quit-window nil win)))
  (advice-add #'xref-goto-xref :around #'my/do-then-quit)
  (defun xref-find-reference-here ()
    (interactive)
    (xref-find-references (thing-at-point 'symbol))))

(use-package fzf
  :ensure t
  :bind (("C-c o"   . fzf-git-files)
         ("C-c j o" . fzf)
         ("C-c j h" . fzf-here))
  :config
  (defun fzf-here ()
    (interactive)
    (fzf/start default-directory))
  (setq fzf/window-height 20))

(use-package yasnippet
  :ensure t
  :commands yas-minor-mode
  :config
  (yas-reload-all)
  (bind-keys :map yas-minor-mode-map
             ("C-c /" . yas-expand)))

(use-package plantuml-mode
  :ensure t
  :mode ("\\.puml\\'" . plantuml-mode)
  :config
  (setq plantuml-jar-path "/usr/share/plantuml/plantuml.jar")
  (defun plantuml-make-output ()
    (interactive)
    (set-process-sentinel
     (start-process "plantuml" nil "plantuml" (buffer-file-name))
     (lambda (&rest args) (message "PlantUML process is done"))))
  (bind-keys :map plantuml-mode-map
             ("TAB" . company-indent-or-complete-common)
             ("C-c C-e" . plantuml-make-output)))

(use-package ivy
  :ensure t
  :bind (("C-x b" . ivy-switch-buffer))
  :config
  (defun ivy-buffer-transformer-sk (str)
    (let* ((buf (get-buffer str))
           (mode (capitalize
                  (string-remove-suffix "-mode"
                                        (symbol-name (buffer-local-value
                                                      'major-mode buf)))))
           (max-path-len (max 0 (- (frame-width) 62)))
           (path-dir (abbreviate-file-name
                      (buffer-local-value 'default-directory buf)))
           (path-file (buffer-file-name buf))
           (path-choice (or (if path-file (abbreviate-file-name path-file))
                            (if (or (string-match-p "shell" str)
                                    (equal (buffer-local-value 'major-mode buf)
                                           'dired-mode))
                                path-dir)
                            nil))
           (path-suffix (if (equal (and path-choice
                                        (substring path-choice 0 1))
                                   "~")
                            "~/"
                          "/"))
           (path-len (length path-choice))
           (path-mod (if (<= path-len max-path-len)
                         nil
                       (string-remove-prefix
                        (substring path-choice 0 (- path-len max-path-len))
                        path-choice)))
           (path (if path-mod
                     (concat path-suffix
                             "…"
                             (replace-regexp-in-string "^[^~/]*" "" path-mod))
                   path-choice)))
      (format "%-35s %-20s %s" buf mode (or path ""))))
  (ivy-set-display-transformer 'ivy-switch-buffer
                               'ivy-buffer-transformer-sk)
  (setq ivy-height 15
        ivy-do-completion-in-region nil
        ivy-wrap t
        ivy-fixed-height-minibuffer t
        ;; Don't use ^ as initial input
        ivy-initial-inputs-alist nil
        ;; disable magic slash on non-match
        ivy-magic-slash-non-match-action nil))


(provide 'conf-general)
