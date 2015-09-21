;; Developement settings

(use-package sk-c-mode
    :defer t
    :commands izero-insert
    :init
    (defun sk-c-header-switch ()
      (interactive)
      (ff-find-other-file nil t))
    (add-hook 'c-mode-common-hook
              (lambda () (local-set-key (kbd "M-o") 'sk-c-header-switch))))

(use-package sk-dev-utils
    :commands (create-ch-file create-c-file create-h-file clang-complete-make)
    :bind   (("<f9>"    . sk-make)
             ("C-<f9>"  . sk-rebuild)))

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
    (add-hook 'c-mode-common-hook 'my-which-function-setup))

(use-package semantic
    :disabled t
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
        :ensure t))


;; Makefile.example -> Makefile
(add-to-list 'auto-mode-alist '("Makefile\\..*" . makefile-gmake-mode))


(use-package python
    :ensure t
    :defer t
    :mode ("\\.py\\'" . python-mode)
    :interpreter ("python" . python-mode)
    :init
    (defun my-company-python-setup ()
      (make-local-variable 'company-backends)
      (setq company-backends (remq 'company-capf company-backends)))
    (add-hook 'python-mode-hook 'my-company-python-setup)
    (add-hook 'inferior-python-mode 'my-company-python-setup)
    :config
    (setq py-shell-name "python"
          py-split-windows-on-execute-function (quote split-window-horizontally)
          py-install-directory
          (concat "~/.emacs.d/elpa/" (car (directory-files "~/.emacs.d/elpa/" nil "python-mode*"))))
    (use-package python-mode
        :ensure t)
    (bind-keys :map python-mode-map
               ("M-." . jedi:goto-definition)
               ("M-*" . jedi:goto-definition-pop-marker)
               ("TAB" . company-indent-or-complete-common))
    (add-to-list 'company-backends 'company-jedi))

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
