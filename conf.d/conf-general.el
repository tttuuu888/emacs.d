;;; General settings

(use-package sk-mode-line
  :config
  (sk-mode-line))

(use-package sk-utils
  :commands (insert-date
             insert-date-and-time
             nuke-all-buffers
             hide-ctrl-M
             izero-insert
             idef-insert
             move-line
             buffer-save-or-load
             sk-clang-complete-make
             sk-byte-recompile-conf-dir
             tmux-new-pane-here)
  :bind (("<f5>"       . sk-make)
         ("C-<f5>"     . sk-rebuild)
         ("C-M-,"      . transpose-windows)
         ("M-p"        . (lambda () (interactive) (line-move -8)))
         ("M-n"        . (lambda () (interactive) (line-move  8)))
         ("M-S-<up>"   . (lambda () (interactive) (move-line -1)))
         ("M-S-<down>" . (lambda () (interactive) (move-line  1)))
         ("<f7>"       . (lambda () (interactive) (buffer-save-or-load 7 t)))
         ("<f8>"       . (lambda () (interactive) (buffer-save-or-load 8 t)))
         ("C-<f7>"     . (lambda () (interactive) (buffer-save-or-load 7)))
         ("C-<f8>"     . (lambda () (interactive) (buffer-save-or-load 8)))))

(use-package evil-leader
  :ensure t
  :init
  (global-evil-leader-mode)
  (evil-leader/set-leader "<SPC>")
  (evil-leader/set-key
    "0"  'delete-window
    "1"  'delete-other-windows
    "2"  'split-window-below
    "3"  'split-window-right
    ","  'other-window
    "q"  'kill-buffer
    "Q"  'kill-emacs
    "u"  'pop-to-mark-command
    "w"  'save-buffer
    "hb" 'describe-bindings
    "hk" 'describe-key
    "xr" 'read-only-mode
    "xv" 'evil-reload-file)
  (setq evil-leader/no-prefix-mode-rx
        '("magit-.*-mode" "gnus-.*-mode" "package-.*-mode" "dired-mode")))

(use-package evil
  :ensure t
  :bind (:map evil-insert-state-map
         ("C-a" . move-beginning-of-line)
         ("C-e" . move-end-of-line)
         :map evil-ex-completion-map
         ("C-a" . move-beginning-of-line)
         ("C-b" . backward-char)
         ("C-d" . delete-char))
  :init
  (evil-mode)
  (add-hook 'evil-insert-state-entry-hook
            (lambda () (when buffer-read-only (read-only-mode -1))))
  (defun evil-reload-file ()
    (interactive)
    (find-alternate-file (buffer-file-name)))
  ;; mouse disabled in evil
  (defun evil-mouse-drag-track (start &optional opt) nil)
  :config
  (evil-set-initial-state 'term-mode   'emacs)
  (evil-set-initial-state 'dired-mode  'emacs)
  (evil-set-initial-state 'shell-mode  'emacs)
  (evil-set-initial-state 'eshell-mode 'emacs))

(use-package evil-visualstar
  :ensure t
  :bind (:map evil-visual-state-map
         ("/" . evil-visualstar/begin-search-forward)
         ("?" . evil-visualstar/begin-search-backward)
         ("n" . evil-visualstar/begin-search-forward)
         ("N" . evil-visualstar/begin-search-backward))
  :config
  (global-evil-visualstar-mode))

(use-package display-line-numbers
  :hook ((find-file prog-mode) . display-line-numbers-mode)
  :config
  (setq-default display-line-numbers-width 3
                display-line-numbers-type 'visual
                display-line-numbers-current-absolute nil))

(use-package bind-key
  :ensure t
  :init
  (bind-keys ("<mouse-1>"        . nil)
             ("<mouse-3>"        . nil)
             ("<down-mouse-1>"   . nil)
             ("<down-mouse-3>"   . nil)
             ("<drag-mouse-1>"   . nil)
             ("<drag-mouse-3>"   . nil)
             ("<C-down-mouse-1>" . nil)
             ("<M-down-mouse-1>" . nil)
             ("<S-down-mouse-1>" . nil)
             ("M-,"              . other-window)))

(use-package hl-line
  :init
  (global-hl-line-mode t))

(use-package paren
  :init
  (show-paren-mode t))

(use-package cc-cmds
  :bind (("C-<backspace>" . c-hungry-backspace)
         ("C-c <DEL>"     . c-hungry-backspace)
         :map evil-normal-state-map
         ("<SPC> <DEL>"   . c-hungry-backspace)))

(use-package eshell
  :defer t
  :config
  ;; Clear Eshell buffer
  (defun eshell/clear ()
    (interactive)
    (let ((inhibit-read-only t))
      (erase-buffer)
      (execute-kbd-macro (kbd "<RET>"))))
  (defun my-eshell-setup ()
    (progn
      (setenv "TERM" "screen-256color")
      (setq-local company-minimum-prefix-length 3)
      (bind-key "C-c C-l" 'helm-eshell-history eshell-mode-map)))
  (add-hook 'eshell-mode-hook 'my-eshell-setup))

(use-package shell
  :defer t
  :config
  (bind-key "C-c C-l" 'helm-comint-input-ring shell-mode-map)
  (defun my-shell-setup ()
    (setq-local company-minimum-prefix-length 3))
  (add-hook 'shell-mode-hook 'my-shell-setup))

(use-package company
  :ensure t
  :init
  (global-company-mode 1)
  (setq company-idle-delay 0.1
        company-minimum-prefix-length 2)
  :config
  (evil-define-key 'insert company-mode-map
    (kbd "TAB") 'company-indent-or-complete-common))

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
  :after web-mode)

(use-package company-sql
  :init
  :hook ((sql-mode sql-interactive) . my-sql-mode-hook)
  :config
  (defun my-sql-mode-hook ()
    (add-to-list 'company-backends 'company-sql)
    (local-set-key (kbd "TAB") 'company-indent-or-complete-common)))

(use-package irony
  :ensure t
  :hook ((c++-mode c-mode objc-mode) . irony-mode)
  :config
  (defun my-irony-mode-hook ()
    (define-key irony-mode-map [remap completion-at-point]
      'irony-completion-at-point-async)
    (define-key irony-mode-map [remap complete-symbol]
      'irony-completion-at-point-async)
    (local-set-key (kbd "TAB") 'company-indent-or-complete-common)
    (irony-cdb-autosetup-compile-options))
  (add-hook 'irony-mode-hook 'my-irony-mode-hook))

(use-package flycheck
  :disabled t
  :ensure t
  :hook ((c-mode c++-mode) . flycheck-mode))

(use-package company-go
  :ensure t
  :after go-mode
  :config
  (add-to-list 'company-backends 'company-go))

(use-package undo-tree
  :config
  (require 'redo+))

(use-package redo+
  :bind (("C-." . redo+-redo)
         ("M-_" . redo+-redo)
         ("C-_" . redo+-undo)
         ("C-/" . redo+-undo)
         :map evil-normal-state-map
         ("u"   . redo+-undo)
         ("C-r" . redo+-redo))
  :config
  (global-undo-tree-mode -1)
  (defun global-undo-tree-mode (&optional ARG) t)
  (defalias 'undo-tree-undo 'redo+-undo)
  (defalias 'undo-tree-redo 'redo+-redo))

(use-package wgrep
  :ensure t
  :commands wgrep-change-to-wgrep-mode
  :bind (:map helm-git-grep-mode-map
              ("C-c C-e" . wgrep-change-to-wgrep-mode)
              ("C-c C-s" . wgrep-save-all-buffers)))

(use-package helm-git-grep
  :ensure t
  :bind (("C-c p" . helm-git-grep-at-point))
  :init
  (evil-leader/set-key
    "p" 'helm-git-grep-at-point))

(use-package helm
  :ensure t
  :bind (("C-c i"   . helm-semantic-or-imenu)
         ("C-c y"   . helm-show-kill-ring)
         ("C-x C-r" . helm-recentf)
         ("C-c h o" . helm-occur)
         ("C-c h r" . helm-resume))
  :init
  (evil-leader/set-key
    "i"  'helm-semantic-or-imenu
    "y"  'helm-show-kill-ring
    "r"  'helm-recentf
    "ho" 'helm-occur
    "hr" 'helm-resume)
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
  :commands (helm-projectile-ag helm-do-grep-ag)
  :bind (("C-c j p" . helm-projectile-ag)
         ("C-c j P" . helm-do-grep-ag))
  :init
  (evil-leader/set-key
    "jp" 'helm-projectile-ag
    "jP" 'helm-do-grep-ag))

(use-package projectile
  :ensure t
  :commands (my-add-project my-remove-project projectile-project-root)
  :bind (("C-c j d" . projectile-find-dir)
         ("C-c j k" . projectile-kill-buffers)
         ("C-c j b" . projectile-switch-to-buffer)
         ("C-c j s" . projectile-switch-project)
         ("C-c j S" . projectile-save-project-buffers))
  :init
  (evil-leader/set-key
    "jd" 'projectile-find-dir
    "jk" 'projectile-kill-buffers
    "jb" 'projectile-switch-to-buffer
    "js" 'projectile-switch-project
    "jS" 'projectile-save-project-buffers)
  (setq projectile-switch-project-action 'projectile-dired
        projectile-require-project-root nil
        projectile-completion-system 'ivy)
  :config
  (defalias 'my-remove-project 'projectile-remove-known-project)
  (defun my-add-project ()
    (interactive)
    (call-interactively 'projectile-add-known-project)
    (projectile-merge-known-projects)))


(use-package ibuffer
  :ensure t
  :bind ("C-x C-b" . ibuffer)
  :init
  (evil-leader/set-key
    "xb" 'ibuffer)
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
  :bind (:map org-mode-map
         ("C-c a"   . org-agenda)
         ("C-c b"   . org-iswitchb)
         ("C-c l"   . org-store-link)
         ("C-c r"   . org-remember)
         ("C-c t"   . org-table-create)
         ("C-c u"   . org-up-element)
         ("C-c s e" . org-edit-src-code)
         ("C-c s i" . org-insert-src-block))
  :config
  (evil-define-key 'motion org-mode-map (kbd "TAB") 'org-cycle) ; for terminal
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
  :bind (:map  dired-mode-map
         ("M-o"   . dired-omit-mode)
         ("j"     . dired-next-line)
         ("k"     . dired-previous-line)
         ("r"     . ora-dired-rsync)
         ("^"     . dired-up-and-close-dir)
         ("<DEL>" . dired-up-and-close-dir)
         ("<RET>" . dired-visit-file-or-dir))
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
  (defun dired-visit-file-or-dir ()
    (interactive)
    (if (file-directory-p (dired-get-filename nil t))
        (dired-find-alternate-file)
      (dired-find-file-other-window)))

  (defun dired-up-and-close-dir (&optional other-window)
    (interactive "P")
    (let ((dir (buffer-name)))
      (dired-up-directory other-window)
      (kill-buffer dir)))

  (defun ora-dired-rsync (dest)
    (interactive
     (list (read-file-name "Rsync to:" (dired-dwim-target-directory))))
    ;; store all selected files into "files" list
    (let ((files (dired-get-marked-files nil current-prefix-arg))
          (command "rsync -ahrvzP ")
          (prefix (if (string-match-p ".@.*:" dest)
                      dest
                    (shell-quote-argument (expand-file-name dest)))))
      ;; add all selected file names as arguments to the rsync command
      (dolist (file files)
        (setq command (concat command (shell-quote-argument file) " ")))
      ;; append the destination
      (setq command (concat command prefix))
      ;; run the async shell command
      (async-shell-command command "*rsync*")
      ;; finally, switch to that window
      (other-window 1)
      (view-mode)))

  (defun dired--yes-no-all-quit-help (prompt &optional help-msg)
    "Rewritten function to get input of y,n,a,q,h keys.
     This function is called when deleting folder recursively."
    (let ((cursor-in-echo-area t)
          (valid-answers (list ?y ?n ?a ?q))
          (answer "")
          (input-fn
           (lambda ()
             (read-key (propertize (format "%s [y, n, a, q, h] " prompt)
                                   'face 'minibuffer-prompt)))))
      (setq answer (funcall input-fn))
      (when (equal answer ?h)
        (with-help-window "*Help*"
          (with-current-buffer "*Help*"
            (insert (or help-msg dired-delete-help)))))
      (while (not (member answer valid-answers))
        (unless (equal answer ?h)
          (message "Please answer `y' or `n' or `a' or `q'")
          (sleep-for 2))
        (setq answer (funcall input-fn)))
      (pcase answer
        (?y "yes") (?n "no") (?a "all") (?q "quit"))))

  (setq dired-listing-switches "-alh"
        dired-omit-extensions '("~")
        dired-omit-files "^\\.?#\\|^\\.$\\|^\\.\\.$\\|^\\..+$"))


(use-package neotree
  :ensure t
  :commands my-neotree-directory
  :bind (("C-c n" . my-neotree-directory)
         :map neotree-mode-map
         ("u" . neotree-select-up-node)
         ("y" . (lambda ()
                  "Copy the absolute path of the node at point."
                  (interactive)
                  (message "Copied path : %s"
                           (neotree-copy-filepath-to-yank-ring)))))
  :init
  (evil-leader/set-key
    "n" 'my-neotree-directory)
  :config
  (defun my-neotree-directory ()
    (interactive)
    (if (neo-global--window-exists-p)
        (neotree-hide)
      (neotree-dir (projectile-project-root)))))

(use-package magit
  :ensure t
  :bind ("<f12>" . magit-status)
  :config
  (evil-make-overriding-map magit-blame-read-only-mode-map 'normal)
  (add-hook 'magit-blame-mode-hook 'evil-normalize-keymaps)
  (setq magit-log-section-commit-count 5
        magit-completing-read-function #'ivy-completing-read))

(use-package avy
  :ensure t
  :bind ("C-c C-SPC" . avy-goto-subword-1))

(use-package expand-region
  :ensure t
  :bind (("C-="   . er/expand-region)
         ("C-c =" . er/expand-region))
  :init
  (evil-leader/set-key
    "=" 'er/expand-region))

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

(use-package ido
  :disabled t
  :bind (("C-x d"   . ido-dired)
         ("C-x C-f" . ido-find-file))
  :config
  (ivy-mode t)
  (defalias 'ido-completing-read 'ivy-completing-read))

(use-package smex
  :ensure t
  :commands smex)

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

(use-package evil-anzu
  :ensure t
  :after anzu)

(use-package recentf
  :after (:any ido ivy)
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
         ("C-c q" . vr/query-replace)))

(use-package visual-regexp-steroids
  :ensure t
  :after visual-regexp)

(use-package fzf
  :ensure t
  :bind (("C-c j o" . fzf)
         ("C-c j h" . fzf-here)
         ("C-c o"   . fzf-git-files))
  :init
  (evil-leader/set-key
    "jh" 'fzf-here
    "jo" 'fzf
    "o"  'fzf-git-files)
  :config
  (require 'term)
  (defun term-send-esc ()
    "Send ESC in term mode."
    (interactive)
    (term-send-raw-string "\e"))
  ;; to quit fzf with ESC key
  (define-key term-raw-map "\e" 'term-send-esc)
  (defun fzf-here ()
    (interactive)
    (fzf/start default-directory))
  (setq fzf/window-height 20))

(use-package yasnippet
  :ensure t
  :commands yas-minor-mode
  :config
  (yas-reload-all))

(use-package yasnippet-snippets
  :ensure t
  :after yasnippet)

(use-package plantuml-mode
  :ensure t
  :mode ("\\.puml\\'" . plantuml-mode)
  :bind (:map plantuml-mode-map
         ("TAB" . company-indent-or-complete-common)
         ("C-c C-e" . plantuml-make-output))
  :config
  (setq plantuml-jar-path "/usr/share/plantuml/plantuml.jar")
  (defun plantuml-make-output ()
    (interactive)
    (set-process-sentinel
     (start-process "plantuml" nil "plantuml" (buffer-file-name))
     (lambda (&rest args) (message "PlantUML process is done")))))

(use-package ivy
  :ensure t
  :bind (("C-x b"    . ivy-switch-buffer)
         :map minibuffer-inactive-mode-map
         ("<escape>" . abort-recursive-edit)
         :map minibuffer-local-map
         ("<escape>" . abort-recursive-edit)
         :map ivy-minibuffer-map
         ("<escape>" . minibuffer-keyboard-quit)
         ("C-j"      . ivy-partial-or-done)
         ("TAB"      . ivy-alt-done))
  :init
  (evil-leader/set-key
    "b" 'ivy-switch-buffer)
  :config
  (require 'subr-x)
  (ivy-mode t)
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
  (setq ivy-height 12
        ivy-do-completion-in-region nil
        ivy-wrap t
        ivy-fixed-height-minibuffer t
        ;; Don't use ^ as initial input
        ivy-initial-inputs-alist nil
        ;; disable magic slash on non-match
        ivy-magic-slash-non-match-action nil
        ;; prefix match first
        ivy-sort-matches-functions-alist
        '((t . ivy--prefix-sort)
          (ivy-switch-buffer . ivy-sort-function-buffer))))

(use-package ivy-yasnippet
  :ensure t
  :after yasnippet
  :bind (:map yas-minor-mode-map
         ("C-c /" . ivy-yasnippet)
         :map evil-normal-state-map
         ("<SPC> /" . ivy-yasnippet))
  :config
  (advice-add 'ivy-yasnippet :before #'(lambda () (evil-insert-state))))

(use-package counsel
  :ensure t
  :commands (counsel-M-x
             counsel-find-file
             counsel-describe-variable
             counsel-describe-function)
  :bind (("M-x"     . counsel-M-x)
         ("C-x d"   . counsel-find-file)
         ("C-x C-f" . counsel-find-file)
         ("C-h v"   . counsel-describe-variable)
         ("C-h f"   . counsel-describe-function))
  :init
  (evil-leader/set-key
    "<SPC>" 'counsel-M-x
    "d"     'counsel-find-file
    "f"     'counsel-find-file
    "hv"    'counsel-describe-variable
    "hf"    'counsel-describe-function))

(use-package which-key
  :ensure t
  :init
  (which-key-mode))


(provide 'conf-general)
