;;; Developement settings

(use-package gdb-mi
  :defer t
  :init
  (defadvice gdb-setup-windows (after sk-dedicated-window)
    (set-window-dedicated-p (selected-window) t))
  (ad-activate 'gdb-setup-windows))

(use-package electric-pair-mode
  :defer t
  :init
  (add-hook 'c-mode-common-hook
            (lambda () (electric-pair-mode t))))

(use-package cff
  :ensure t
  :defer t
  :init
  (add-hook 'c-mode-common-hook
            (lambda () (local-set-key (kbd "M-o") 'cff-find-other-file))))

(use-package ggtags
  :ensure t
  :defer t
  :init
  (add-many-hook '(c-mode-common-hook asm-mode-hook)
                 (lambda () (ggtags-mode 1))))

(use-package rtags
  :disabled t
  :ensure t
  :defer t
  :commands my-rtags-index
  :init
  (add-hook 'c-mode-common-hook 'rtags-start-process-unless-running)
  :config
  (require 'sk-dev-utils)
  (require 'helm-utils)
  (require 'helm-rtags)
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
  :defer t
  :init
  (add-many-hook '(c-mode-common-hook asm-mode-hook)
                 (lambda () (cscope-minor-mode 1)))
  :config
  (bind-keys :map cscope-minor-mode-keymap
             ("<mouse-3>" . nil)))

(use-package which-function-mode
  :defer t
  :init
  (defun my-which-function-setup ()
    (make-local-variable 'header-line-format)
    (which-function-mode)
    (setq header-line-format
          '((which-func-mode ("" which-func-format " "))))
    (setq which-func-unknown "N/A"))
  (add-many-hook '(c-mode-common-hook python-mode-hook js-mode-hook)
                 'my-which-function-setup))

(use-package python
  :defer t
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python" . python-mode)
  :commands sk-toggle-python
  :config
  (defun sk-toggle-python ()
    "Toggle between Python2 and Python3"
    (interactive)
    (if (equal python-shell-interpreter "python")
        (progn
          (setq python-shell-interpreter "python3")
          (message "Toggled to Python3"))
      (progn
        (setq python-shell-interpreter "python")
        (message "Toggled to Python2"))))
  (defun python-xref-find-reference ()
    (interactive)
    (xref-find-references (thing-at-point 'symbol)))
  (setq python-shell-interpreter "python"
        imenu-create-index-function 'python-imenu-create-index)
  (bind-keys :map python-mode-map
             ("M-." . jedi:goto-definition)
             ("M-," . jedi:goto-definition-pop-marker)
             ("M-]" . python-xref-find-reference)
             ("M-*" . xref-pop-marker-stack)
             ("TAB" . company-indent-or-complete-common)
             ("C->" . python-indent-shift-right)
             ("C-<" . python-indent-shift-left)))

(use-package paredit
  :ensure t
  :defer t
  :commands enable-paredit-mode
  :init
  (add-many-hook '(clojure-mode-hook emacs-lisp-mode-hook)
                 'enable-paredit-mode))

(use-package clojure-mode
  :ensure t
  :defer t
  :mode ("\\.clj\\'" . clojure-mode))

(use-package cider
  :ensure t
  :defer t
  :commands cider-jack-in
  :config
  (setq cider-inject-dependencies-at-jack-in nil))

(use-package clj-refactor
  :disabled t
  :ensure t
  :defer t
  :mode ("\\.clj\\'" . clojure-mode))

(use-package slime
  :ensure t
  :defer t
  :commands slime
  :init
  (setq inferior-lisp-program "clisp"
        slime-contribs '(slime-fancy))
  :config
  (setq slime-completion-at-point-functions 'slime-fuzzy-complete-symbol))

(use-package geiser
  :ensure t
  :defer t
  :commands geiser run-geiser
  :init
  (setq geiser-active-implementations '(chicken guile)))

(use-package web-mode
  :ensure t
  :defer t
  :mode (("\\.html\\'" . web-mode)
         ("\\.ejs\\'" . web-mode))
  :init
  (add-hook 'web-mode-hook (lambda ()
                             (tern-mode t)
                             (emmet-mode t)
                             (electric-pair-mode t)))
  :config
  (bind-keys :map web-mode-map
             ("TAB" . company-indent-or-complete-common))
  (setq web-mode-markup-indent-offset 2
        web-mode-enable-current-element-highlight t)
  (defun my-web-mode-hook ()
    "Hook for `web-mode'."
    (set (make-local-variable 'company-backends)
         '(company-tern company-web-html company-yasnippet company-files)))
  (add-hook 'web-mode-hook 'my-web-mode-hook))

(use-package js
  :disabled t
  :defer t
  :mode (("\\.js\\'" . js-mode)
         ("\\.jsx\\'" . js-jsx-mode))
  :init
  (add-hook 'js-mode-hook (lambda ()
                            (tern-mode t)
                            (electric-pair-mode t)))
  :config
  (bind-keys :map js-mode-map
             ("TAB" . company-indent-or-complete-common))
  (add-to-list 'company-backends 'company-tern))

(use-package js2-mode
  :ensure t
  :defer t
  :mode (("\\.js\\'" . js2-mode)
         ("\\.jsx\\'" . js2-jsx-mode))
  :config
  (add-to-list 'company-backends 'company-tern)
  (bind-keys :map js2-mode-map
             ("TAB" . company-indent-or-complete-common))
  (add-hook 'js2-mode-hook (lambda ()
                             (tern-mode t)
                             (electric-pair-mode t)
                             (js2-imenu-extras-mode))))

(use-package js2-refactor
  :disabled t
  :ensure t
  :defer t
  :config
  (js2r-add-keybindings-with-prefix "C-c C-n"))


(use-package emmet-mode
  :ensure t
  :defer t
  :init
  (add-hook 'css-mode-hook (lambda () (emmet-mode t))))

(use-package tern
  :ensure t
  :defer t)

(use-package go-mode
  :ensure t
  :defer t
  :config
  (setq gofmt-command "goimports")
  (defun my-go-code-hook ()
    (make-local-variable 'before-save-hook)
    (add-hook 'before-save-hook 'gofmt-before-save)
    (set (make-local-variable 'compile-command)
         "go build -v && go test -v && go vet"))
  (add-hook 'go-mode-hook 'my-go-code-hook)
  (bind-keys :map go-mode-map
             ("M-." . godef-jump)
             ("TAB" . company-indent-or-complete-common)))

(use-package octave
  :defer t
  :mode ("\\.m\\'" . octave-mode))

(provide 'conf-dev)
