;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here
(global-auto-revert-mode t)

(key-chord-mode 1)

(setq
 doom-font (font-spec :family "Monoid HalfTight" :size 22)
 doom-big-font (font-spec :family "Monoid HalfTight" :size 32)
 doom-theme 'doom-dracula
 doom-themes-enable-italic t
 key-chord-two-keys-delay 0.2
 web-mode-markup-indent-offset 2
 web-mode-code-indent-offset 2
 js-indent-level 2
 css-indent-offset 2
 prettier-js-args '("--no-semi" "--single-quote"))

(doom-themes-visual-bell-config)
(doom-themes-neotree-config)

;; clojure config
(after! clojure-mode
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
    (params 'defun)
    (extend-type 'defun))
  (key-chord-define clojure-mode-map ",," 'cider-eval-defun-at-point)
  (key-chord-define clojure-mode-map ",s" 'cider-send-last-sexp-to-repl)
  (key-chord-define clojure-mode-map "--" 'cider-eval-last-sexp)
  (key-chord-define clojure-mode-map "+ü" 'cider-find-var)
  (key-chord-define clojure-mode-map "#ü" 'cider-eval-buffer)
  (key-chord-define clojure-mode-map "#ä" 'cider-format-defun)
  (key-chord-define clojure-mode-map "#t" 'cider-test-run-test)
  (key-chord-define clojure-mode-map "üü" 'cider-pprint-eval-last-sexp)
  (key-chord-define clojure-mode-map "ää" 'cider-eval-region)
  (key-chord-define clojure-mode-map "#d" 'cider-doc)
  (rainbow-delimiters-mode-disable)
  (paren-face-mode)
  (paredit-mode 1)
  (setq cider-repl-wrap-history t)
  (setq cider-save-file-on-load t)
  (setq cider-overlays-use-font-lock t)
  (setq cider-repl-pop-to-buffer-on-connect nil)
  (require 'paren)
  (set-face-background 'show-paren-match "#ffb86c") ;; (face-background 'default)
  (set-face-foreground 'show-paren-match "#282a36")
  (set-face-attribute 'show-paren-match nil :weight 'extra-bold))

(add-hook 'clojure-mode-hook 'clj-modes-hooks)
(add-hook 'clojurec-mode-hook 'clj-modes-hooks)
(add-hook 'clojurescript-mode-hook 'clj-modes-hooks)
(add-hook 'cider-mode-hook 'clj-modes-hooks)
(add-hook 'cider-repl-mode-hook '(lambda () (setq scroll-conservatively 85)))

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
(global-set-key (kbd "M-l") 'sp-next-sexp)
(global-set-key (kbd "C-<right>") 'sp-forward-slurp-sexp)
(global-set-key (kbd "C-<left>") 'sp-forward-barf-sexp)
(global-set-key (kbd "M-s") 'sp-splice-sexp-killing-backward)
(global-set-key (kbd "<f5>") 'helm-projectile-grep)
(global-set-key (kbd "<f7>") 'helm-semantic-or-imenu)
(global-set-key (kbd "<f8>") 'magit-status)

;; zoombie keys
(define-key key-translation-map [dead-grave] "`")
(define-key key-translation-map [dead-acute] "'")
(define-key key-translation-map [dead-circumflex] "^")
(define-key key-translation-map [dead-diaeresis] "\"")
(define-key key-translation-map [dead-tilde] "~")

(exec-path-from-shell-initialize)


;; copied shamelessly from spacemacs
(require 'cider)
(defun cider-eval-in-repl-no-focus (form)
  "Insert FORM in the REPL buffer and eval it."
  (while (string-match "\\`[ \t\n\r]+\\|[ \t\n\r]+\\'" form)
    (setq form (replace-match "" t t form)))
  (with-current-buffer (cider-current-repl-buffer)
    (let ((pt-max (point-max)))
      (goto-char pt-max)
      (insert form)
      (indent-region pt-max (point))
      (cider-repl-return))))

(defun cider-send-last-sexp-to-repl ()
  "Send last sexp to REPL and evaluate it without changing the focus."
  (interactive)
  (cider-eval-in-repl-no-focus (cider-last-sexp)))

(add-hook 'markdown-mode-hook '(lambda () (setq visual-line-mode t)))


;; rust
(defun rust-mode-hooks ()
  (local-set-key (kbd "C-c <tab>") #'rust-format-buffer)
  (key-chord-define rust-mode-map ",," 'rustic-cargo-run)
  (key-chord-define rust-mode-map "--" 'rustic-cargo-build)
  (key-chord-define rust-mode-map "#ä" 'rustic-cargo-fmt)
  (key-chord-define rust-mode-map "#ü" 'rustic-cargo-check)
  (racer-mode)
  (flycheck-rust-setup))

(setq racer-cmd "~/.cargo/bin/racer") ;; Rustup binaries PATH
(setq racer-rust-src-path "/home/konrad/src/extern/rust/src") ;; Rust source code PATH

(add-hook 'rust-mode-hook 'rust-mode-hooks)
(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'racer-mode-hook #'company-mode)

(require 'paren)
(set-face-background 'show-paren-match "#ffb86c") ;; (face-background 'default)
(set-face-foreground 'show-paren-match "#282a36")
(set-face-attribute 'show-paren-match nil :weight 'extra-bold)

(require 'centaur-tabs)
(global-set-key (kbd "M-<prior>")  'centaur-tabs-backward)
(global-set-key (kbd "M-<next>") 'centaur-tabs-forward)
(setq centaur-tabs-style "bar")
(setq centaur-tabs-set-icons t)
(setq centaur-tabs-gray-out-icons 'buffer)
(setq centaur-tabs-set-bar 'left)
(setq centaur-tabs-set-modified-marker nil)

(global-set-key (kbd "s-<delete>") 'kill-current-buffer)
(global-set-key (kbd "s-<end>") '+workspace/close-window-or-workspace)

(centaur-tabs-group-by-projectile-project)
