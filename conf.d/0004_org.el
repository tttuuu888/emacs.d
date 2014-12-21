;; ORG mode Setting

(autoload 'org-mode "org")
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

(defun my-org-mode-hook ()
  (define-key org-mode-map "\C-cl" 'org-store-link)
  (define-key org-mode-map "\C-ca" 'org-agenda)
  (define-key org-mode-map "\C-cb" 'org-iswitchb)
  (define-key org-mode-map "\C-cr" 'org-remember))
(add-hook 'org-mode-hook 'my-org-mode-hook)

(setq org-log-done t)
