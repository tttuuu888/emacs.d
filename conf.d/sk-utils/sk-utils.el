;;; My various utils

(defun sharp-ifdef-insert (start end pre)
  (save-excursion
    (goto-char end) (end-of-line) (insert "\n#endif")
    (goto-char start) (beginning-of-line) (insert pre "\n")))

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
(defun parent-directory (dir)
  (unless (equal "/" dir)
    (file-name-directory (directory-file-name dir))))

(defun find-file-in-tree (dir fname &optional project-root)
  (let ((file (concat dir fname))
        (parent (parent-directory dir)))
    (cond ((and project-root (file-exists-p (concat project-root fname))) project-root)
          ((file-exists-p file) dir)
          ((when parent) (find-file-in-tree parent fname))
          (t nil))))

(defun sk-make ()
  "Find a Makefile path and perform Make"
  (interactive)
  (let ((dir (find-file-in-tree (file-name-directory default-directory)
                                "Makefile"
                                (projectile-project-root))))
    (if (equal dir nil)
        (message "Makefile is not found")
        (compile (concat "export LANG=en_US && make -j8 -C " dir)))))

(defun sk-clean ()
  "Find a Makefile path and perform Clean"
  (interactive)
  (let ((dir (find-file-in-tree (file-name-directory default-directory)
                                "Makefile"
                                (projectile-project-root))))
    (if (equal dir nil)
      (message "Makefile is not found")
      (compile (concat "export LANG=en_US && make -C " dir " clean")))))

(defun sk-rebuild ()
  "Find a Makefile path and perform rebuild(clean and make)"
  (interactive)
  (let ((dir (find-file-in-tree (file-name-directory default-directory)
                                "Makefile"
                                (projectile-project-root))))
    (if (equal dir nil)
        (message "Makefile is not found")
        (progn
         (call-process "make" nil nil nil "-C" dir "clean")
         (compile (concat "export LANG=en_US && make -j8 -C " dir))))))


;; making .c .h files
(defun make-author-info (file-name)
  (concat "/**\n * " file-name "
 * Created by SeungKi Kim\n * " (format-time-string "%Y-%m-%d") "
 */\n"))

(defun c-file-shape (file-name)
  (concat (make-author-info (concat file-name ".c"))
"\n/* Includes ------------------------------------------------------------------*/
/* Private defines -----------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private functions ---------------------------------------------------------*/\n\n\n
/* Exported functions --------------------------------------------------------*/
\n\n\n\n\n
/******************************** END OF FILE *********************************/"))

(defun c-header-shape (file-name)
  (concat (make-author-info (concat file-name ".h"))
"#ifndef " (upcase file-name) "_H_
#define " (upcase file-name) "_H_\n
/* Includes ------------------------------------------------------------------*/
/* Exported defines ----------------------------------------------------------*/
/* Exported variables --------------------------------------------------------*/
/* Exported functions --------------------------------------------------------*/\n\n\n\n\n
#endif  /* " (upcase file-name) "_H_ */
/******************************** END OF FILE *********************************/"))

(defun c-header-insert (file-name)
  (insert (c-header-shape file-name)))

(defun c-file-insert (file-name)
  (insert (c-file-shape file-name)))

(defun sk-create-h-file (file-name)
  (interactive "sEnter File name : ")
  (append-to-file (c-header-shape file-name) nil (concat file-name ".h")))

(defun sk-create-c-file (file-name)
  (interactive "sEnter File name : ")
  (append-to-file (c-file-shape file-name) nil (concat file-name ".c")))

(defun sk-create-ch-file (file-name)
  (interactive "sEnter File name : ")
  (sk-create-h-file file-name)
  (sk-create-c-file file-name))

(defun sk-clang-complete-make ()
  (interactive)
  (let ((includes
         (mapcar (lambda (x) (concat "-I" x "\n"))
                 (split-string
                  (shell-command-to-string "find -name '*.h' -printf '%h\n' | sort -u")))))
    (if (file-exists-p "./.clang_complete")
        (message ".clang_complete already exists.")
        (progn
          (write-region "" nil "./.clang_complete")
          (mapc (lambda (x) (append-to-file x nil "./.clang_complete")) includes)))))


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

(defun jump-8-line-down ()
  (interactive)
  (dotimes (i 8) (next-line)))

(defun jump-8-line-up ()
  (interactive)
  (dotimes (i 8) (previous-line)))

(defun move-line (n)
  "Move the current line up or down by N lines."
  (interactive "p")
  (setq col (current-column))
  (beginning-of-line) (setq start (point))
  (end-of-line) (forward-char) (setq end (point))
  (let ((line-text (delete-and-extract-region start end)))
    (forward-line n)
    (insert line-text)
    ;; restore point to original column in moved line
    (forward-line -1)
    (forward-char col)))

(defun move-line-up (n)
  "Move the current line up by N lines."
  (interactive "p")
  (move-line (if (null n) -1 (- n))))

(defun move-line-down (n)
  "Move the current line down by N lines."
  (interactive "p")
  (move-line (if (null n) 1 n)))

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

(defun my-prog-nuke-trailing-whitespace ()
    (when (derived-mode-p 'prog-mode)
      (delete-trailing-whitespace)))

(defun buffer-save-or-restore (num &optional restore)
  (if restore
      (progn
        (jump-to-register num)
        (message (concat "Windows are Restored by F" (number-to-string num))))
    (progn
      (window-configuration-to-register num)
      (message (concat  "Windows are saved to F" (number-to-string num))))))


(provide 'sk-utils)
