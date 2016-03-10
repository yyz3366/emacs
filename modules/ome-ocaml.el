;; Keep an empty hook function for later customization.
(defun ome-caml-mode-setup ())

(when (executable-find "ocaml")
  (ome-install 'caml-mode))

(defun ome-tuareg-mode-setup ()
  ;; The following settings comes from tuareg-mode's README
  ;; use new SMIE engine
  (setq tuareg-use-smie t)
  ;; Indent `=' like a standard keyword.
  (setq tuareg-lazy-= t)
  ;; Indent [({ like standard keywords.
  (setq tuareg-lazy-paren t)
  ;; No indentation after `in' keywords.
  (setq tuareg-in-indent 0)
  ;; set ocaml library path
  (setq tuareg-library-path "/usr/lib/ocaml")
  (add-hook 'tuareg-mode-hook
            (lambda ()
              (define-key tuareg-mode-map (kbd "RET")
                'newline-and-indent))))

(when (executable-find "ocaml")
  (ome-install 'tuareg-mode))
