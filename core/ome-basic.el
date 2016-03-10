(defun ome-exec-path-from-shell-setup ()
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize)))

(ome-install 'exec-path-from-shell)

;; set environment coding system
(set-language-environment "UTF-8")
;; auto revert buffer globally
(global-auto-revert-mode t)
;; set TAB and indention
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
;; y or n is suffice for a yes or no question
(fset 'yes-or-no-p 'y-or-n-p)
;; always add new line to the end of a file
(setq require-final-newline t)
;; add no new lines when "arrow-down key" at the end of a buffer
(setq next-line-add-newlines nil)
;; prevent the annoying beep on errors
(setq ring-bell-function 'ignore)
;; remove trailing whitespaces before save
(add-hook 'before-save-hook 'delete-trailing-whitespace)
;; enable to support navigate in camelCase words
(global-subword-mode t)
;; hide startup splash screen
(setq inhibit-startup-screen t)

;; shell-mode settings
(unless (eq system-type 'windows-nt)
  (setq explicit-shell-file-name "/bin/bash")
  (setq shell-file-name "/bin/bash"))
;; always insert at the bottom
(setq comint-scroll-to-bottom-on-input t)
;; no duplicates in command history
(setq comint-input-ignoredups t)
;; what to run when i press enter on a line above the current prompt
(setq comint-get-old-input (lambda () ""))
;; max shell history size
(setq comint-input-ring-size 1000)
;; show all in emacs interactive output
(setenv "PAGER" "cat")
;; set lang to enable Chinese display in shell-mode
(setenv "LANG" "en_US.UTF-8")

;; set text-mode as the default major mode, instead of fundamental-mode
;; The first of the two lines in parentheses tells Emacs to turn on Text mode
;; when you find a file, unless that file should go into some other mode, such
;; as C mode.
(setq-default major-mode 'text-mode)

;;; ido-mode
(setq ido-enable-prefix nil)
(setq ido-enable-case nil)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode t)

;; use icomplete in minibuffer
(icomplete-mode t)

;; delete the selection with a keypress
(delete-selection-mode t)

(defvar mac-keys-p nil)

(defun ome-switch-mac-keys ()
  (interactive)
  (if mac-keys-p
      (progn
        (setq mac-command-modifier 'super)
        (setq mac-option-modifier 'meta)
        (setq mac-keys-p nil)
        (message "turn off Mac OS X's control/meta."))
    (progn
      (setq mac-command-modifier 'meta)
      (setq mac-option-modifier 'control)
      (setq mac-keys-p t)
      (message "turn on Mac OS X's control/meta."))))

(when (eq system-type 'darwin)
  (ome-switch-mac-keys))

(setq-default fill-column 79)
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook 'prog-mode-hook 'turn-on-auto-fill)

(setq-default save-place t)
(setq save-place-file (concat user-emacs-directory ".saved-places"))
(require 'saveplace)

(require 'recentf)

;; get rid of `find-file-read-only' and replace it with something
;; more useful.
(global-set-key (kbd "C-x C-r") 'ido-recentf-open)

;; save the .recentf file to .emacs.d/
(setq recentf-save-file (concat user-emacs-directory ".recentf"))

;; enable recent files mode.
(recentf-mode t)

;; 50 files ought to be enough.
(setq recentf-max-saved-items 50)

(defun ido-recentf-open ()
  "Use `ido-completing-read' to \\[find-file] a recent file"
  (interactive)
  (if (find-file (ido-completing-read "Find recent file: " recentf-list))
      (message "Opening file...")
    (message "Aborting")))

(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(require 'uniquify)

;; use aspell instead of ispell
(setq ispell-program-name "aspell"
      ispell-extra-args '("--sug-mode=ultra"))

(defun ome-flycheck-setup ()
  (eval-after-load 'flycheck
    '(setq flycheck-checkers (delq 'emacs-lisp-checkdoc flycheck-checkers)))
  (add-hook 'prog-mode-hook 'flycheck-mode))

(ome-install 'flycheck)

(defun ome-editorconfig-setup ()
  (require 'editorconfig))

(ome-install 'editorconfig)

(defun ome-indent-guide-setup ()
  (require 'indent-guide))

(ome-install 'indent-guide)
