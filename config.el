;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

;;
(global-auto-revert-mode t)

(key-chord-mode 1)

(require 'company)

(setq
 doom-font (font-spec :family "Iosevka" :size 15)
 doom-big-font (font-spec :family "Iosevka" :size 18)
 ;; doom-font (font-spec :family "Mononoki" :size 16)
 ;; doom-big-font (font-spec :family "Mononoki" :size 20)
 doom-theme 'doom-dracula
 doom-themes-enable-italic t
 key-chord-two-keys-delay 0.2
 web-mode-markup-indent-offset 2
 web-mode-code-indent-offset 2
 js-indent-level 2
 css-indent-offset 2
 prettier-js-args '("--no-semi" "--single-quote")
 company-idle-delay 0.2
 company-echo-delay 0.0
 company-minimum-prefix-length 2
 company-tooltip-flip-when-above t
 company-dabbrev-downcase nil)

(doom-themes-visual-bell-config)
(doom-themes-neotree-config)

;; javascript
(after! tide
  (setq tide-completion-detailed t
        tide-always-show-documentation t))

(add-hook!
  js2-mode 'prettier-js-mode
  (add-hook 'before-save-hook #'refmt-before-save nil t))


;; double key press for exiting insert mode

;; clojure config

(after! clojure-mode
  (define-clojure-indent
    (PUT 2)
    (POST 2)
    (GET 2)
    (PATCH 2)
    (DELETE 2)
    (context 2)
    (checking 3)
    (context 2)
    (defroutes 'defun)
    (render 'defun)
    (componentDidMount 'defun)
    (componentWillMount 'defun)
    (query 'defun)
    (params 'defun))
  ;; (setq cider-cljs-lein-repl
  ;;       "(do (require 'figwheel-sidecar.repl-api)
  ;;        (figwheel-sidecar.repl-api/start-figwheel!)
  ;;        (figwheel-sidecar.repl-api/cljs-repl))")
  (setq cljr-magic-require-namespaces
        '(("io" . "clojure.java.io")
          ("sh" . "clojure.java.shell")
          ("jdbc" . "clojure.java.jdbc")
          ("set" . "clojure.set")
          ("time" . "java-time")
          ("walk" . "clojure.walk")
          ("zip" . "clojure.zip")
          ("async" . "clojure.core.async")
          ("component" . "com.stuartsierra.component")
          ("url" . "cemerick.url" )
          ("csv" . "clojure.data.csv")
          ("json" . "cheshire.core")
          ("s" . "clojure.spec.alpha")))
  (visual-line-mode 1))

(defun clj-modes-hooks ()
  (key-chord-define clojure-mode-map ",," 'cider-eval-defun-at-point)
            (key-chord-define clojure-mode-map "--" 'cider-eval-last-sexp)
            (key-chord-define clojure-mode-map "+ü" 'cider-find-var)
            (key-chord-define clojure-mode-map "#ü" 'cider-eval-buffer)
            (key-chord-define clojure-mode-map "#ä" 'cider-format-defun)
            (key-chord-define clojure-mode-map "#t" 'cider-test-run-test)
            (key-chord-define clojure-mode-map "üü" 'cider-pprint-eval-last-sexp)
            (rainbow-delimiters-mode 0)
            (paren-face-mode))

(add-hook 'clojure-mode-hook 'clj-modes-hooks)
(add-hook 'clojurec-mode-hook 'clj-modes-hooks)
(add-hook 'clojurescript-mode-hook 'clj-modes-hooks)


;; global shortcuts
(key-chord-define evil-insert-state-map "jj" 'evil-normal-state)
(key-chord-define-global "##" 'comment-line)
(key-chord-define-global "#+" 'comment-or-uncomment-region)
(key-chord-define-global "öö" 'evilmi-jump-items)
(key-chord-define-global "qw" 'other-frame)

(global-set-key (kbd "M-ö") (kbd "{"))
(global-set-key (kbd "C-ö") (kbd "["))
(global-set-key (kbd "s-ö") (kbd "("))
(global-set-key (kbd "M-ä") (kbd "}"))
(global-set-key (kbd "C-ä") (kbd "]"))
(global-set-key (kbd "s-ä") (kbd ")"))
(global-set-key (kbd "s-y") 'sp-copy-sexp)
(global-set-key (kbd "s-x") 'sp-kill-sexp)
(global-set-key (kbd "s-c") 'sp-kill-symbol)
(global-set-key (kbd "C-<right>") 'sp-forward-slurp-sexp)
(global-set-key (kbd "C-<left>") 'sp-forward-barf-sexp)
(global-set-key (kbd "M-s") 'sp-splice-sexp-killing-backward)
(global-set-key (kbd "<f5>") 'helm-projectile-grep)

 ;; Coloring
(defun live-fontify-hex-colors (limit)
  (remove-overlays (point) limit 'fontify-hex-colors t)
  (while (re-search-forward "\\(#[[:xdigit:]]\\{6\\}\\)" limit t)
    (let ((ov (make-overlay (match-beginning 0)
                            (match-end 0))))
      (overlay-put ov 'face  (list :background (match-string 1) :foreground "black"))
      (overlay-put ov 'fontify-hex-colors t)
      (overlay-put ov 'evaporate t)))
  ;; return nil telling font-lock not to fontify anything from this
  ;; function
  nil)

(defun live-fontify-hex-colours-in-current-buffer ()
  (interactive)
  (font-lock-add-keywords nil
                          '((live-fontify-hex-colors))))

(provide 'live-fontify-hex)

(add-hook 'css-mode-hook
          #'live-fontify-hex-colours-in-current-buffer)

(add-hook 'scss-mode-hook
          #'live-fontify-hex-colours-in-current-buffer)

(add-hook 'scss-mode-hook
          #'live-fontify-hex-colours-in-current-buffer)

(add-hook 'js2-mode-hook
          #'live-fontify-hex-colours-in-current-buffer)

(add-hook 'cider-mode-hook
          #'live-fontify-hex-colours-in-current-buffer)

(add-hook 'web-mode-hook
          #'live-fontify-hex-colours-in-current-buffer)

(add-hook 'js2-mode-hook 'rainbow-delimiters-mode-disable)

;; zoombie keys
(define-key key-translation-map [dead-grave] "`")
(define-key key-translation-map [dead-acute] "'")
(define-key key-translation-map [dead-circumflex] "^")
(define-key key-translation-map [dead-diaeresis] "\"")
(define-key key-translation-map [dead-tilde] "~")

