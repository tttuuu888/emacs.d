;; My functions

;; build functions
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
    (if (equal dir nil)
        (message "Makefile is not found")
        (compile (concat "make -j8 -C " dir)))))

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
    (if (equal dir nil)
        (message "Makefile is not found")
        (progn
         (call-process "make" nil nil nil "-C" dir "clean")
         (compile (concat "make -j8 -C " dir))))))


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
  (interactive "sEnter File name : ")
  (insert (c-header-shape file-name)))

(defun c-file-insert (file-name)
  (interactive "sEnter File name : ")
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



(provide 'sk-dev-utils)
