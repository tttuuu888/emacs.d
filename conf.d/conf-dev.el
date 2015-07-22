;; Developement settings

(use-package ggtags
    :ensure t
    :defer t
    :init
    (add-hook 'c-mode-common-hook (lambda () (ggtags-mode 1)))
    (add-hook 'asm-hook (lambda () (ggtags-mode 1))))

(use-package xcscope
    :ensure t
    :defer t
    :init
    (add-hook 'c-mode-common-hook (lambda () (cscope-minor-mode 1)))
    (add-hook 'asm-hook (lambda () (cscope-minor-mode 1))))

(use-package semantic
    :ensure t
    :defer t
    :init
    (add-hook 'c-mode-common-hook (lambda () (semantic-mode 1)))
    (add-hook 'asm-hook (lambda () (semantic-mode 1)))
    :config
    (global-semantic-stickyfunc-mode 1)
    (use-package stickyfunc-enhance
        :ensure t))

(use-package sk-c-mode
    :init 
    (add-hook 'c-mode-common-hook
              (lambda () (local-set-key (kbd "M-o") 'ff-find-other-file))))

;; Makefile.example -> Makefile
(add-to-list 'auto-mode-alist '("Makefile\\..*" . makefile-gmake-mode))


(use-package python
    :ensure t
    :defer t
    :commands jedi:setup
    :init
    (add-hook 'python-mode-hook 'jedi:setup)
    :mode ("\\.py\\'" . python-mode)
    :interpreter ("python" . python-mode)
    :config
    (setq py-shell-name "python")
    (setq py-split-windows-on-execute-function (quote split-window-horizontally))
    (setq py-install-directory
          (concat "~/.emacs.d/elpa/" (car (directory-files "~/.emacs.d/elpa/" nil "python-mode*"))))
    (setq jedi:complete-on-dot t)
    (use-package python-mode
        :ensure t))


(use-package clojure-mode
    :ensure t
    :defer t
    :mode ("\\.clj\\'" . clojure-mode)
    :init
    (add-hook 'cider-repl-mode-hook (lambda ()
                                      (auto-complete-mode 1)
                                      (ac-cider-setup)))
    :config
    (use-package cider
        :ensure t))

(use-package cider
    :ensure t
    :defer t
    :interpreter ("clojure" . cider-repl-mode)
    :config
    (add-hook 'cider-repl-mode-hook (lambda ()
                                      (auto-complete-mode 1)
                                      (ac-cider-setup))))



(provide 'conf-dev)
