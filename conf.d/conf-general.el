;;; General settings

;;; Personal packages
(use-package sk-mode-line
  :ensure nil
  :config
  (sk-mode-line))

(use-package sk-utils
  :ensure nil
  :commands (insert-date insert-date-and-time nuke-all-buffers
             hide-ctrl-M izero-insert idef-insert move-line
             buffer-save-or-load sk-clang-complete-make
             sk-byte-recompile-conf-dir sk-insert-current-week-form
             sk-insert-next-week-form tmux-new-pane-here)
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

(use-package redo+
  :ensure nil
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

(use-package company-sql
  :ensure nil
  :hook ((sql-mode sql-interactive-mode) . my-sql-mode-hook)
  :config
  (defun my-sql-mode-hook ()
    (add-to-list 'company-backends 'company-sql)
    (local-set-key (kbd "TAB") 'company-indent-or-complete-common)))


;;; Built-in packages
(use-package recentf
  :ensure nil
  :after (:any ido ivy)
  :custom (recentf-max-saved-items 100)
  :config
  (recentf-mode t)
  (add-to-list 'recentf-exclude
               (format "%s/\\.emacs\\.d/elpa/.*" (getenv "HOME"))))

(use-package ido
  :ensure nil
  :disabled t
  :bind (("C-x d"   . ido-dired)
         ("C-x C-f" . ido-find-file))
  :config
  (ivy-mode t)
  (defalias 'ido-completing-read 'ivy-completing-read))

(use-package dired
  :ensure nil
  :defer t
  :bind (:map dired-mode-map
         ("M-o"   . dired-omit-mode)
         ("j"     . dired-next-line)
         ("k"     . dired-previous-line)
         ("r"     . ora-dired-rsync)
         ("/"     . evil-search-forward)
         ("^"     . dired-up-and-close-dir)
         ("<DEL>" . dired-up-and-close-dir)
         ("<RET>" . dired-visit-file-or-dir))
  :init
  (add-to-list 'magic-mode-alist
               '((lambda () (< large-file-warning-threshold (buffer-size)))
                 . fundamental-mode))
  :config
  (require 'dired-x)
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

  ;; win32 hiding gid, uid in dired mode
  (when windowsp
    (setq ls-lisp-verbosity (delq 'uid ls-lisp-verbosity)
          ls-lisp-verbosity (delq 'gid ls-lisp-verbosity)))

  (setq dired-listing-switches "-alh --group-directories-first"
        dired-omit-extensions '("~")
        dired-omit-files "^\\.?#\\|^\\.$\\|^\\.\\.$\\|^\\..+$"))

(use-package org
  :ensure nil
  :mode ("\\.org\\'" . org-mode)
  :bind (:map org-mode-map
         ("C-c a"   . org-agenda)
         ("C-c b"   . org-iswitchb)
         ("C-c l"   . org-store-link)
         ("C-c r"   . org-remember)
         ("C-c t"   . org-table-create)
         ("C-c u"   . org-up-element)
         ("C-c s e" . org-edit-src-code))
  :config
  (evil-leader/set-key-for-mode 'org-mode
    "cl" 'org-insert-link
    "se" 'org-edit-src-code
    "ta" 'org-table-create
    "tl" 'org-tags-view
    "ts" 'org-set-tags)
  (define-key org-mode-map [tab] #'org-cycle)
  (evil-define-key 'motion org-mode-map
    "gh"        'org-up-element
    "gl"        'org-down-element
    "gj"        'org-forward-element
    "gk"        'org-backward-element)
  (evil-declare-motion 'org-up-element)
  (evil-declare-motion 'org-down-element)
  (evil-declare-motion 'org-forward-element)
  (evil-declare-motion 'org-backward-element)

  (add-to-list 'org-structure-template-alist
               '("u" "#+BEGIN_SRC plantuml :file ?.png
                    \n#+END_SRC"))
  (add-hook 'org-babel-after-execute-hook 'my-org-inline-image-hook)
  (add-hook 'org-export-before-processing-hook 'my-org-inline-css-hook)
  (defun my-org-inline-image-hook ()
    (when org-inline-image-overlays
      (org-redisplay-inline-images)))
  (defun my-org-inline-css-hook (exporter)
    (when (eq exporter 'html)
      (setq-local org-html-head-include-default-style nil)
      (setq-local org-html-head
                  (concat "<style type=\"text/css\">\n"
                          "<!--/*--><![CDATA[/*><!--*/\n"
                          (with-temp-buffer
                            (insert-file-contents
                             "~/.emacs.d/conf.d/sk-utils/org.css")
                            (buffer-string))
                          "/*]]>*/-->\n"
                          "</style>\n")))
    (when (eq exporter 'reveal)
      (setq-local org-export-with-toc nil)))
  (setq org-confirm-babel-evaluate nil
        org-footnote-definition-re "^\\[fn:[-_[:word:]]+\\]"
        org-footnote-re (concat "\\[\\(?:fn:\\([-_[:word:]]+\\)?:"
                                "\\|"
                                "\\(fn:[-_[:word:]]+\\)\\)")
        org-plantuml-jar-path "/usr/share/plantuml/plantuml.jar"
        org-startup-with-inline-images t))

(use-package ibuffer
  :ensure nil
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
           ("Code" (derived-mode . prog-mode))
           ("Shell" (or (mode . shell-mode)
                        (mode . eshell-mode)))
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

(use-package shell
  :ensure nil
  :defer t
  :config
  (bind-key "C-c C-l" 'counsel-shell-history shell-mode-map)
  (evil-leader/set-key-for-mode 'shell-mode "l" 'counsel-shell-history)
  (defun my-shell-setup ()
    (setq-local company-minimum-prefix-length 3))
  (add-hook 'shell-mode-hook 'my-shell-setup))

(use-package eshell
  :ensure nil
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
      (bind-keys :map eshell-mode-map
                 ("TAB"     . completion-at-point)
                 ("C-c C-l" . counsel-esh-history))))
  (evil-leader/set-key-for-mode 'eshell-mode "l" 'counsel-esh-history)
  (add-hook 'eshell-mode-hook 'my-eshell-setup))

(use-package cc-cmds
  :ensure nil
  :bind (("C-<backspace>" . c-hungry-backspace)
         ("C-c <DEL>"     . c-hungry-backspace))
  :init
  (evil-leader/set-key (kbd "<DEL>") 'c-hungry-backspace))

(use-package paren
  :ensure nil
  :init
  (show-paren-mode t))

(use-package hl-line
  :ensure nil
  :init
  (global-hl-line-mode t))

(use-package ansi-color
  :ensure nil
  :hook (compilation-filter . my-ansi-colorize-buffer)
  :config
  (defun my-ansi-colorize-buffer ()
    (let ((buffer-read-only nil))
      (ansi-color-apply-on-region (point-min) (point-max)))))

(use-package display-line-numbers
  :ensure nil
  :hook ((find-file prog-mode) . display-line-numbers-mode)
  :config
  (setq-default display-line-numbers-width 3
                display-line-numbers-type 'visual
                display-line-numbers-current-absolute nil))

(use-package tramp
  :ensure nil
  :defer t
  :config
  ;; TRAMP respect PATH variable on remote machine.
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))


;;; External packages
(use-package evil-leader
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
    "hm" 'describe-mode
    "xr" 'read-only-mode
    "xv" 'evil-reload-file)
  (defun evil-sub-leader-mode ()
    (let* ((sub-leader (kbd "M-m"))
           (mode-map (cdr (assoc major-mode evil-leader--mode-maps)))
           (map (or mode-map evil-leader--default-map)))
      (evil-normalize-keymaps)
      (define-key evil-motion-state-local-map sub-leader map)
      (define-key evil-emacs-state-local-map sub-leader map)))
  (add-hook 'evil-local-mode-hook #'evil-sub-leader-mode t)
  (setq evil-leader/no-prefix-mode-rx
        '("magit-.*-mode" "gnus-.*-mode" "package-.*-mode" "dired-mode")))

(use-package evil
  :bind (:map evil-insert-state-map
         ("C-a" . move-beginning-of-line)
         ("C-e" . move-end-of-line)
         ("C-k" . kill-line)
         :map evil-visual-state-map
         ("p"   . evil-paste-pgvy)
         :map evil-ex-completion-map
         ("C-a" . move-beginning-of-line)
         ("C-b" . backward-char)
         ("C-d" . delete-char)
         ("C-k" . kill-line)
         ("M-n" . next-complete-history-element)
         ("M-p" . previous-complete-history-element))
  :custom
  (evil-want-C-u-scroll t)
  :init
  (evil-mode)
  :config
  (add-hook 'evil-insert-state-entry-hook
            (lambda () (when buffer-read-only (read-only-mode -1))))
  (defun evil-reload-file ()
    (interactive)
    (find-alternate-file (buffer-file-name)))
  ;; mouse disabled in evil
  (defun evil-mouse-drag-track (start &optional opt) nil)
  (defun evil-paste-pgvy ()
    "Paste and restore visual block and yank."
    (interactive)
    (call-interactively 'evil-paste-after)
    (evil-visual-restore)
    (call-interactively 'evil-yank))
  (evil-global-set-key 'normal "Y" (kbd "y$"))
  (evil-set-initial-state 'term-mode   'emacs)
  (evil-set-initial-state 'dired-mode  'emacs)
  (evil-set-initial-state 'shell-mode  'emacs)
  (evil-set-initial-state 'eshell-mode 'emacs)
  (evil-set-initial-state 'sql-interactive-mode 'emacs))

(use-package evil-anzu
  :after anzu)

(use-package evil-visualstar
  :bind (:map evil-visual-state-map
         ("/" . evil-visualstar/begin-search-forward)
         ("?" . evil-visualstar/begin-search-backward)
         ("n" . evil-visualstar/begin-search-forward)
         ("N" . evil-visualstar/begin-search-backward))
  :config
  (global-evil-visualstar-mode))

(use-package evil-matchit
  :config
  (global-evil-matchit-mode 1))

(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

(use-package evil-commentary
  :config
  (evil-commentary-mode)
  (evil-ex-define-cmd "gc" 'evil-commentary))

(use-package bind-key
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
             ("M-,"              . other-window)
             ("C-\\"             . toggle-korean-input-method)))

(use-package company
  :init
  (global-company-mode 1)
  (setq company-idle-delay 0.1
        company-minimum-prefix-length 2)
  :config
  (evil-define-key 'insert company-mode-map
    (kbd "TAB") 'company-indent-or-complete-common))

(use-package company-irony
  :after irony
  :config
  (add-to-list 'company-backends 'company-irony))

(use-package company-irony-c-headers
  :after irony
  :config
  (add-to-list 'company-backends 'company-irony-c-headers))

(use-package company-tern
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
  :after web-mode)

(use-package company-go
  :after go-mode
  :config
  (add-to-list 'company-backends 'company-go))

(use-package irony
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
  :hook ((c-mode c++-mode) . flycheck-mode))

(use-package undo-tree
  :config
  (require 'redo+))

(use-package wgrep
  :commands wgrep-change-to-wgrep-mode
  :bind (:map helm-git-grep-mode-map
         ("C-c C-e" . wgrep-change-to-wgrep-mode)
         ("C-c C-s" . wgrep-save-all-buffers)))

(use-package helm
  :bind (("C-c i"   . helm-semantic-or-imenu)
         ("C-c y"   . helm-show-kill-ring)
         ("C-x C-r" . helm-recentf)
         ("C-c h o" . helm-occur)
         ("C-c h r" . helm-resume))
  :init
  (evil-leader/set-key
    "i"  'helm-semantic-or-imenu
    "y"  'helm-show-kill-ring
    "ho" 'helm-occur
    "hr" 'helm-resume
    "jp" 'helm-ag-project-or-here
    "jP" 'helm-ag-here)
  :config
  (helm-autoresize-mode 1)
  (setq helm-imenu-execute-action-at-once-if-one nil
        helm-split-window-default-side 'right
        helm-show-completion-display-function nil))

(use-package helm-ag
  :commands (helm-ag-project-or-here helm-ag-here)
  :bind (("C-c j p" . helm-ag-project-or-here)
         ("C-c j P" . helm-ag-here))
  :init
  (evil-leader/set-key
    "jp" 'helm-ag-project-or-here
    "jP" 'helm-ag-here)
  :config
  (defun helm-ag-project-or-here ()
    (interactive)
    (helm-do-ag
     (my-project-root-or-dir)
     (car (projectile-parse-dirconfig-file))))
  (defun helm-ag-here ()
    (interactive)
    (helm-do-ag default-directory))
  (setq helm-ag-insert-at-point 'symbol
        helm-ag-use-grep-ignore-list t))

(use-package helm-git-grep
  :bind (("C-c p" . helm-git-grep-at-point))
  :init
  (evil-leader/set-key
    "p" 'helm-git-grep-at-point))

(use-package projectile
  :commands my-project-root-or-dir
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
  (setq projectile-completion-system 'ivy
        projectile-require-project-root nil
        projectile-switch-project-action 'projectile-dired
        projectile-track-known-projects-automatically nil)
  :config
  (projectile-mode 1)
  (defun my-project-root-or-dir ()
    (or (projectile-project-root) default-directory)))

(use-package markdown-mode
  :defer t)

(use-package markdown-toc
  :defer t)

(use-package ox-reveal
  :after org
  :config
  (setq org-reveal-root "https://cdnjs.cloudflare.com/ajax/libs/reveal.js/3.7.0"
        org-reveal-title-slide "<h1>%t</h1><h4>%a&nbsp(%e)</h4>"
        org-reveal-plugins '(classList markdown highlight zoom notes)
        org-reveal-theme "moon"
        org-reveal-transition nil
        org-reveal-center nil))

(use-package neotree
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
  (evil-set-initial-state 'neotree-mode 'emacs)
  (defun my-neotree-directory ()
    (interactive)
    (if (neo-global--window-exists-p)
        (neotree-hide)
      (neotree-dir (my-project-root-or-dir)))))

(use-package magit
  :bind ("<f12>" . magit-status)
  :config
  (evil-make-overriding-map magit-blame-read-only-mode-map 'normal)
  (add-hook 'magit-blame-mode-hook 'evil-normalize-keymaps)
  (setq magit-log-section-commit-count 5
        magit-completing-read-function #'ivy-completing-read))

(use-package avy
  :bind ("C-c C-SPC" . avy-goto-subword-1))

(use-package expand-region
  :bind (("C-="   . er/expand-region)
         ("C-c =" . er/expand-region))
  :init
  (evil-leader/set-key
    "=" 'er/expand-region))

(use-package smex
  :commands smex)

(use-package anzu
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

(use-package htmlize
  :after org)

(use-package korean-holidays
  :config
  (setq calendar-holidays korean-holidays))

(use-package visual-regexp
  :bind (("C-c r" . vr/replace)
         ("C-c q" . vr/query-replace)
         :map evil-motion-state-map
         ("gR"    . vr/replace)
         ("gQ"    . vr/query-replace)))

(use-package visual-regexp-steroids
  :after visual-regexp)

(use-package fzf
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
  (define-key term-raw-map (kbd "<escape>") 'term-send-esc)
  (defun fzf-here ()
    (interactive)
    (fzf/start default-directory))
  (setq fzf/window-height 20))

(use-package yasnippet
  :commands yas-minor-mode
  :config
  (yas-reload-all))

(use-package yasnippet-snippets
  :after yasnippet)

(use-package plantuml-mode
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
                      (or
                       (buffer-local-value 'default-directory buf)
                       "~/")))
           (path-file (buffer-file-name buf))
           (path-choice (or (if path-file (abbreviate-file-name path-file))
                            (if (or (string-match-p "shell" str)
                                    (equal (buffer-local-value 'major-mode buf)
                                           'dired-mode))
                                path-dir)
                            nil))
           (path-prefix (if (equal (and path-choice
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
                     (concat path-prefix
                             "…"
                             (replace-regexp-in-string "^[^~/]*" "" path-mod))
                   path-choice)))
      (format "%-35s %-20s %s" buf mode (or path ""))))
  (ivy-set-display-transformer 'ivy-switch-buffer
                               'ivy-buffer-transformer-sk)
  (setq ivy-height 15
        ivy-height-alist '((t . 15))
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
  :after yasnippet
  :bind (:map yas-minor-mode-map
         ("C-c /" . ivy-yasnippet)
         :map evil-normal-state-map
         ("<SPC> /" . ivy-yasnippet))
  :config
  (advice-add 'ivy-yasnippet :before #'(lambda () (evil-insert-state))))

(use-package counsel
  :commands counsel-fzf-here
  :bind (("M-x"     . counsel-M-x)
         ("C-x d"   . counsel-find-file)
         ("C-x C-f" . counsel-find-file)
         ("C-h v"   . counsel-describe-variable)
         ("C-h f"   . counsel-describe-function)
         :map minibuffer-local-map
         ("C-r"     . counsel-minibuffer-history))
  :init
  (evil-leader/set-key
    "<SPC>" 'counsel-M-x
    "d"     'counsel-find-file
    "f"     'counsel-find-file
    "r"     'counsel-recentf
    "hv"    'counsel-describe-variable
    "hf"    'counsel-describe-function
    "jc"    'counsel-fzf-here)
  :config
  (defun counsel-fzf-here ()
    (interactive)
    (counsel-fzf nil default-directory))
  (setq ivy-height-alist '((t . 15))))

(use-package which-key
  :init
  (which-key-mode))


(provide 'conf-general)
