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
          (lambda () (when (derived-mode-p 'c-mode 'c++-mode)
                                           (local-set-key [(f9)] 'sk-rebuild))))



; meld diff
(defun meld-diff (var1 var2)
  "diff files or directories with meld program"
  (interactive (list (read-file-name "Diff first variable : ")
                     (read-file-name "Diff second variable : ")))
  (call-process "meld" nil nil nil (file-truename var1) (file-truename var2)))
