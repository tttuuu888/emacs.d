;;; Developement settings

(use-package elec-pair
  :defer t
  :hook (prog-mode . electric-pair-mode))

(use-package xref
  :commands xref-find-reference-here
  :bind (:map xref--xref-buffer-mode-map
         ("<return>" . xref-quit-and-goto-xref)
         ("<RET>"    . xref-quit-and-goto-xref))
  :init
  (evil-define-key 'normal prog-mode-map
    "gd" 'xref-find-definitions
    "gp" 'xref-pop-marker-stack
    "gr" 'xref-find-reference-here
    "g[" 'xref-pop-marker-stack)
  :config
  (evil-set-initial-state 'xref--xref-buffer-mode 'emacs)
  (defun xref-find-reference-here ()
    (interactive)
    (xref-find-references (thing-at-point 'symbol))))

(use-package gdb-mi
  :defer t
  :init
  (advice-add 'gdb-setup-windows :after
              (lambda (&rest args)
                (set-window-dedicated-p (selected-window) t)))
  :config
  (gdb-many-windows t)
  (dolist (mm '(gdb-edit-locals-map-1
                gdb-locals-mode-map
                gdb-locals-watch-map
                gdb-registers-mode-map
                gdb-frames-mode-map
                gdb-breakpoints-mode-map
                gdb-threads-mode-map))
    (bind-keys :map (symbol-value mm)
               ("j" . next-line)
               ("k" . previous-line))))

(use-package make-mode
  :defer t
  :mode ("Makefile.*" . makefile-gmake-mode))

(use-package cff
  :ensure t
  :defer t
  :init
  (add-hook 'c-mode-common-hook
            (lambda () (local-set-key (kbd "M-o") 'cff-find-other-file))))

(use-package ggtags
  :ensure t
  :hook ((c-mode-common asm-mode) . ggtags-mode)
  :config
  (evil-define-key 'normal ggtags-mode-map
    "gd" 'ggtags-find-tag-dwim
    "gr" 'ggtags-find-reference)
  (evil-define-key 'motion ggtags-navigation-mode-map
    (kbd "RET") 'ggtags-navigation-mode-done))

(use-package rtags
  :disabled t
  :ensure t
  :defer t
  :commands my-rtags-index
  :init
  (add-hook 'c-mode-common-hook 'rtags-start-process-unless-running)
  :config
  (require 'helm-utils)
  (require 'helm-rtags)
  (require 'sk-utils)
  (setq rtags-autostart-diagnostics t
        rtags-use-helm t)
  (rtags-enable-standard-keybindings)
  (rtags-start-process-unless-running)
  (add-hook 'kill-emacs-hook 'rtags-quit-rdm)
  (defun my-rtags-index ()
    (interactive)
    (let ((dir (find-file-in-tree (file-name-directory default-directory)
                                  "compile_commands.json"
                                  (or (projectile-project-root)
                                      default-directory))))
      (if (equal dir nil)
          (message "You can make 'compile_commands.json' by 'bear make'.")
        (shell-command (concat "rc -J " dir))))))

(use-package xcscope
  :ensure t
  :hook ((c-mode-common asm-mode) . cscope-minor-mode)
  :config
  (bind-key "<mouse-3>" 'nil cscope-minor-mode-keymap))

(use-package which-func
  :defer t
  :hook ((c-mode-common python-mode js-mode) . my-which-function-setup)
  :config
  (defun my-which-function-setup ()
    (which-function-mode)
    (setq-local header-line-format
                '((which-func-mode ("" which-func-format " "))))
    (setq which-func-unknown "N/A")))

(use-package python
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python" . python-mode)
  :commands sk-toggle-python
  :bind (:map python-mode-map
         ("TAB" . company-indent-or-complete-common))
  :config
  (evil-set-initial-state 'inferior-python-mode 'emacs)
  (elpy-enable)
  (defun sk-toggle-python ()
    "Toggle between Python2 and Python3"
    (interactive)
    (let ((python (if (equal elpy-rpc-python-command "python3")
                      "python2"
                    "python3")))
      (setq python-shell-interpreter python
            elpy-rpc-python-command python)
      (message (concat "Toggled to " python))))
  (setq imenu-create-index-function 'python-imenu-create-index))

(use-package elpy
  :ensure t
  :defer t)

(use-package paredit
  :ensure t
  :hook ((clojure-mode emacs-lisp-mode) . enable-paredit-mode)
  :bind (:map paredit-mode-map
         ("C-c <right>" . paredit-forward-slurp-sexp)
         ("C-c <left>"  . paredit-forward-barf-sexp))
  :config
  (defun evil-paredit-kill (&optional ARGUMENT)
    (interactive)
    (if (and (equal (point) (- (line-end-position) 1))
             (equal evil-state 'normal))
        (progn
          (evil-append 1)
          (paredit-kill ARGUMENT)
          (evil-normal-state nil)
          (evil-forward-char))
      (paredit-kill ARGUMENT)))
  (evil-define-key 'normal paredit-mode-map " k" 'evil-paredit-kill)
  (evil-define-key 'insert paredit-mode-map (kbd "C-k") 'paredit-kill)
  (evil-leader/set-key-for-mode 'emacs-lisp-mode
    "eb" 'eval-buffer
    "ee" 'eval-last-sexp
    "er" 'eval-region)
  (evil-leader/set-key-for-mode 'lisp-interaction-mode
    "eb" 'eval-buffer
    "ee" 'eval-last-sexp
    "er" 'eval-region))

(use-package clojure-mode
  :ensure t
  :mode ("\\.clj\\'" . clojure-mode)
  :config
  (evil-define-key 'normal clojure-mode-map
    "gd" 'cider-find-dwim
    "gp" 'cider-pop-back)
  (evil-leader/set-key-for-mode 'clojure-mode
    "eb" 'cider-eval-buffer
    "ee" 'cider-eval-last-sexp
    "er" 'cider-eval-region
    "ex" 'cider-eval-last-sexp-and-replace))

(use-package cider
  :ensure t
  :commands cider-jack-in
  :config
  (evil-set-initial-state 'cider-repl-mode       'emacs)
  (evil-set-initial-state 'cider-stacktrace-mode 'emacs)
  (setq cider-inject-dependencies-at-jack-in nil)
  (unbind-key "M-," cider-mode-map)
  (unbind-key "M-," cider-repl-mode-map)
  (bind-key "M-[" 'cider-pop-back cider-mode-map)
  (bind-key "M-[" 'cider-pop-back cider-repl-mode-map))

(use-package clj-refactor
  :disabled t
  :ensure t
  :mode ("\\.clj\\'" . clojure-mode))

(use-package slime
  :ensure t
  :commands slime
  :init
  (setq inferior-lisp-program "clisp"
        slime-contribs '(slime-fancy))
  :config
  (setq slime-completion-at-point-functions 'slime-fuzzy-complete-symbol))

(use-package geiser
  :ensure t
  :commands geiser run-geiser
  :init
  (setq geiser-active-implementations '(chicken guile))
  (remove-hook 'scheme-mode-hook 'geiser-mode--maybe-activate)
  :config
  (geiser-mode--maybe-activate)
  (unbind-key "M-," geiser-mode-map))

(use-package web-mode
  :ensure t
  :mode (("\\.html\\'" . web-mode)
         ("\\.ejs\\'" . web-mode)
         ("\\.vue\\'" . web-mode))
  :bind (:map web-mode-map
         ("TAB" . company-indent-or-complete-common))
  :config
  (setq web-mode-style-padding 0
        web-mode-script-padding 0
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-markup-indent-offset 2
        web-mode-enable-current-element-highlight t)
  (defun my-web-mode-hook ()
    (setq-local
     company-backends
     '(company-tern company-web-html company-yasnippet company-files)))
  (add-hook 'web-mode-hook 'my-web-mode-hook))

(use-package js2-mode
  :ensure t
  :mode (("\\.js\\'" . js2-mode)
         ("\\.jsx\\'" . js2-jsx-mode))
  :bind (:map js2-mode-map
         ("TAB" . company-indent-or-complete-common))
  :config
  (setq js2-basic-offset 2
        js2-strict-missing-semi-warning nil)
  (add-to-list 'company-backends 'company-tern)
  (add-hook 'js2-mode-hook (lambda () (js2-imenu-extras-mode))))

(use-package js2-refactor
  :disabled t
  :ensure t
  :defer t
  :config
  (js2r-add-keybindings-with-prefix "C-c C-n"))

(use-package rjsx-mode
  :ensure t
  :defer t
  :init
  (add-to-list 'auto-mode-alist '("components\\/.*\\.js\\'" . rjsx-mode)))

(use-package emmet-mode
  :ensure t
  :hook (web-mode js2-mode css-mode))

(use-package tern
  :ensure t
  :hook ((web-mode js2-mode css-mode) . my-tern-hook)
  :config
  (evil-define-key 'normal tern-mode-keymap
    "gd" 'tern-find-definition
    "gp" 'tern-pop-find-definition
    "gr" 'xref-find-reference-here
    "g[" 'xref-pop-marker-stack)
  (bind-key "M-," 'other-window tern-mode-keymap)
  (defun my-tern-hook ()
    (evil-normalize-keymaps)
    (tern-mode)
    (yas-minor-mode)))

(use-package go-mode
  :ensure t
  :mode ("\\.go\\'" . go-mode)
  :bind (:map go-mode-map
         ("M-." . godef-jump)
         ("TAB" . company-indent-or-complete-common))
  :config
  (evil-define-key 'normal go-mode-map
    "gd" 'godef-jump
    "gp" 'xref-pop-marker-stack
    "gr" 'xref-find-reference-here
    "g[" 'xref-pop-marker-stack)
  (setq gofmt-command "goimports")
  (defun my-go-code-hook ()
    (evil-normalize-keymaps)
    (make-local-variable 'before-save-hook)
    (add-hook 'before-save-hook 'gofmt-before-save)
    (setq-local compile-command
                "go build -v && go test -v && go vet"))
  (add-hook 'go-mode-hook 'my-go-code-hook))

(use-package octave
  :mode ("\\.m\\'" . octave-mode))

(use-package format-all
  :ensure t
  :defer t)


(provide 'conf-dev)
