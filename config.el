;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

;;
(global-auto-revert-mode t)

;; js config


(setq
 doom-font (font-spec :family "Iosevka" :size 16)
 doom-big-font (font-spec :family "Iosevka" :size 20)
 doom-themes-enable-italic t
 company-idle-delay 0.1
 company-minimum-prefix-length 2
 key-chord-two-keys-delay 0.2
 web-mode-markup-indent-offset 2
 web-mode-code-indent-offset 2
 js-indent-level 2
 css-indent-offset 2
 prettier-js-args '("--no-semi" "--single-quote")
 )

(load-theme 'doom-dracula t)

(doom-themes-visual-bell-config)
(doom-themes-neotree-config)

;; double key press for exiting insert mode
(key-chord-define evil-insert-state-map "jj" 'evil-normal-state)
(key-chord-mode 1)

;; clojure config
(key-chord-define-global ",," 'cider-eval-sexp-at-point)
(key-chord-define-global ".." 'cider-eval-last-sexp)

(add-hook!
  js2-mode 'prettier-js-mode
  (add-hook 'before-save-hook #'refmt-before-save nil t))

(map! :ne "M-/" #'comment-or-uncomment-region)

(global-set-key (kbd "M-ö") (kbd "{"))
(global-set-key (kbd "C-ö") (kbd "["))
(global-set-key (kbd "s-ö") (kbd "("))
(global-set-key (kbd "M-ä") (kbd "}"))
(global-set-key (kbd "C-ä") (kbd "]"))
(global-set-key (kbd "s-ä") (kbd ")"))
