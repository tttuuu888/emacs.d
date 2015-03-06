;; My functions

; build functions
(defun parent-directory (dir)
  (unless (equal "/" dir)
    (file-name-directory (directory-file-name dir))))

(defun find-file-in-tree (dir fname)
  (let ((file (concat dir fname))
        (parent (parent-directory dir)))
    (if (file-exists-p file)
        dir
        (when parent
          (find-file-in-tree parent fname)))))

(defun sk-make ()
  "Find a Makefile path and excute make"
  (interactive)
  (let ((dir (find-file-in-tree (file-name-directory default-directory) "Makefile")))
    (unless (equal dir nil)
      (compile (concat "make -C " dir)))))

(defun sk-clean ()
  "Find a Makefile path and excute make"
  (interactive)
  (let ((dir (find-file-in-tree (file-name-directory default-directory) "Makefile")))
    (unless (equal dir nil)
      (compile (concat "make -C " dir " clean")))))

(defun sk-rebuild ()
  "Find a Makefile path and excute rebuild(clean and make)"
  (interactive)
  (let ((dir (find-file-in-tree (file-name-directory default-directory) "Makefile")))
    (unless (equal dir nil)
       (call-process "make" nil nil nil "-C" dir "clean")
       (compile (concat "make -C " dir)))))


(add-hook 'prog-mode-hook
          (lambda () (when (derived-mode-p 'c-mode 'c++-mode 'dired-mode 'eshell-mode)
                                           (local-set-key [(f9)] 'sk-rebuild))))



; meld diff
(defun meld-diff (var1 var2)
  "diff files or directories with meld program"
  (interactive (list (read-file-name "Diff first variable : ")
                     (read-file-name "Diff second variable : ")))
  (call-process "meld" nil nil nil (file-truename var1) (file-truename var2)))


; open temp file
(defun tempfile-open ()
  "open temp file under /tmp directory"
  (interactive)
  (find-file (make-temp-file 
              (let ((now (decode-time)))
                (concat (number-to-string (car now)) (number-to-string (car (cdr now))) "_temp")))))




; adding temp C code to remove warnings.
; the function should be in the shape of below:
; int temp(int a, int b)
; {
; }
; and it turns to :
; int temp(int a, intb)
; {
;     (void)a;
;     (void)b;
;     return (int)0;
; }
(defun remove-function-warning (p1 p2)
  "To remove compiler warning, add the code using every parameters and return proper type"
  (interactive "r")
  (let ((x (count-matches "{" p1 p2 )))
    (goto-char p1)
    (dotimes (i x)
      (let ((start (search-forward "("))
            (ret (progn (beginning-of-line) (thing-at-point 'word)))
            (end (search-forward ")")))
        (copy-region-as-kill start (- end 1))

        (progn
          (search-forward "{") 
          (insert "\n")
          (yank))

        (let ((start (search-backward "{"))
              (end (search-forward "}")))
          (replace-regexp ",$" " " nil start end)
          (replace-regexp "," "\n" nil start end)
          (next-line))

        (let ((start (progn (search-backward "{") (next-line) (beginning-of-line) (point)))
              (end (progn (search-forward "}") (previous-line) (end-of-line) (point))))
          (replace-regexp "^.*?\\([0-z]+$\\)" "(void)\\1;" nil start end))
        
        (insert (if (equalp ret "void")
                    (format "\n\treturn;")
                    (format "\n\treturn (%s)0;" ret)))
        ))
    (let ((lastp (point)))
      (indent-region p1 lastp))))
