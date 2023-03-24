;; Packages
(setq package-enable-at-startup nil)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq packages-list '(magit
                      smartparens
                      rainbow-delimiters
                      ;; projectile
                      ;; counsel
                      ;; notmuch
                      ;; eshell
                      helpful
                      ;; exwm
                      ))

(dolist (package packages-list)
  (straight-use-package package))

(straight-use-package
 '(nano-emacs :type git :host github :repo "rougier/nano-emacs"))

;; Cosmetique
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'menu-bar-mode)
  (menu-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))
(when (fboundp 'tooltip-mode)
  (tooltip-mode -1))
(when (fboundp 'set-fringe-mode)
  (set-fringe-mode 8))

(setq-default
 inhibit-startup-screen t
 inhibit-startup-message t
 inhibit-startup-echo-area-message t
 initial-buffer-choice t
 ring-bell-function #'ignore)

(setq visible-bell nil)
(setq ring-bell-function 'ignore)

;; (load-theme 'dichromacy)
(set-default 'cursor-type '(hbar . 2))
(set-cursor-color "black")

;; Comportement par défaut
(setq inhibit-compacting-font-caches t)
(setq find-file-visit-truename t)

(setq user-full-name "Tracnac")
(setq user-mail-address "tracnac@devmobs.fr")

(set-default-coding-systems 'utf-8)     ; Default to utf-8 encoding
(prefer-coding-system       'utf-8)     ; Add utf-8 at the front for automatic detection.
(set-terminal-coding-system 'utf-8)     ; Set coding system of terminal output
(set-keyboard-coding-system 'utf-8)     ; Set coding system for keyboard input on TERMINAL
(set-language-environment "English")    ; Set up multilingual environment
(setq iso-transl-char-map nil)

(fset 'yes-or-no-p #'y-or-n-p)
(fset 'display-startup-echo-area-message #'ignore)

(setq auto-save-list-file-prefix ; Prefix for generating auto-save-list-file-name
      (expand-file-name ".auto-save-list/.saves-" user-emacs-directory)
      auto-save-default t        ; Auto-save every buffer that visits a file
      auto-save-timeout 20       ; Number of seconds between auto-save
      auto-save-interval 200)    ; Number of keystrokes between auto-saves
(setq bookmark-default-file (expand-file-name "bookmark" user-emacs-directory))

(defun unpropertize-kill-ring ()
  (setq kill-ring (mapcar 'substring-no-properties kill-ring)))
(add-hook 'kill-emacs-hook 'unpropertize-kill-ring)

(require 'savehist)

(setq kill-ring-max 50
      history-length 50)

(setq savehist-additional-variables
      '(kill-ring
        command-history
        set-variable-value-history
        custom-variable-history   
        query-replace-history     
        read-expression-history   
        minibuffer-history        
        read-char-history         
        face-name-history         
        bookmark-history
        file-name-history))

(put 'minibuffer-history         'history-length 50)
(put 'file-name-history          'history-length 50)
(put 'set-variable-value-history 'history-length 25)
(put 'custom-variable-history    'history-length 25)
(put 'query-replace-history      'history-length 25)
(put 'read-expression-history    'history-length 25)
(put 'read-char-history          'history-length 25)
(put 'face-name-history          'history-length 25)
(put 'bookmark-history           'history-length 25)
(setq history-delete-duplicates t)
(let (message-log-max)
  (savehist-mode))

;; Theme
(setq nano-font-size 10)
(setq nano-font-family-monospaced "VictorMono Nerd Font")
(setq nano-font-family-proportional "VictorMono Nerd Font")
(require 'nano-theme-dark)
(require 'nano)

;;(require 'projectile)
;;(projectile-mode)

(require 'magit)
;; (magit-mode)

;;(require 'counsel)
;;(counsel-mode)

;;(require 'helpful)

;;(require 'notmuch)
;;(setq send-mail-function 'sendmail-send-it
;;      sendmail-program "/usr/bin/msmtp"
;;      mail-specify-envelope-from t
;;      message-sendmail-envelope-from 'header
;;      mail-envelope-from 'header)
;;

(require 'smartparens)
(add-hook 'prog-mode-hook #'smartparens-mode)

(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;;(require 'exwm)
;;(require 'exwm-config)
;;(exwm-config-default)
(setq
 initial-scratch-message (format "Welcome to GNU Emacs T R /\\ C N /\\ C. Edition\nInitialization time: %s\n\n" (emacs-init-time)))
