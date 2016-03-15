;; Developement settings

(use-package sk-c-mode
    :defer t
    :commands (izero-insert idef-insert))

(use-package sk-dev-utils
    :defer t
    :commands (sk-create-ch-file sk-create-c-file sk-create-h-file sk-clang-complete-make)
    :bind   (("<f9>"    . sk-make)
             ("C-<f9>"  . sk-rebuild)))

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

(use-package python-mode
    :disabled t
    :ensure t
    :defer t)

(use-package python
    :defer t
    :mode ("\\.py\\'" . python-mode)
    :interpreter ("python" . python-mode)
    :init
    (setq python-shell-interpreter "ipython")
    (if window-system
        (setq python-shell-interpreter-args "-i --matplotlib=qt"))
    (add-hook 'python-mode-hook
              (lambda ()
                (setq imenu-create-index-function 'python-imenu-create-index)))
    :config
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
    :mode ("\\.clj\\'" . clojure-mode)
    :config
    (enable-paredit-mode))

(use-package cider
    :ensure t
    :defer t
    :mode ("\\.clj\\'" . clojure-mode)
    :interpreter ("clojure" . cider-repl-mode))

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
          slime-startup-animation nil
          slime-enable-evaluate-in-emacs t
          slime-log-events t
          slime-outline-mode-in-events-buffer nil
          slime-repl-return-behaviour :send-only-if-after-complete
          slime-autodoc-use-multiline-p t
          slime-highlight-compiler-notes t
          slime-contribs '(slime-fancy))
    :config
    (setq slime-completion-at-point-functions 'slime-fuzzy-complete-symbol)
    ;;(set-language-environment "UTF-8")
    ;;(setq slime-net-coding-system 'utf-8-unix)
)

(use-package chicken-scheme
    :ensure t
    :defer t
    :commands setup-chicken-scheme
    :init
    (add-hook 'scheme-mode-hook 'setup-chicken-scheme)
    (add-hook 'scheme-mode-hook 'enable-paredit-mode)
    (setq scheme-program-name "csi"))

(use-package geiser
    :ensure t
    :defer t
    :commands geiser run-geiser)

(use-package web-mode
    :ensure t
    :defer t
    :mode ("\\.html\\'" . web-mode)
    :init
    (setq web-mode-markup-indent-offset 2))



(provide 'conf-dev)
