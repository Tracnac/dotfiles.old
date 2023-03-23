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
;; Les "Must Have" paquets
;; (straight-use-package 'projectile)
;; (straight-use-package 'counsel)
(straight-use-package 'magit)
;; (straight-use-package 'eshell)
;; (straight-use-package 'helpful)
(straight-use-package 'smartparens)
(straight-use-package 'rainbow-delimiters)
;; (straight-use-package 'notmuch)
;; (straight-use-package 'exwm)
(straight-use-package
 '(nano-emacs :type git :host github :repo "rougier/nano-emacs"))

;; Cosmetique
(setq inhibit-startup-message t)
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
(prefer-coding-system 'utf-8-unix)
(set-language-environment "UTF-8") 
(setq iso-transl-char-map nil)
(fset 'yes-or-no-p #'y-or-n-p)
(fset 'display-startup-echo-area-message #'ignore)

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

(setq ring-bell-function #'ignore
      inhibit-startup-screen t
      initial-scratch-message (format "Welcome to GNU Emacs T R /\\ C N /\\ C. Edition\nInitialization time: %s\n\n" (emacs-init-time)))
