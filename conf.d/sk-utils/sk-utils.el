;;; My various utils

(defun sharp-ifdef-insert (start end pre)
  (save-excursion
    (let ((end2 (if (and (equal evil-state 'visual)
                         (equal end (line-beginning-position)))
                    (- end 1)
                  end)))
      (goto-char end2) (end-of-line) (insert "\n#endif")
      (goto-char start) (beginning-of-line) (insert pre "\n"))))

;; #if 0 ~ #endif insert for the area
(defun izero-insert (start end)
  "Intesrt #if 0 at the beginning of region and #endif at the end of region"
  (interactive "r")
  (sharp-ifdef-insert start end "#if 0"))

;; #ifdef ~ #endif insert for the area
(defun idef-insert (start end in)
  "Intesrt #if 0 at the beginning of region and #endif at the end of region"
  (interactive "r\nsDefine : ")
  (sharp-ifdef-insert start end (concat "#ifdef " in)))


;; build functions
(defun find-file-in-tree (dir fname &optional project-root)
  (let ((file (concat dir fname))
        (parent (unless (or (equal "~" dir) (equal "/" dir))
                  (file-name-directory (directory-file-name dir)))))
    (cond ((and project-root
                (file-exists-p (concat project-root fname)))
           project-root)
          ((file-exists-p file) dir)
          ((when parent) (find-file-in-tree parent fname))
          (t nil))))

(defun sk-make ()
  "Find a Makefile path and perform Make"
  (interactive)
  (let ((dir (find-file-in-tree default-directory
                                "Makefile"
                                (my-project-root-or-dir))))
    (if (equal dir nil)
        (message "Makefile is not found")
      (compile (concat "export LANG=en_US && make -j8 -C " dir)))))

(defun sk-clean ()
  "Find a Makefile path and perform Clean"
  (interactive)
  (let ((dir (find-file-in-tree default-directory
                                "Makefile"
                                (my-project-root-or-dir))))
    (if (equal dir nil)
        (message "Makefile is not found")
      (compile (concat "export LANG=en_US && make -C " dir " clean")))))

(defun sk-rebuild ()
  "Find a Makefile path and perform rebuild(clean and make)"
  (interactive)
  (let ((dir (find-file-in-tree default-directory
                                "Makefile"
                                (my-project-root-or-dir))))
    (if (equal dir nil)
        (message "Makefile is not found")
      (progn
        (call-process "make" nil nil nil "-C" dir "clean")
        (compile (concat "export LANG=en_US && make -j8 -C " dir))))))

(defun sk-clang-complete-make ()
  (interactive)
  (let ((file "./.clang_complete")
        (includes
         (mapcar (lambda (x) (concat "-I" x "\n"))
                 (split-string
                  (shell-command-to-string
                   "find -type f -name '*.h' -printf '%h\n' | sort -u")))))
    (progn
      (when (file-exists-p file)
        (delete-file file))
      (write-region "" nil file)
      (mapc (lambda (x) (append-to-file x nil file)) includes))))


(defun insert-date ()
  "Insert date at point."
  (interactive)
  (insert (format-time-string "%Y-%m-%d %a")))

(defun insert-date-and-time ()
  "Insert date at point."
  (interactive)
  (insert (format-time-string "%Y-%m-%d %a %p %l:%M")))

(defun nuke-all-buffers ()
  "kill all buffers, leaving *scratch* only"
  (interactive)
  (mapc (lambda (x) (kill-buffer x))
        (buffer-list))
  (delete-other-windows))

;; Hide ^M
(defun hide-ctrl-M ()
  "Hides the disturbing '^M' showing up in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))

(defun move-line (n)
  "Move the current line up or down by N lines."
  (interactive "p")
  (let* ((col (current-column))
         (tmp1 (beginning-of-line))
         (start (point))
         (tmp2 (end-of-line))
         (tmp3 (forward-char))
         (end (point))
         (line-text (delete-and-extract-region start end)))
    (forward-line n)
    (insert line-text)
    ;; restore point to original column in moved line
    (forward-line -1)
    (forward-char col)))

(defun transpose-windows ()
  (interactive)
  (let ((this-buffer (window-buffer (selected-window)))
        (other-buffer (prog2
                          (other-window +1)
                          (window-buffer (selected-window))
                        (other-window -1))))
    (switch-to-buffer other-buffer)
    (switch-to-buffer-other-window this-buffer)
    (other-window -1)))

(defun buffer-save-or-load (num &optional restore)
  (if restore
      (progn
        (jump-to-register num)
        (message (concat "Windows are Restored by F" (number-to-string num))))
    (progn
      (window-configuration-to-register num)
      (message (concat "Windows are saved to F" (number-to-string num))))))

(defun sk-byte-recompile-conf-dir ()
  (interactive)
  (byte-recompile-directory "~/.emacs.d/conf.d" 0))

(defun tmux-running-p ()
  (zerop (process-file "tmux" nil nil nil "has-session")))

(defun tmux-new-pane-here ()
  (interactive)
  (if (tmux-running-p)
      (call-process "tmux" nil nil nil "new-window")
    (message "Tmux is not running!")))

(defun get-current-or-next-week-form (&optional next-week)
  (let* ((_ (require 'org))
         (base (if next-week "++8" "++1"))
         (monday (org-read-date nil t base nil (org-read-date nil t "-sun")))
         (friday (time-add monday (* 4 24 3600)))
         (month-of-monday (format-time-string "%m" monday))
         (month-of-friday (format-time-string "%m" friday))
         (month-of-next-friday (if (equal month-of-monday month-of-friday)
                                   ""
                                 (format "%s월 " month-of-friday)))
         (start (format-time-string "%W주차  %m월 %d일 ~ " monday))
         (end (format "%s%s"
                      month-of-next-friday
                      (format-time-string "%d일" friday))))
    (format "%s%s" start end)))

(defun sk-insert-current-week-form ()
  (interactive)
  (insert (get-current-or-next-week-form)))

(defun sk-insert-next-week-form ()
  (interactive)
  (insert (get-current-or-next-week-form t)))


(provide 'sk-utils)
