;; Helm Setting

;; anything-git-grep replaces helm-git-grep in Windows (helm-git-grep often stops in Windows)
(when win32p (require 'anything-git-grep))

(define-key global-map (kbd "C-c i") 'helm-imenu)
(define-key global-map (kbd "C-c o") 'helm-git-files) ;Open file
(if unixp
     (define-key global-map (kbd "C-c p") 'helm-git-grep-at-point) ;greP
     (define-key global-map (kbd "C-c p") 'anything-git-grep-from-here))
