(defun ome-evil-setup ()
  ;; (define-key evil-insert-state-map (kbd "C-[") 'evil-force-normal-state)
  (setq evil-auto-indent t)
  (setq evil-regexp-search t)
  (setq evil-want-C-i-jump t)
  (mapc
   (lambda (mode-hook)
     (add-hook mode-hook 'turn-on-evil-mode))
   '(text-mode-hook
     prog-mode-hook
     comint-mode-hook
     conf-mode-hook))
  (mapc
   (lambda (mode-hook)
     (add-hook mode-hook 'turn-off-evil-mode))
   '(Info-mode-hook)))

(ome-install 'evil)

(defun ome-evil-leader-setup ()
  (evil-leader/set-leader "<SPC>")
  (eval-after-load "expand-region"
    (progn
      (setq expand-region-contract-fast-key "z")
      (evil-leader/set-key "xx" 'er/expand-region)))
  (eval-after-load "magit"
    (evil-leader/set-key "g" 'magit-status))
  (eval-after-load "quickrun"
    (evil-leader/set-key "q" 'quickrun))
  (evil-leader/set-key
    "b" 'ido-switch-buffer
    "f"  'ido-find-file
    "k" 'kill-buffer
    "d" 'dired
    "oc" 'org-capture
    "od" 'org-doing
    "po" 'org-pomodoro
    "xs" 'save-buffer
    "z" 'repeat
    "0" 'delete-window
    "1" 'delete-other-windows
    "2" 'split-window-below
    "3" 'split-window-right)
  (global-evil-leader-mode))

(evil-escape-mode 1)
(ome-install 'evil-leader)

(ome-install 'evil-surround)

(defun ome-expand-region-setup ()
  (global-set-key (kbd "C-=") 'er/expand-region))

(ome-install 'expand-region)

(defun ome-ace-jump-mode-setup ()
  (when (and (featurep 'evil) (featurep 'evil-leader))
    (evil-leader/set-key
      "c" 'ace-jump-char-mode
      "w" 'ace-jump-word-mode
      "l" 'ace-jump-line-mode)))

(ome-install 'ace-jump-mode)

(when (executable-find "ag")
  (ome-install 'ag))

(when (executable-find "ag")
  (ome-install 'helm-ag))
