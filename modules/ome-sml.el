(defun ome-sml-mode-setup ())

(when (executable-find "sml")
  (ome-install 'sml-mode))
