(setq css-indent-offset 2)

(add-hook 'css-mode-hook
          (lambda ()
            (linum-mode 1)))

(defun ome-web-mode-setup ()
  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.hbs\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

  (defun ome-web-mode-hook ()
    ;; indentation
    ;; HTML offset indentation
    (setq web-mode-markup-indent-offset 2)
    ;; CSS offset indentation
    (setq web-mode-code-indent-offset 2)
    ;; Script offset indentation (for JavaScript, Java, PHP, etc.)
    (setq web-mode-css-indent-offset 2)
    ;; HTML content indentation
    (setq web-mode-indent-style 2)

    ;; padding
    ;; For <style> parts
    (setq web-mode-style-padding 1)
    ;; For <script> parts
    (setq web-mode-script-padding 1)
    ;; For multi-line blocks
    (setq web-mode-block-padding 0))

  (add-hook 'web-mode-hook 'ome-web-mode-hook))

(ome-install 'web-mode)

(defun ome-less-css-mode-setup ()
  (setq less-css-compile-at-save t))

(when (executable-find "lessc")
  (ome-install 'less-css-mode))

(defun ome-rainbow-mode-setup ()
  (add-hook 'css-mode-hook 'rainbow-mode))

(ome-install 'rainbow-mode)
