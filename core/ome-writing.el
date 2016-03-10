(defun ome-markdown-mode-setup ()
  (add-to-list 'auto-mode-alist
               '("\\.mdpp" . markdown-mode)))

(ome-install 'markdown-mode)
