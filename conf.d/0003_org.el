;; ORG mode Setting

(use-package org
    :mode ("\\.org\\'" . org-mode)
    :config
    (bind-keys :map org-mode-map
               ("C-c l" . org-store-link)
               ("C-c a" . org-agenda)    
               ("C-c b" . org-iswitchb)  
               ("C-c r" . org-remember))
    (setq org-log-done t))
