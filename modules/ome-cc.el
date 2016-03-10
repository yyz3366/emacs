(setq c-default-style '((java-mode . "java")
                        (awk-mode . "awk")
                        (c-mode . "k&r")
                        (c++-mode . "stroustrup")
                        (other . "linux")))

(setq-default c-basic-offset 4)
(add-to-list 'auto-mode-alist '("\\.h$" . c++-mode))

(defun ome-c-initialization-hook ()
  (define-key c-mode-base-map (kbd "RET") 'c-context-line-break))

(add-hook 'c-initialization-hook 'ome-c-initialization-hook)

(defun ome-c-mode-common-hook ()
  (add-to-list 'c-cleanup-list 'defun-close-semi)
  ;; (c-toggle-auto-newline)
  (c-toggle-hungry-state))

;; this will affect all modes derived from cc-mode, like
;; java-mode, php-mode, etc
(add-hook 'c-mode-common-hook 'ome-c-mode-common-hook)

(add-hook 'makefile-mode-hook
          (lambda ()
            (setq indent-tabs-mode t)))

(when (executable-find "cmake")
  (ome-install 'cmake-mode))

(if (executable-find "cscope")
    (ome-install 'xcscope))

(defun ome-pkg-config-enable-clang-flag (pkg-config-lib)
  "This function will add necessary header file path of a
specified by `pkg-config-lib' to `ac-clang-flags', which make it
completionable by auto-complete-clang"
  (interactive "spkg-config lib: ")
  (if (executable-find "pkg-config")
      (if (= (shell-command
              (format "pkg-config %s" pkg-config-lib))
             0)
          (setq ac-clang-flags
                (append ac-clang-flags
                        (split-string
                         (shell-command-to-string
                          (format "pkg-config --cflags-only-I %s"
                                  pkg-config-lib)))))
        (message "Error, pkg-config lib %s not found." pkg-config-lib))
    (message "Error: pkg-config tool not found.")))

;; (ome-pkg-config-enable-clang-flag "QtGui")

(defun ome-auto-complete-clang-setup ()
  (require 'auto-complete-clang)
  (setq command "echo | g++ -v -x c++ -E - 2>&1 |
                 grep -A 20 starts | grep include | grep -v search")
  (setq ac-clang-flags
        (mapcar (lambda (item)
                  (concat "-I" item))
                (split-string
                 (shell-command-to-string command))))
  ;; completion for C/C++ macros.
  (push "-code-completion-macros" ac-clang-flags)
  (push "-code-completion-patterns" ac-clang-flags)
  (dolist (mode-hook '(c-mode-hook c++-mode-hook))
    (add-hook mode-hook
              (lambda ()
                (add-to-list 'ac-sources 'ac-source-clang)))))

(when (executable-find "clang")
  (ome-install 'auto-complete-clang))
