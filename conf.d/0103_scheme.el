;; Scheme mode Setting

(require 'chicken-scheme)

(add-hook 'scheme-mode-hook 'setup-chicken-scheme)
(add-hook 'scheme-mode-hook 'enable-paredit-mode)
