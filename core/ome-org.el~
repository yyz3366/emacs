(add-hook 'org-mode-hook
          (lambda ()
            (local-set-key (kbd "M-C-n") 'outline-next-visible-heading)
            (local-set-key (kbd "M-C-p") 'outline-previous-visible-heading)
            (local-set-key (kbd "M-C-u") 'outline-up-heading)
            ;; table
            (local-set-key (kbd "M-C-w") 'org-table-copy-region)
            (local-set-key (kbd "M-C-y") 'org-table-paste-rectangle)
            (local-set-key (kbd "M-C-l") 'org-table-sort-lines)
            ;; display images
            (local-set-key (kbd "M-I") 'org-toggle-iimage-in-org)))

(setq org-use-speed-commands t)

(setq org-edit-src-auto-save-idle-delay 5)
(setq org-edit-src-content-indentation 0)

(add-hook 'org-src-mode-hook
          (lambda ()
            (make-local-variable 'evil-ex-commands)
            (setq evil-ex-commands (copy-list evil-ex-commands))
            (evil-ex-define-cmd "w[rite]" 'org-edit-src-save)))

(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)

(setcar (nthcdr 2 org-emphasis-regexp-components) " \t\n\r")
(custom-set-variables `(org-emphasis-alist ',org-emphasis-alist))
(org-element--set-regexps)

(defadvice htmlize-buffer-1 (around ome-htmlize-buffer-1 disable)
  (rainbow-delimiters-mode -1)
  ad-do-it
  (rainbow-delimiters-mode t))

(ome-install 'htmlize)

;; code snippet comes from
;; http://joat-programmer.blogspot.com/2013/07/org-mode-version-8-and-pdf-export-with.html
;; Include the latex-exporter
;; check whether org-mode 8.x is available
(when (require 'ox-latex nil 'noerror)
  ;; You need to install pygments to use minted
  (when (executable-find "pygmentize")
    ;; Add minted to the defaults packages to include when exporting.
    (add-to-list 'org-latex-packages-alist '("" "minted"))
    ;; Tell the latex export to use the minted package for source
    ;; code coloration.
    (setq org-latex-listings 'minted)
    ;; Let the exporter use the -shell-escape option to let latex
    ;; execute external programs.
    ;; This obviously and can be dangerous to activate!
    (setq org-latex-minted-options
          '(("mathescape" "true")
            ("linenos" "true")
            ("numbersep" "5pt")
            ("frame" "lines")
            ("framesep" "2mm")))
    (setq org-latex-pdf-process
          '("xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"))))

(when (el-get-package-is-installed 'cdlatex-mode)
  (add-hook 'org-mode-hook 'turn-on-org-cdlatex))

(setq org-export-with-smart-quotes t)
