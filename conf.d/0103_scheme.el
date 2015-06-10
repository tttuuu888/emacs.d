;; Scheme mode Setting

(use-package chicken-scheme
    :commands setup-chicken-scheme
    :init
    (add-hook 'scheme-mode-hook 'setup-chicken-scheme)
    (add-hook 'scheme-mode-hook 'enable-paredit-mode))
