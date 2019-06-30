;;; General settings -*- lexical-binding: t -*-

;;; Personal packages
(use-package sk-mode-line
  :ensure nil
  :demand t
  :config
  (sk-mode-line))

(use-package sk-utils
  :ensure nil
  :commands (insert-date insert-date-and-time nuke-all-buffers
             hide-ctrl-M izero-insert idef-insert move-line
             buffer-save-or-load sk-clang-complete-make
             sk-byte-recompile-conf-dir sk-insert-current-week-form
             sk-insert-next-week-form tmux-new-pane-here
             find-file-in-tree)
  :bind (("<f5>"       . sk-make)
         ("C-<f5>"     . sk-rebuild)
         ("C-M-,"      . transpose-windows)
         ("M-S-<up>"   . (lambda () (interactive) (move-line -1)))
         ("M-S-<down>" . (lambda () (interactive) (move-line  1)))
         ("<f7>"       . (lambda () (interactive) (buffer-save-or-load 7 t)))
         ("<f8>"       . (lambda () (interactive) (buffer-save-or-load 8 t)))
         ("C-<f7>"     . (lambda () (interactive) (buffer-save-or-load 7)))
         ("C-<f8>"     . (lambda () (interactive) (buffer-save-or-load 8))))
  :init
  (defmacro sk-switch-buffer-repl (name mode repl run-repl)
    (let ((last-mode (intern (concat "my-last-buffer-" (symbol-name mode))))
          (last-repl (intern (concat "my-last-repl-" (symbol-name repl)))))
      `(progn
         (defvar ,last-mode "")
         (defvar ,last-repl "")
         (defun ,name ()
           (interactive)
           (cond ((equal major-mode ',mode)
                  (setq ,last-mode (buffer-name))
                  (if (get-buffer ,last-repl)
                      (pop-to-buffer ,last-repl)
                    (call-interactively ',run-repl)))
                 ((equal major-mode ',repl)
                  (setq ,last-repl (buffer-name))
                  (if (get-buffer ,last-mode)
                      (pop-to-buffer ,last-mode)
                    nil))
                 (t nil)))))))

(use-package company-sql
  :ensure nil
  :hook ((sql-mode sql-interactive-mode) . my-sql-mode-hook)
  :config
  (defun my-sql-mode-hook ()
    (add-to-list 'company-backends 'company-sql)))


;;; Built-in packages
(use-package korea-util
  :ensure nil
  :bind ("C-\\" . toggle-korean-input-method)
  :init
  (setq default-korean-keyboard "3")
  (when window-system
    (set-fontset-font t 'hangul (font-spec :name "D2Coding"))
    (set-fontset-font t 'unicode (font-spec :name "D2Coding")))
  (setup-korean-environment-internal))

(use-package recentf
  :ensure nil
  :hook (find-file . recentf-mode)
  :custom (recentf-max-saved-items 100)
  :config
  (add-to-list 'recentf-exclude
               (format "%s/\\.emacs\\.d/elpa/.*" (getenv "HOME"))))

(use-package ido
  :ensure nil
  :config
  (ivy-mode 1)
  (defalias 'ido-completing-read 'ivy-completing-read))

(use-package calendar
  :config
  :bind (:map calendar-mode-map
          ("h"       . calendar-backward-day)
          ("j"       . calendar-forward-week)
          ("k"       . calendar-backward-week)
          ("l"       . calendar-forward-day)
          ("C-f"     . calendar-scroll-left-three-months)
          ("C-b"     . calendar-scroll-right-three-months)
          ("<left>"  . calendar-scroll-right)
          ("<right>" . calendar-scroll-left)))

(use-package dired
  :ensure nil
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
  (setq dired-listing-switches "-alh --group-directories-first"
        dired-omit-extensions '("~")
        dired-omit-files "^\\.?#\\|^\\.$\\|^\\.\\.$\\|^\\..+$")

  (require 'dired-x)
  (add-hook 'dired-mode-hook (lambda () (dired-omit-mode)))

  (evil-leader/set-key-for-mode 'dired-mode
    "c"  'my-dired-copy-path            ; copy current folder path
    "C"  'my-dired-copy-filepath        ; copy selected file path
    "ee" 'wdired-change-to-wdired-mode
    "ec" 'wdired-finish-edit
    "eq" 'wdired-exit)

  (defun my-dired-copy-path ()
    (interactive)
    (let ((path (expand-file-name default-directory)))
      (kill-new path)
      (message "Copied path : %s" path)))

  (defun my-dired-copy-filepath ()
    (interactive)
    (let ((path (dired-filename-at-point)))
      (kill-new path)
      (message "Copied path : %s" path)))

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
      (view-mode))))

(use-package org
  :ensure nil
  :bind (:map org-mode-map
          ("C-c a"   . org-agenda)
          ("C-c b"   . org-iswitchb)
          ("C-c l"   . org-store-link)
          ("C-c r"   . org-remember)
          ("C-c t"   . org-table-create)
          ("C-c u"   . org-up-element)
          ("C-c s e" . org-edit-src-code))
  :config
  (setq
   org-agenda-files '("~/Dropbox/org/")
   org-babel-load-languages '((css . t)
                              (emacs-lisp . t)
                              (octave . t)
                              (plantuml . t)
                              (python . t)
                              (shell . t))
   org-confirm-babel-evaluate nil
   org-export-default-language "kr"
   org-export-headline-levels 2
   org-export-time-stamp-file nil
   org-export-with-email t
   org-export-with-section-numbers nil
   org-export-with-sub-superscripts nil
   org-footnote-definition-re "^\\[fn:[-_[:word:]]+\\]"
   org-footnote-re (concat "\\[\\(?:fn:\\([-_[:word:]]+\\)?:"
                           "\\|"
                           "\\(fn:[-_[:word:]]+\\)\\)")
   org-html-inline-image-rules
   '(("file" . "\\.\\(jpeg\\|jpg\\|png\\|gif\\|svg\\|bmp\\)\\'")
     ("http" . "\\.\\(jpeg\\|jpg\\|png\\|gif\\|svg\\|bmp\\)\\'")
     ("https" . "\\.\\(jpeg\\|jpg\\|png\\|gif\\|svg\\|bmp\\)\\'"))
   org-html-metadata-timestamp-format "%Y-%m-%d"
   org-html-validation-link ""
   org-latex-packages-alist '(("" "parskip" nil) ("" "kotex" nil))
   org-log-done 'time
   org-plantuml-jar-path (getenv "PLANTUML_PATH")
   org-startup-indented t
   org-startup-with-inline-images t)
  (evil-leader/set-key-for-mode 'org-mode
    "ca" 'org-agenda
    "cb" 'org-iswitchb
    "cc" 'org-ctrl-c-ctrl-c
    "ce" 'org-export-dispatch
    "ci" 'org-insert-link
    "cl" 'org-store-link
    "cr" 'org-remember
    "ct" 'org-table-create
    "se" 'org-edit-src-code
    "si" 'org-insert-structure-template
    "tl" 'org-tags-view
    "ts" 'org-set-tags)
  (evil-define-key 'insert org-mode-map
    (kbd "<tab>") 'company-indent-or-complete-common)
  (evil-define-key 'motion org-mode-map
    (kbd "TAB") 'org-cycle
    "gh" 'org-up-element
    "gl" 'org-down-element
    "gj" 'org-forward-element
    "gk" 'org-backward-element)
  (evil-leader/set-key-minor-mode 'org-src-mode
    "ec" 'org-edit-src-exit
    "eq" 'org-edit-src-abort)
  (evil-declare-motion 'org-up-element)
  (evil-declare-motion 'org-down-element)
  (evil-declare-motion 'org-forward-element)
  (evil-declare-motion 'org-backward-element)

  (dolist (mode '("js" "javascript"))
    (add-to-list 'org-src-lang-modes `(,mode . js2)))
  (dolist (mode '("css" "html" "vue" "web"))
    (add-to-list 'org-src-lang-modes `(,mode . web)))

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
  (add-hook 'org-babel-after-execute-hook 'my-org-inline-image-hook)
  (add-hook 'org-export-before-processing-hook 'my-org-inline-css-hook))

(use-package ibuffer
  :ensure nil
  :bind ("C-x C-b" . ibuffer)
  :init
  (evil-leader/set-key
    "xb" 'ibuffer)
  :config
  (setq ibuffer-expert t
        ibuffer-sorting-mode 'alphabetic
        ibuffer-default-sorting-mode 'major-mode
        ibuffer-saved-filter-groups
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
  :config
  (defun my-shell-history ()
    (interactive)
    (my-shell-return)
    (counsel-shell-history))
  (evil-leader/set-key-for-mode 'shell-mode "l" 'my-shell-history)
  (evil-define-key 'motion shell-mode-map
    "gk" 'comint-previous-prompt
    "gj" 'comint-next-prompt)
  (evil-define-key 'normal shell-mode-map
    (kbd "RET") 'my-shell-return))

(use-package eshell
  :ensure nil
  :hook (eshell-mode . my-eshell-setup)
  :config
  (defun eshell/clear ()
    "Clear Eshell buffer"
    (interactive)
    (let ((inhibit-read-only t))
      (erase-buffer)
      (execute-kbd-macro (kbd "<RET>"))))
  (defun my-eshell-change-whole-line ()
    (interactive)
    (execute-kbd-macro (kbd "0C")))
  (defun my-eshell-history ()
    (interactive)
    (my-shell-return)
    (counsel-esh-history))
  (defun my-eshell-setup ()
    (setenv "TERM" "screen-256color")
    (evil-define-key 'insert eshell-mode-map (kbd "C-a") 'eshell-bol)
    (evil-define-key 'normal eshell-mode-map "S" 'my-eshell-change-whole-line)
    (evil-define-key 'motion eshell-mode-map
      "0" 'eshell-bol
      "gk" 'eshell-previous-prompt
      "gj" 'eshell-next-prompt
      (kbd "M-p") (lambda () (interactive) nil)
      (kbd "M-n") (lambda () (interactive) nil)
      (kbd "RET") 'my-shell-return))
  (evil-leader/set-key-for-mode 'eshell-mode "l" 'my-eshell-history))

(use-package cc-cmds
  :ensure nil
  :bind (("C-<backspace>" . c-hungry-backspace)
         ("C-c <DEL>"     . c-hungry-backspace))
  :init
  (evil-leader/set-key (kbd "<DEL>") 'c-hungry-backspace))

(use-package paren
  :ensure nil
  :init
  (show-paren-mode 1))

(use-package hl-line
  :ensure nil
  :init
  (global-hl-line-mode 1))

(use-package ansi-color
  :ensure nil
  :hook (compilation-filter . my-ansi-colorize-buffer)
  :config
  (defun my-ansi-colorize-buffer ()
    (let ((buffer-read-only nil))
      (ansi-color-apply-on-region (point-min) (point-max)))))

(use-package display-line-numbers
  :ensure nil
  :custom-face (line-number-current-line ((t (:weight bold))))
  :hook ((find-file prog-mode) . display-line-numbers-mode)
  :config
  (setq-default display-line-numbers-width 3
                display-line-numbers-type 'visual
                display-line-numbers-current-absolute nil))

(use-package tramp
  :ensure nil
  :config
  ;; TRAMP respect PATH variable on remote machine.
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))


;;; External packages
(use-package evil-leader
  :init
  (defvar sk-evil-sub-leader "M-m")
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
    "hk" 'describe-key
    "hm" 'describe-mode
    "xr" 'read-only-mode
    "xv" 'evil-reload-file)
  (defun evil-sub-leader-mode ()
    (let* ((sub-leader (kbd sk-evil-sub-leader))
           (mode-map (cdr (assoc major-mode evil-leader--mode-maps)))
           (map (or mode-map evil-leader--default-map)))
      (evil-normalize-keymaps)
      (define-key evil-motion-state-local-map sub-leader map)
      (define-key evil-insert-state-local-map sub-leader map)
      (define-key evil-emacs-state-local-map sub-leader map)))
  (add-hook 'evil-local-mode-hook #'evil-sub-leader-mode t)
  (defun evil-leader/set-key-minor-mode (mode key def &rest bindings)
    (while key
      (evil-define-minor-mode-key 'motion mode
        (kbd (concat evil-leader/leader key)) def)
      (evil-define-minor-mode-key 'motion mode
        (kbd (concat sk-evil-sub-leader " " key)) def)
    (setq key (pop bindings)
          def (pop bindings))))
  (put 'evil-leader/set-key-minor-mode 'lisp-indent-function 'defun)
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
  (setq evil-insert-state-modes (delete 'wdired-mode evil-insert-state-modes))
  (add-hook 'evil-insert-state-entry-hook
            (lambda () (when buffer-read-only (read-only-mode -1))))
  (defun my-shell-return ()
    (interactive)
    (evil-goto-line)
    (evil-append-line 1))
  (defun evil-reload-file ()
    (interactive)
    (find-alternate-file (buffer-file-name)))
  ;; mouse disabled in evil
  (defun evil-mouse-drag-track (&rest _) nil)
  (defun evil-paste-pgvy ()
    "Paste and restore visual block and yank."
    (interactive)
    (call-interactively 'evil-paste-after)
    (evil-visual-restore)
    (call-interactively 'evil-yank))
  (defun evil-swap-key (map key1 key2)
    "Swap KEY1 and KEY2 in MAP"
    (let  ((def1 (lookup-key map key1))
           (def2 (lookup-key map key2)))
      (define-key map key1 def2)
      (define-key map key2 def1)))
  (evil-swap-key evil-motion-state-map "j" "gj")
  (evil-swap-key evil-motion-state-map "k" "gk")
  (evil-global-set-key 'normal "Y" (kbd "y$"))
  (evil-global-set-key 'motion "$" 'end-of-line)
  (evil-set-initial-state 'calendar-mode 'emacs)
  (evil-set-initial-state 'dired-mode 'emacs)
  (evil-set-initial-state 'term-mode  'emacs))

(use-package evil-anzu
  :demand t
  :after anzu)

(use-package evil-visualstar
  :bind (:map evil-visual-state-map
          ("n" . evil-visualstar/begin-search-forward)
          ("N" . evil-visualstar/begin-search-backward))
  :config
  (global-evil-visualstar-mode))

(use-package evil-surround
  :init
  (global-evil-surround-mode 1))

(use-package evil-commentary
  :init
  (evil-commentary-mode))

(use-package bind-key
  :init
  (bind-keys* ("<mouse-1>"        . nil)
              ("<mouse-3>"        . nil)
              ("<down-mouse-1>"   . nil)
              ("<down-mouse-3>"   . nil)
              ("<drag-mouse-1>"   . nil)
              ("<drag-mouse-3>"   . nil)
              ("<C-down-mouse-1>" . nil)
              ("<M-down-mouse-1>" . nil)
              ("<S-down-mouse-1>" . nil)
              ("M-,"              . my-other-window))
  (defun my-other-window ()
    (interactive)
    (if (minibufferp)
        (abort-recursive-edit)
      (call-interactively 'other-window))))

(use-package company
  :custom-face (company-tooltip
                ((t (:foreground "Black" :background "Yellow3"))))
  :init
  (global-company-mode 1)
  :config
  (setq company-idle-delay 0.3)
  (evil-define-key 'insert company-mode-map
    (kbd "TAB") 'company-indent-or-complete-common))

(use-package company-irony
  :demand t
  :after irony
  :config
  (add-to-list 'company-backends 'company-irony))

(use-package company-irony-c-headers
  :demand t
  :after irony
  :config
  (add-to-list 'company-backends 'company-irony-c-headers))

(use-package company-tern
  :demand t
  :after tern
  :config
  (defun advice-company-tern (&rest _)
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
  :demand t
  :after web-mode)

(use-package company-go
  :demand t
  :after go-mode
  :config
  (add-to-list 'company-backends 'company-go))

(use-package company-ghc
  :demand t
  :after haskell-mode
  :config
  (add-to-list 'company-backends 'company-ghc))

(use-package slime-company)

(use-package undo-tree
  :config
  (evil-set-initial-state 'undo-tree-visualizer-mode 'emacs)
  (evil-leader/set-key
    "xu" 'undo-tree-visualize))

(use-package wgrep
  :commands wgrep-change-to-wgrep-mode
  :bind (:map helm-git-grep-mode-map
          ("C-c C-e" . wgrep-change-to-wgrep-mode)
          ("C-c C-s" . wgrep-save-all-buffers)))

(use-package helm
  :bind (("M-y"     . helm-show-kill-ring)
         ("C-c i"   . helm-semantic-or-imenu)
         ("C-x C-r" . helm-recentf)
         ("C-c h o" . helm-occur)
         ("C-c h r" . helm-resume)
         :map helm-map
         ("<escape>". helm-keyboard-quit))
  :init
  (evil-leader/set-key
    "i"  'helm-semantic-or-imenu
    "y"  'helm-show-kill-ring
    "ho" 'helm-occur
    "hr" 'helm-resume)
  :config
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
  (setq helm-ag-insert-at-point 'symbol
        helm-ag-use-grep-ignore-list t)
  (defun helm-ag-project-or-here ()
    (interactive)
    (helm-do-ag
     (my-project-root-or-dir)
     (car (projectile-parse-dirconfig-file))))
  (defun helm-ag-here ()
    (interactive)
    (helm-do-ag default-directory)))

(use-package helm-git-grep
  :bind (("C-c p" . helm-git-grep-at-point))
  :init
  (evil-leader/set-key
    "p" 'helm-git-grep-at-point))

(use-package projectile
  :commands (my-project-root-or-dir
             sk-add-known-project
             sk-remove-known-project)
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
  :config
  (setq projectile-completion-system 'ivy
        projectile-require-project-root nil
        projectile-switch-project-action 'projectile-dired
        projectile-track-known-projects-automatically nil)
  (projectile-mode 1)
  (defun my-project-root-or-dir ()
    (or (projectile-project-root) default-directory))
  (defun sk-add-known-project (project-root)
    "Make .projectile file and add the project to known projects list."
    (interactive (list (read-directory-name "Add to known projects: ")))
    (let ((pfile (concat project-root ".projectile")))
      (unless (file-exists-p pfile)
        (write-region "" nil pfile)))
    (projectile-add-known-project project-root))
  (defalias 'sk-remove-known-project 'projectile-remove-known-project))

(use-package markdown-mode)

(use-package markdown-toc)

(use-package ox-reveal
  :demand t
  :after org
  :custom (org-reveal-note-key-char nil)
  :config
  (setq org-reveal-center t
        org-reveal-hlevel 2
        org-reveal-plugins '(classList markdown highlight zoom notes)
        org-reveal-root "https://cdnjs.cloudflare.com/ajax/libs/reveal.js/3.7.0"
        org-reveal-theme "moon"
        org-reveal-title-slide "<h2>%t</h2><h4>%a&nbsp(%e)</h4>"
        org-reveal-transition nil))

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
  :init
  (evil-leader/set-key
    "gs" 'magit-status
    "gb" 'magit-blame)
  :config
  (setq magit-log-section-commit-count 5
        magit-completing-read-function #'ivy-completing-read)
  (bind-key "<escape>" 'transient-quit-one transient-map)
  (evil-make-overriding-map magit-blame-read-only-mode-map 'normal)
  (add-hook 'magit-blame-mode-hook 'evil-normalize-keymaps))

(use-package expand-region
  :bind (("C-="   . er/expand-region)
         ("C-c =" . er/expand-region))
  :init
  (evil-leader/set-key
    "=" 'er/expand-region))

(use-package smex
  :commands smex)

(use-package anzu
  :init
  (defun isearch-anzu-advice (&rest _)
    (global-anzu-mode 1))
  (advice-add #'isearch-forward :before #'isearch-anzu-advice)
  (advice-add #'isearch-backward :before #'isearch-anzu-advice)
  :config
  (setq anzu-search-threshold 1000
        anzu-replace-threshold 1000)
  (advice-remove #'isearch-forward #'isearch-anzu-advice)
  (advice-remove #'isearch-backward #'isearch-anzu-advice))

(use-package htmlize
  :demand t
  :after org)

(use-package korean-holidays
  :init
  (setq calendar-holidays korean-holidays))

(use-package visual-regexp
  :bind (("C-c r" . vr/replace)
         ("C-c q" . vr/query-replace)
         :map evil-motion-state-map
         ("gR"    . vr/replace)
         ("gQ"    . vr/query-replace)))

(use-package visual-regexp-steroids
  :demand t
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
  (setq fzf/window-height 20)
  (require 'term)
  (defun term-send-esc ()
    "Send ESC in term mode."
    (interactive)
    (term-send-raw-string "\e"))
  ;; to quit fzf with ESC key
  (define-key term-raw-map (kbd "<escape>") 'term-send-esc)
  (defun fzf-here ()
    (interactive)
    (fzf/start default-directory)))

(use-package yasnippet
  :commands yas-minor-mode
  :config
  (yas-reload-all))

(use-package yasnippet-snippets
  :demand t
  :after yasnippet)

(use-package ivy
  :bind (("C-x b"    . ivy-switch-buffer)
         :map minibuffer-inactive-mode-map
         ("<escape>" . abort-recursive-edit)
         :map ivy-minibuffer-map
         ("<escape>" . minibuffer-keyboard-quit)
         ("C-j"      . ivy-partial)
         ("TAB"      . ivy-alt-done))
  :init
  (evil-leader/set-key
    "b" 'ivy-switch-buffer)
  :config
  (setq ivy-height 15
        ivy-height-alist '((t . 15))
        ivy-wrap t
        ivy-fixed-height-minibuffer t
        ;; Don't use ^ as initial input
        ivy-initial-inputs-alist nil
        ;; disable magic slash on non-match
        ivy-magic-slash-non-match-action nil
        ;; prefix match first
        ivy-sort-matches-functions-alist
        '((t . ivy--prefix-sort)
          (ivy-switch-buffer . ivy-sort-function-buffer)))
  (require 'subr-x)
  (ivy-mode 1)
  (when window-system
    (ivy-posframe-mode 1))
  (defun my-comint-history ()
    (interactive)
    (my-shell-return)
    (ivy-read "Symbol name: " (ring-elements comint-input-ring)
              :action (lambda (cmd) (insert cmd))))
  (defun sk-ivy-buffer-transformer (str)
    (let* ((buf (get-buffer str))
           (buf-dir (buffer-local-value 'default-directory buf))
           (buf-mode (buffer-local-value 'major-mode buf))
           (mode (capitalize
                  (string-remove-suffix "-mode" (symbol-name buf-mode))))
           (max-path-len (max 0 (- (frame-width) 62)))
           (path-dir (abbreviate-file-name (or buf-dir "~/")))
           (path-file (when-let ((name (buffer-file-name buf)))
                        (abbreviate-file-name name)))
           (path-opt (or path-file
                         (when (or (string-match-p "shell" str)
                                   (equal buf-mode 'dired-mode))
                           path-dir)))
           (path-prefix (if (string-prefix-p "~" path-opt)
                            "~/"
                          "/"))
           (path-len (length path-opt))
           (path-mod (if (<= path-len max-path-len)
                         nil
                       (substring path-opt (- path-len max-path-len) path-len)))
           (path (if path-mod
                     (concat path-prefix
                             "…"
                             (replace-regexp-in-string "^[^~/]*" "" path-mod))
                   path-opt)))
      (format "%-35s %-20s %s" buf mode (or path ""))))
  (ivy-set-display-transformer 'ivy-switch-buffer 'sk-ivy-buffer-transformer))

(use-package ivy-yasnippet
  :init
  (evil-leader/set-key "/" 'ivy-yasnippet)
  :config
  (advice-add 'ivy-yasnippet :before (lambda ()
                                       (yas-minor-mode 1)
                                       (evil-insert-state))))
(use-package ivy-posframe
  :custom-face
  (ivy-posframe ((t (:background "#282a36" :foreground "Gray80"))))
  :config
  (setq ivy-posframe-display-functions-alist
        '((complete-symbol . nil)
          (ivy-yasnippet   . nil)
          (swiper          . nil)
          (t               . ivy-posframe-display-at-frame-center))))

(use-package posframe)

(use-package counsel
  :commands counsel-fzf-here
  :bind (("M-x"     . counsel-M-x)
         ("C-x d"   . counsel-find-file)
         ("C-x C-f" . counsel-find-file)
         ("C-h b"   . counsel-descbinds)
         ("C-h v"   . counsel-describe-variable)
         ("C-h f"   . counsel-describe-function))
  :init
  (evil-leader/set-key
    "<SPC>" 'counsel-M-x
    "M-m"   'counsel-M-x
    "d"     'counsel-find-file
    "f"     'counsel-find-file
    "r"     'counsel-recentf
    "hb"    'counsel-descbinds
    "hv"    'counsel-describe-variable
    "hf"    'counsel-describe-function
    "jc"    'counsel-fzf-here)
  :config
  (setq ivy-height-alist '((t . 15)))
  (defun counsel-fzf-here ()
    (interactive)
    (counsel-fzf nil default-directory)))

(use-package which-key
  :init
  (which-key-mode))


(provide 'conf-general)
