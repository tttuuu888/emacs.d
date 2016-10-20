;; Developement settings

(use-package sk-dev-utils
    :defer t
    :commands (izero-insert
               idef-insert
               sk-create-ch-file
               sk-create-c-file
               sk-create-h-file
               sk-clang-complete-make)
    :bind   (("<f9>"    . sk-make)
             ("C-<f9>"  . sk-rebuild))
    :init
    (add-hook 'c-mode-common-hook
              (lambda () (local-set-key (kbd "M-*") 'pop-tag-mark)))
    ;; Makefile.example -> Makefile
    (add-to-list 'auto-mode-alist '("Makefile\\..*" . makefile-gmake-mode)))

(use-package gdb
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
    (add-hook 'c-mode-common-hook (lambda () (ggtags-mode 1)))
    (add-hook 'asm-mode-hook (lambda () (ggtags-mode 1))))

(use-package rtags
    :disabled t
    :ensure t
    :defer t
    :commands my-rtags-index
    :init
    (add-hook 'c-mode-common-hook (lambda () (rtags-start-process-unless-running)))
    :config
    (require 'sk-dev-utils)
    (require 'helm-utils)
    (require 'rtags-helm)
    (setq rtags-autostart-diagnostics t
          rtags-use-helm t)
    (rtags-enable-standard-keybindings)
    (rtags-start-process-unless-running)
    (add-hook 'kill-emacs-hook (lambda () (rtags-quit-rdm)))
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
    (add-hook 'c-mode-common-hook (lambda () (cscope-minor-mode 1)))
    (add-hook 'asm-mode-hook (lambda () (cscope-minor-mode 1)))
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
    (add-hook 'c-mode-common-hook 'my-which-function-setup)
    (add-hook 'python-mode-hook 'my-which-function-setup))

(use-package python
    :defer t
    :mode ("\\.py\\'" . python-mode)
    :interpreter ("python" . python-mode)
    :config
    (if window-system
        (setq python-shell-interpreter-args "-i --matplotlib=qt"))
    (setq python-shell-interpreter "ipython"
          imenu-create-index-function 'python-imenu-create-index)
    (bind-keys :map python-mode-map
               ("M-." . jedi:goto-definition)
               ("M-*" . jedi:goto-definition-pop-marker)
               ("TAB" . company-indent-or-complete-common)
               ("C->" . python-indent-shift-right)
               ("C-<" . python-indent-shift-left)))

(use-package paredit
    :ensure t
    :defer t
    :commands enable-paredit-mode
    :init
    (add-hook 'clojure-mode-hook 'enable-paredit-mode)
    (add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode))

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
    (setq lisp-indent-function 'common-lisp-indent-function
          slime-enable-evaluate-in-emacs t
          slime-log-events t
          slime-outline-mode-in-events-buffer nil
          slime-highlight-compiler-notes t
          slime-contribs '(slime-fancy))
    (if linuxp
        (setq inferior-lisp-program "/usr/bin/clisp")
        (setq inferior-lisp-program "~/util/clisp-2.49/clisp"))
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
    (setq web-mode-markup-indent-offset 2
          web-mode-enable-current-element-highlight t)
    (bind-keys :map web-mode-map
               ("TAB" . company-indent-or-complete-common)))

(use-package js
    :defer t
    :mode ("\\.js\\'" . js-mode)
    :init
    (add-hook 'js-mode-hook (lambda ()
                              (tern-mode t)
                              (electric-pair-mode t)))
    :config
    (bind-keys :map js-mode-map
               ("TAB" . company-indent-or-complete-common)))

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
    (add-hook 'go-mode-hook (lambda ()
                              (make-local-variable 'before-save-hook)
                              (add-hook 'before-save-hook 'gofmt-before-save)))

    (bind-keys :map go-mode-map
               ("M-." . godef-jump)
               ("TAB" . company-indent-or-complete-common)))

(use-package octave
    :defer t
    :mode ("\\.m\\'" . octave-mode))

(provide 'conf-dev)
