;; Developement settings

(use-package sk-c-mode
    :defer t
    :commands (izero-insert idef-insert))

(use-package sk-dev-utils
    :defer t
    :commands (sk-create-ch-file
               sk-create-c-file
               sk-create-h-file
               sk-clang-complete-make)
    :bind   (("<f9>"    . sk-make)
             ("C-<f9>"  . sk-rebuild)))

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

(use-package xcscope
    :ensure t
    :defer t
    :init
    (add-hook 'c-mode-common-hook (lambda () (cscope-minor-mode 1)))
    (add-hook 'asm-mode-hook (lambda () (cscope-minor-mode 1))))

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

;; Makefile.example -> Makefile
(add-to-list 'auto-mode-alist '("Makefile\\..*" . makefile-gmake-mode))

(use-package python
    :defer t
    :mode ("\\.py\\'" . python-mode)
    :interpreter ("python" . python-mode)
    :init
    (add-hook 'python-mode-hook
              (lambda ()
                (setq imenu-create-index-function 'python-imenu-create-index)))
    :config
    (if window-system
        (setq python-shell-interpreter-args "-i --matplotlib=qt"))
    (setq python-shell-interpreter "ipython")
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
                               (electric-pair-mode t)))
    :config
    (setq web-mode-markup-indent-offset 2)
    (bind-keys :map web-mode-map
               ("TAB" . company-indent-or-complete-common)))

(use-package js-mode
    :defer t
    :mode "\\.js\\'"
    :init
    (add-hook 'js-mode-hook
              (lambda ()
                (tern-mode t)
                (electric-pair-mode t)
                (local-set-key (kbd "TAB") 'company-indent-or-complete-common))))

(use-package tern
    :ensure t
    :defer t)

(use-package go-mode
    :ensure t
    :defer t
    :config
    (add-hook 'go-mode-hook
              (lambda ()
                (make-local-variable 'before-save-hook)
                (add-hook 'before-save-hook 'gofmt-before-save)))

    (bind-keys :map go-mode-map
               ("M-." . godef-jump)
               ("TAB" . company-indent-or-complete-common)))


(provide 'conf-dev)
