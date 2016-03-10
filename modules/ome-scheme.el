(defun ome-geiser-setup ()
  (setq ome-geiser-impl
        (or (and (executable-find "racket") 'racket)
            (and (executable-find "guile") 'guile)
            (and (executable-find "csi") 'chicken)))
  (setq geiser-default-implementation ome-geiser-impl)
  (setq geiser-guile-load-init-file-p t)
  (add-hook 'geiser-mode-hook
            (lambda () (setq geiser-impl--implementation ome-geiser-impl))))

(defun ome-ac-geiser-setup ()
  (add-hook 'geiser-mode-hook 'ac-geiser-setup)
  (add-hook 'geiser-repl-mode-hook 'ac-geiser-setup)
  (eval-after-load "auto-complete"
    '(add-to-list 'ac-modes 'geiser-repl-mode)))

(when (or (executable-find "racket")
          (executable-find "guile")
          (executable-find "chicken"))
  (ome-install 'geiser)
  (ome-install 'ac-geiser))

;; (ome-install 'quack)
