;; Developement settings

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

(use-package semantic
    :ensure t
    :defer t
    :init
    (add-hook 'c-mode-common-hook
              (lambda ()
                (semantic-mode 1)
                (global-semantic-stickyfunc-mode 1)))
    (add-hook 'asm-mode-hook (lambda () (semantic-mode 1)))
    :config
    (use-package stickyfunc-enhance
        :ensure t)
    (define-key c-mode-map [remap c-indent-line-or-region]
      'company-indent-or-complete-common)
    (define-key c++-mode-map [remap c-indent-line-or-region]
      'company-indent-or-complete-common))

(use-package sk-c-mode
    :defer t
    :init
    (add-hook 'c-mode-common-hook
              (lambda ()
                (local-set-key [(f9)] 'sk-rebuild)))
    (add-hook 'eshell-mode-hook
              (lambda () (local-set-key [(f9)] 'sk-rebuild))))


;; Makefile.example -> Makefile
(add-to-list 'auto-mode-alist '("Makefile\\..*" . makefile-gmake-mode))


(use-package python
    :ensure t
    :defer t
    :mode ("\\.py\\'" . python-mode)
    :interpreter ("python" . python-mode)
    :config
    (setq py-shell-name "python"
          py-split-windows-on-execute-function (quote split-window-horizontally)
          py-install-directory
          (concat "~/.emacs.d/elpa/" (car (directory-files "~/.emacs.d/elpa/" nil "python-mode*"))))
    (use-package python-mode
        :ensure t)
    (bind-keys :map python-mode-map
               ("M-." . jedi:goto-definition)
               ("M-*" . jedi:goto-definition-pop-marker))
    (add-to-list 'company-backends 'company-jedi))

(use-package paredit
    :ensure t
    :defer t
    :commands enable-paredit-mode
    :init
    (add-hook 'clojure-mode-hook 'enable-paredit-mode))

(use-package clojure-mode
    :ensure t
    :defer t
    :mode ("\\.clj\\'" . clojure-mode)
    :config
    (use-package cider
        :ensure t)
    (enable-paredit-mode))

(use-package cider
    :ensure t
    :defer t
    :interpreter ("clojure" . cider-repl-mode))

(use-package slime
    :ensure t
    :defer t
    :commands slime
    :init
    (setq lisp-indent-function 'common-lisp-indent-function
          slime-complete-symbol-function 'slime-fuzzy-complete-symbol
          slime-startup-animation nil
          slime-enable-evaluate-in-emacs t
          slime-log-events t
          slime-outline-mode-in-events-buffer nil
          slime-repl-return-behaviour :send-only-if-after-complete
          slime-autodoc-use-multiline-p t
          slime-highlight-compiler-notes t
          slime-contribs '(slime-fancy))
    ;;(set-language-environment "UTF-8")
    ;;(setq slime-net-coding-system 'utf-8-unix)
    (add-hook 'slime-mode-hook
              (lambda ()
                (define-key slime-mode-map (kbd "TAB") 'slime-indent-and-complete-symbol)
                (define-key slime-mode-map (kbd "\r") 'newline-and-indent))))

(use-package chicken-scheme
    :ensure t
    :defer t
    :commands setup-chicken-scheme
    :init
    (add-hook 'scheme-mode-hook 'setup-chicken-scheme)
    (add-hook 'scheme-mode-hook 'enable-paredit-mode))

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

(use-package eassist
    :defer t
    :load-path "~/.emacs.d/conf.d/external"
    :commands (eassist-switch-h-cpp eassist-list-methods)
    :init
    (defun my-c-mode-common-hook ()
      (define-key c-mode-base-map (kbd "M-o") 'eassist-switch-h-cpp)
      (define-key c-mode-base-map (kbd "M-m") 'eassist-list-methods))
    (add-hook 'c-mode-common-hook 'my-c-mode-common-hook))

(use-package sk-functions)



(provide 'conf-dev)
