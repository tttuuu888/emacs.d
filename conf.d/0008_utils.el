;; The other functions Setting

;;;; Korean letter setting
(when (and enable-multibyte-characters win32p)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (prefer-coding-system 'utf-8)
  (set-file-name-coding-system 'euc-kr))

;;;; Turn-off scratch buffer save
(add-hook 'emacs-startup-hook
          (lambda ()
            (when (get-buffer "*scratch*")
              (with-current-buffer "*scratch*"
                (auto-save-mode -1)
                (setq buffer-offer-save nil)))))


;; Use "y or n" answers instead of full words "yes or no"
(fset 'yes-or-no-p 'y-or-n-p)

;; insert date into buffer at point
;; optained from http://www.chrislott.org/geek/emacs/dotemacs.html
(defun insert-date ()
  "Insert date at point."
  (interactive)
  (insert (format-time-string "%Y-%m-%d %a %p %l:%M")))

;; ;; Kills all them buffers except scratch
;; ;; optained from http://www.chrislott.org/geek/emacs/dotemacs.html
(defun nuke-all-buffers ()
  "kill all buffers, leaving *scratch* only"
  (interactive)
  (mapcar (lambda (x) (kill-buffer x))
	  (buffer-list))
  (delete-other-windows))


;; REDO+
(require 'redo+)

;; Hide ^M 
(defun hide-ctrl-M ()
  "Hides the disturbing '^M' showing up in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))


;; hangul 3bulsik
(setq default-korean-keyboard "3")

;; Korean font
(set-fontset-font "fontset-default" '(#x1100 . #xffdc)
                  "NanumGothicOTF-15")

;; In terminal mode, change minibuffer prompt color to green
(when (not window-system)
           (set-face-foreground 'minibuffer-prompt "green"))
