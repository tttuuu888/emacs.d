;; Helm Setting

;; anything-git-grep replaces helm-git-grep in Windows (helm-git-grep often stops in Windows)
(when win32p (require 'anything-git-grep))

(define-key global-map (kbd "C-c i") 'helm-imenu)
(define-key global-map (kbd "C-c f") 'helm-git-files)
(if unixp
     (define-key global-map (kbd "C-c g") 'helm-git-grep-at-point)
     (define-key global-map (kbd "C-c g") 'anything-git-grep-from-here))
