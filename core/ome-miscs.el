(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)

(server-mode t)

;; Seed the random-number generator
(random t)

(defun ome-rainbow-delimiters-setup ()
  (rainbow-delimiters-mode))
(ome-install 'rainbow-delimiters)

(auto-compression-mode t)

(auto-image-file-mode t)

(add-hook 'prog-mode-hook
          (lambda ()
            (outline-minor-mode t)))

;; (add-hook 'outline-minor-mode-hook
;;           (lambda ()
;;             (local-set-key (kbd "C-c C-o")
;;                            outline-mode-prefix-map)))

(defun ome-magit-setup ()
  ;; magit-status is the entry point
  (global-set-key (kbd "C-x g") 'magit-status)
  (add-hook 'git-rebase-mode-hook
            (lambda ()
              (evil-local-mode -1))))

(if (executable-find "git")
    (ome-install 'magit))

(defun ome-git-gutter-fringe-setup ()
  (dolist (mode-hook '(text-mode-hook prog-mode-hook))
    (add-hook mode-hook
              (lambda ()
                ;; set fringe width to better display
                (setq left-fringe-width 10)
                (setq right-fringe-width 4))))

  ;; some keybindings
  (global-set-key (kbd "C-x v g") 'git-gutter:toggle)
  (global-set-key (kbd "C-x v =") 'git-gutter:popup-hunk)
  ;; Jump to next/previous hunk
  (global-set-key (kbd "C-x v p") 'git-gutter:previous-hunk)
  (global-set-key (kbd "C-x v n") 'git-gutter:next-hunk)
  ;; Stage current hunk
  (global-set-key (kbd "C-x v s") 'git-gutter:stage-hunk)
  ;; Revert current hunk
  (global-set-key (kbd "C-x v r") 'git-gutter:revert-hunk)

  ;; improve performance
  ;; (setq git-gutter:update-hooks '(after-save-hook after-revert-hook))

  (require 'git-gutter-fringe)
  (global-git-gutter-mode))

(ome-install 'git-gutter-fringe)

(global-visual-line-mode t)

(defun ome-projectile-setup ()
  (projectile-global-mode)
  (setq projectile-enable-caching t)
  (global-set-key (kbd "C-x c h") 'helm-projectile))

(ome-install 'projectile)

(defun ome-create-newline-and-enter-sexp (&rest _ignored)
  "Open a new brace or bracket expression, with relevant newlines and indent. "
  (previous-line)
  (indent-according-to-mode)
  (forward-line)
  (newline)
  (indent-according-to-mode)
  (forward-line -1)
  (indent-according-to-mode))

(defun ome-smartparens-setup ()
  ;; global
  (require 'smartparens-config)
  (setq sp-autoskip-closing-pair 'always)
  (setq sp-navigate-close-if-unbalanced t)
  (smartparens-global-mode t)

  ;; turn on smartparens-strict-mode on all lisp-like mode
  (dolist (sp--lisp-mode-hook
           (mapcar (lambda (x)
                     (intern (concat (symbol-name x) "-hook")))
                   sp--lisp-modes))
    (add-hook sp--lisp-mode-hook
              'smartparens-strict-mode)
    ;; inferior-emacs-lisp-mode-hook is an alias of ielm-mode-hook
    ;; and it will be overrided when you first start ielm
    (add-hook 'ielm-mode-hook
              'smartparens-strict-mode))

  ;; highlights matching pairs
  (show-smartparens-global-mode t)

  ;; keybinding management
  (define-key sp-keymap (kbd "M-s f") 'sp-forward-sexp)
  (define-key sp-keymap (kbd "M-s b") 'sp-backward-sexp)

  (define-key sp-keymap (kbd "M-s d") 'sp-down-sexp)
  (define-key sp-keymap (kbd "M-s D") 'sp-backward-down-sexp)
  (define-key sp-keymap (kbd "M-s a") 'sp-beginning-of-sexp)
  (define-key sp-keymap (kbd "M-s e") 'sp-end-of-sexp)

  (define-key sp-keymap (kbd "M-s u") 'sp-up-sexp)
  ;; (define-key emacs-lisp-mode-map (kbd ")") 'sp-up-sexp)
  (define-key sp-keymap (kbd "M-s U") 'sp-backward-up-sexp)
  (define-key sp-keymap (kbd "M-s t") 'sp-transpose-sexp)

  (define-key sp-keymap (kbd "M-s n") 'sp-next-sexp)
  (define-key sp-keymap (kbd "M-s p") 'sp-previous-sexp)

  (define-key sp-keymap (kbd "M-s k") 'sp-kill-sexp)
  (define-key sp-keymap (kbd "M-s w") 'sp-copy-sexp)

  (define-key sp-keymap (kbd "M-s s") 'sp-forward-slurp-sexp)
  (define-key sp-keymap (kbd "M-s r") 'sp-forward-barf-sexp)
  (define-key sp-keymap (kbd "M-s S") 'sp-backward-slurp-sexp)
  (define-key sp-keymap (kbd "M-s R") 'sp-backward-barf-sexp)
  (define-key sp-keymap (kbd "M-s F") 'sp-forward-symbol)
  (define-key sp-keymap (kbd "M-s B") 'sp-backward-symbol)

  (define-key sp-keymap (kbd "M-s [") 'sp-select-previous-thing)
  (define-key sp-keymap (kbd "M-s ]") 'sp-select-next-thing)

  (define-key sp-keymap (kbd "M-s M-i") 'sp-splice-sexp)
  (define-key sp-keymap (kbd "M-s <delete>") 'sp-splice-sexp-killing-forward)
  (define-key sp-keymap (kbd "M-s <backspace>") 'sp-splice-sexp-killing-backward)
  (define-key sp-keymap (kbd "M-s M-<backspace>") 'sp-splice-sexp-killing-around)

  (define-key sp-keymap (kbd "M-s M-d") 'sp-unwrap-sexp)
  (define-key sp-keymap (kbd "M-s M-b") 'sp-backward-unwrap-sexp)

  (define-key sp-keymap (kbd "M-s M-t") 'sp-prefix-tag-object)
  (define-key sp-keymap (kbd "M-s M-p") 'sp-prefix-pair-object)
  (define-key sp-keymap (kbd "M-s M-c") 'sp-convolute-sexp)
  (define-key sp-keymap (kbd "M-s M-a") 'sp-absorb-sexp)
  (define-key sp-keymap (kbd "M-s M-e") 'sp-emit-sexp)
  (define-key sp-keymap (kbd "M-s M-p") 'sp-add-to-previous-sexp)
  (define-key sp-keymap (kbd "M-s M-n") 'sp-add-to-next-sexp)
  (define-key sp-keymap (kbd "M-s M-j") 'sp-join-sexp)
  (define-key sp-keymap (kbd "M-s M-s") 'sp-split-sexp)
  (define-key sp-keymap (kbd "M-s M-r") 'sp-raise-sexp)

  ;; pair management
  (sp-local-pair 'minibuffer-inactive-mode "'" nil :actions nil)

  ;; markdown-mode
  (sp-with-modes '(markdown-mode gfm-mode rst-mode)
    (sp-local-pair "*" "*" :bind "C-*")
    (sp-local-tag "2" "**" "**")
    (sp-local-tag "s" "```scheme" "```")
    (sp-local-tag "<"  "<_>" "</_>" :transform 'sp-match-sgml-tags))

  ;; tex-mode latex-mode
  (sp-with-modes '(tex-mode plain-tex-mode latex-mode)
    (sp-local-tag "i" "\"<" "\">"))

  ;; html-mode
  (sp-with-modes '(html-mode sgml-mode)
    (sp-local-pair "<" ">"))

  ;; lisp modes
  (sp-with-modes sp--lisp-modes
    (sp-local-pair "(" nil :bind "C-("))

  (dolist (mode '(c-mode c++-mode java-mode js2-mode sh-mode css-mode))
    (sp-local-pair mode
                   "{"
                   nil
                   :post-handlers
                   '((ome-create-newline-and-enter-sexp "RET")))))

(ome-install 'smartparens)

(defun ome-emacs-w3m-setup ()
  ;; (setq w3m-default-display-inline-images t)
  (setq w3m-home-page "http://www.google.com/ncr")
  (setq browse-url-browser-function 'w3m-browse-url)
  (global-set-key (kbd "C-x w") 'browse-url-at-point))

(when (executable-find "w3m")
  (ome-install 'emacs-w3m))

(ome-install 'quickrun)

(defun ome-diminish-setup ()
  ;; diminish some builtin mode
  (eval-after-load "abbrev"
    '(diminish 'abbrev-mode))

  (eval-after-load 'simple
    '(progn
       ;; diminish auto-fill-mode
       (diminish 'auto-fill-function)
       ;; https://github.com/xiaohanyu/oh-my-emacs/issues/36
       (when (string< emacs-version "24.3.50")
         (diminish 'global-visual-line-mode))
       (diminish 'visual-line-mode)))

  (eval-after-load "outline"
    '(diminish 'outline-minor-mode))

  (eval-after-load "eldoc"
    '(diminish 'eldoc-mode))

  ;; diminish third-party mode
  (eval-after-load "elisp-slime-nav"
    '(diminish 'elisp-slime-nav-mode))

  (eval-after-load "helm"
    '(diminish 'helm-mode))

  (eval-after-load "projectile"
    '(diminish 'projectile-mode "Prjl"))

  (eval-after-load "undo-tree"
    '(diminish 'undo-tree-mode))

  (eval-after-load "git-gutter-fringe"
    '(diminish 'git-gutter-mode)))

(ome-install 'diminish)
