;;; Developement settings

(use-package gdb-mi
  :defer t
  :init
  (advice-add 'gdb-setup-windows :after
              (lambda (&rest args)
                (set-window-dedicated-p (selected-window) t)))
  :config
  (gdb-many-windows t))

(use-package make-mode
  :defer t
  :mode ("Makefile.*" . makefile-gmake-mode))

(use-package elec-pair
  :defer t
  :hook (prog-mode . electric-pair-mode))

(use-package cff
  :ensure t
  :defer t
  :init
  (add-hook 'c-mode-common-hook
            (lambda () (local-set-key (kbd "M-o") 'cff-find-other-file))))

(use-package ggtags
  :ensure t
  :hook ((c-mode-common asm-mode) . my-ggtags-hook)
  :config
  (defun my-ggtags-hook ()
    (ggtags-mode)
    (evil-local-set-key 'normal ",gd" 'ggtags-find-tag-dwim)
    (evil-local-set-key 'normal ",gr" 'ggtags-find-reference)
    (evil-local-set-key 'normal ",gu" 'ggtags-update-tags)))

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
                                  (projectile-project-root))))
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
  :defer t
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python" . python-mode)
  :commands sk-toggle-python
  :config
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
  (setq imenu-create-index-function 'python-imenu-create-index)
  (bind-keys :map python-mode-map
             ("M-," . xref-pop-marker-stack)
             ("M-]" . xref-find-reference-here)
             ("M-[" . xref-pop-marker-stack)
             ("TAB" . company-indent-or-complete-common)))

(use-package elpy
  :ensure t
  :defer t)

(use-package paredit
  :ensure t
  :hook ((clojure-mode emacs-lisp-mode) . enable-paredit-mode)
  :config
  (bind-keys :map paredit-mode-map
             ("C-c <right>" . paredit-forward-slurp-sexp)
             ("C-c <left>"  . paredit-forward-barf-sexp)))

(use-package clojure-mode
  :ensure t
  :mode ("\\.clj\\'" . clojure-mode))

(use-package cider
  :ensure t
  :commands cider-jack-in
  :config
  (setq cider-inject-dependencies-at-jack-in nil))

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
  (setq geiser-active-implementations '(chicken guile)))

(use-package web-mode
  :ensure t
  :mode (("\\.html\\'" . web-mode)
         ("\\.ejs\\'" . web-mode)
         ("\\.vue\\'" . web-mode))
  :config
  (bind-key "TAB" 'company-indent-or-complete-common web-mode-map)
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
  :config
  (setq js2-basic-offset 2
        js2-strict-missing-semi-warning nil)
  (add-to-list 'company-backends 'company-tern)
  (bind-key "TAB" 'company-indent-or-complete-common js2-mode-map)
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
  (defun my-tern-hook ()
    (tern-mode)
    (yas-minor-mode)
    (evil-local-set-key 'normal ",gd" 'tern-find-definition)
    (evil-local-set-key 'normal (kbd "M-[") 'xref-pop-marker-stack))
  (bind-keys :map tern-mode-keymap
             ("M-]" . xref-find-reference-here)
             ("M-[" . xref-pop-marker-stack)))

(use-package go-mode
  :ensure t
  :mode ("\\.go\\'" . go-mode)
  :config
  (setq gofmt-command "goimports")
  (defun my-go-code-hook ()
    (make-local-variable 'before-save-hook)
    (add-hook 'before-save-hook 'gofmt-before-save)
    (setq-local compile-command
                "go build -v && go test -v && go vet"))
  (add-hook 'go-mode-hook 'my-go-code-hook)
  (bind-keys :map go-mode-map
             ("M-." . godef-jump)
             ("TAB" . company-indent-or-complete-common)))

(use-package octave
  :mode ("\\.m\\'" . octave-mode))

(use-package format-all
  :ensure t
  :defer t)

(provide 'conf-dev)
