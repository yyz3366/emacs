(defvar ome-lisp-modes '(emacs-lisp-mode
                         inferior-emacs-lisp-mode
                         lisp-interaction-mode
                         scheme-mode
                         lisp-mode
                         eshell-mode
                         slime-repl-mode
                         nrepl-mode
                         clojure-mode
                         common-lisp-mode)
  "List of Lisp modes.")

(defun ome-remove-elc-on-save ()
  "If you're saving an elisp file, likely the .elc is no longer valid."
  (make-local-variable 'after-save-hook)
  (add-hook 'after-save-hook
            (lambda ()
              (if (file-exists-p (concat buffer-file-name "c"))
                  (delete-file (concat buffer-file-name "c"))))))

(add-hook 'emacs-lisp-mode-hook 'ome-remove-elc-on-save)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)

(defun ome-elisp-slime-nav-setup ()
  ;; (defun ome-elisp-slime-nav-keybindings-in-evil ()
  ;;   (if (and (boundp 'evil-mode) evil-mode)
  ;;       (progn (define-key elisp-slime-nav-mode-map (kbd "C-c C-d .")
  ;;                'elisp-slime-nav-find-elisp-thing-at-point)
  ;;              (define-key elisp-slime-nav-mode-map (kbd "C-c C-d ,")
  ;;                'pop-tag-mark))))
  (dolist (hook '(emacs-lisp-mode-hook
                  lisp-interaction-mode-hook
                  ielm-mode-hook
                  eshell-mode-hook))
    (add-hook hook 'turn-on-elisp-slime-nav-mode)))
    ;; (add-hook hook 'ome-elisp-slime-nav-keybindings-in-evil)))

(ome-install 'elisp-slime-nav)

(defun ome-visit-ielm ()
  "Switch to default `ielm' buffer.
Start `ielm' if it's not already running."
  (interactive)
  (ome-start-or-switch-to 'ielm "*ielm*"))

(define-key emacs-lisp-mode-map (kbd "C-c C-z") 'ome-visit-ielm)
(add-to-list 'ac-modes 'inferior-emacs-lisp-mode)
(add-hook 'ielm-mode-hook 'ac-emacs-lisp-mode-setup)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)

(add-hook 'eshell-mode-hook
          (lambda ()
            (add-to-list 'ac-sources 'ac-source-pcomplete)))

(add-to-list 'ac-modes 'eshell-mode)
(add-hook 'eshell-mode-hook 'turn-on-eldoc-mode)
(add-hook 'eshell-mode-hook 'ac-emacs-lisp-mode-setup)
