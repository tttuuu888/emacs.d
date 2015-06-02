;; Key binding Setting

;; HS mode(Folding source)
(define-key global-map [(f7)] 'hs-minor-mode)
(define-key global-map [(f6)] 'hs-show-block)
(define-key global-map [(f5)] 'hs-hide-block)

;; Short cut key configure
(global-set-key [(control z)] nil)
;(global-set-key [(control \,)] 'complete-tag)
;(global-set-key [(meta \,)] 'menu-bar-next-tag)

;; Avy
(define-key global-map (kbd "C-c C-SPC") 'avy-goto-subword-1)

;; Expand-Region
(global-set-key (kbd "C-=") 'er/expand-region)


;; ----------------------------------------------------------------------------  
;; Easier Transition between Windows  
;; ----------------------------------------------------------------------------  
;  M-up, M-down, M-left, and M-right keys.  
(windmove-default-keybindings 'meta)

;; Spawning Window
(fset 'spawn-window-right
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([24 49 24 51 M-left] 0 "%d")) arg)))
(fset 'spawn-window-left
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([24 49 24 51 M-right] 0 "%d")) arg)))
(fset 'spawn-window-down
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([24 49 24 50 M-down] 0 "%d")) arg)))
(fset 'spawn-window-up
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([24 49 24 50 M-up] 0 "%d")) arg)))
;(define-key global-map [(control right)]  'spawn-window-left)
;(define-key global-map [(control left)]  'spawn-window-right)
;(define-key global-map [(control down)]  'spawn-window-down)
;(define-key global-map [(control up)]  'spawn-window-up)
(define-key global-map [(super q)] 'kill-this-buffer)
;(define-key global-map [(meta q)] 'kill-buffer-and-window)
(define-key global-map [(control tab)] 'switch-to-buffer)

;; Kill Window
(defun kill-window-left()
  "kill window at left."
  (interactive)
  (windmove-left)
  (delete-window))

(defun kill-window-right()
  "kill window at right."
  (interactive)
  (windmove-right)
  (delete-window))

(defun kill-window-up()
  "kill window at up."
  (interactive)
  (windmove-up)
  (delete-window))

(defun kill-window-down()
  "kill window at down."
  (interactive)
  (windmove-down)
  (delete-window))

(define-key global-map [(super left)] 'kill-window-left)
(define-key global-map [(super right)] 'kill-window-right)
(define-key global-map [(super up)] 'kill-window-up)
(define-key global-map [(super down)] 'kill-window-down)


;; Run recent-open-files on startup
(define-key global-map [(control x)(control r)]  'recentf-open-files)

;; REDO +
(global-set-key [(control .)] 'redo)

