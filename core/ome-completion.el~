;; hippie expand is dabbrev expand on steroids
(setq hippie-expand-try-functions-list '(try-expand-dabbrev
                                         try-expand-dabbrev-all-buffers
                                         try-expand-dabbrev-from-kill
                                         try-complete-file-name-partially
                                         try-complete-file-name
                                         try-expand-all-abbrevs
                                         try-expand-list
                                         try-expand-line
                                         try-complete-lisp-symbol-partially
                                         try-complete-lisp-symbol))

(defun ome-auto-complete-setup ()
  (require 'auto-complete-config)

  (define-key ac-mode-map (kbd "M-/") 'ac-fuzzy-complete)
  (dolist (ac-mode '(text-mode org-mode))
    (add-to-list 'ac-modes ac-mode))
  (dolist (ac-mode-hook '(text-mode-hook org-mode-hook prog-mode-hook))
    (add-hook ac-mode-hook
              (lambda ()
                (setq ac-fuzzy-enable t)
                (add-to-list 'ac-sources 'ac-source-files-in-current-dir)
                (add-to-list 'ac-sources 'ac-source-filename))))

  (ac-config-default))

(ome-install 'auto-complete)

(defun ac-pcomplete ()
  ;; eshell uses `insert-and-inherit' to insert a \t if no completion
  ;; can be found, but this must not happen as auto-complete source
  (flet ((insert-and-inherit (&rest args)))
    ;; this code is stolen from `pcomplete' in pcomplete.el
    (let* (tramp-mode ;; do not automatically complete remote stuff
           (pcomplete-stub)
           (pcomplete-show-list t) ;; inhibit patterns like * being deleted
           pcomplete-seen pcomplete-norm-func
           pcomplete-args pcomplete-last pcomplete-index
           (pcomplete-autolist pcomplete-autolist)
           (pcomplete-suffix-list pcomplete-suffix-list)
           (candidates (pcomplete-completions))
           (beg (pcomplete-begin))
           ;; note, buffer text and completion argument may be
           ;; different because the buffer text may bet transformed
           ;; before being completed (e.g. variables like $HOME may be
           ;; expanded)
           (buftext (buffer-substring beg (point)))
           (arg (nth pcomplete-index pcomplete-args)))
      ;; we auto-complete only if the stub is non-empty and matches
      ;; the end of the buffer text
      (when (and (not (zerop (length pcomplete-stub)))
                 (or (string= pcomplete-stub ; Emacs 23
                              (substring buftext
                                         (max 0
                                              (- (length buftext)
                                                 (length pcomplete-stub)))))
                     (string= pcomplete-stub ; Emacs 24
                              (substring arg
                                         (max 0
                                              (- (length arg)
                                                 (length pcomplete-stub)))))))
        ;; Collect all possible completions for the stub. Note that
        ;; `candidates` may be a function, that's why we use
        ;; `all-completions`.
        (let* ((cnds (all-completions pcomplete-stub candidates))
               (bnds (completion-boundaries pcomplete-stub
                                            candidates
                                            nil
                                            ""))
               (skip (- (length pcomplete-stub) (car bnds))))
          ;; We replace the stub at the beginning of each candidate by
          ;; the real buffer content.
          (mapcar #'(lambda (cand) (concat buftext (substring cand skip)))
                  cnds))))))

(defvar ac-source-pcomplete
  '((candidates . ac-pcomplete)))

(defun ome-helm-setup ()
  (require 'helm-config)
  (setq helm-input-idle-delay 0.2)
  (helm-mode t)
  (setq helm-locate-command
        (case system-type
          ('gnu/linux "locate -i -r %s")
          ('berkeley-unix "locate -i %s")
          ('windows-nt "es %s")
          ('darwin "mdfind -name %s %s")
          (t "locate %s")))

  (global-set-key (kbd "C-x c g") 'helm-do-grep)
  (global-set-key (kbd "C-x c o") 'helm-occur)
  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "C-x C-f") 'helm-find-files)

  ;; rebind tab to run persistent action
  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
  ;; make TAB works in terminal
  (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)
  ;; list actions using C-z
  (define-key helm-map (kbd "C-z") 'helm-select-action)

  (when (executable-find "curl")
    (setq helm-google-suggest-use-curl-p t))

  (setq
   ;; open helm buffer inside current window, not occupy whole other window
   helm-split-window-in-side-p t
   ;; fuzzy matching buffer names when non--nil
   helm-buffers-fuzzy-matching t
   ;; move to end or beginning of source when reaching top or bottom of source.
   helm-move-to-line-cycle-in-source t
   ;; search for library in `require' and `declare-function' sexp.
   helm-ff-search-library-in-sexp t
   ;; scroll 8 lines other window using M-<next>/M-<prior>
   helm-scroll-amount 8
   helm-ff-file-name-history-use-recentf t))

(ome-install 'helm)

(defun ome-helm-descbinds-setup ()
  (helm-descbinds-mode 1))

(ome-install 'helm-descbinds)

(eval-after-load 'popup
  '(progn
     (define-key popup-menu-keymap (kbd "M-n") 'popup-next)
     (define-key popup-menu-keymap (kbd "TAB") 'popup-next)
     (define-key popup-menu-keymap (kbd "<tab>") 'popup-next)
     (define-key popup-menu-keymap (kbd "<backtab>") 'popup-previous)
     (define-key popup-menu-keymap (kbd "M-p") 'popup-previous)))

(defun yas-popup-isearch-prompt (prompt choices &optional display-fn)
  (when (featurep 'popup)
    (popup-menu*
     (mapcar
      (lambda (choice)
        (popup-make-item
         (or (and display-fn (funcall display-fn choice))
             choice)
         :value choice))
      choices)
     :prompt prompt
     ;; start isearch mode immediately
     :isearch t)))

(defun ome-yasnippet-setup ()
  (setq yas-prompt-functions
        '(yas-popup-isearch-prompt
          yas-no-prompt))
  (yas-global-mode))

(ome-install 'popup)
(ome-install 'yasnippet)
