;; Cosmetique
(setq inhibit-startup-message t)

(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)

(set-fringe-mode 10)
(setq visible-bell nil)

(load-theme 'misterioso)
(set-default 'cursor-type '(hbar . 2))
(set-face-attribute 'default nil :font "FantasqueSansMono Nerd Font" :height 90)
(set-cursor-color "#FFB300")

;; Comportement par défaut
(setq inhibit-compacting-font-caches t)
(setq find-file-visit-truename t)
(setq user-full-name "Tracnac")
(setq user-mail-address "tracnac@devmobs.fr")
;; 
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
(straight-use-package 'projectile)
(straight-use-package 'counsel)
(straight-use-package 'magit)
(straight-use-package 'eshell)
(straight-use-package 'helpful)
(straight-use-package 'smartparens)
(straight-use-package 'rainbow-delimiters)
(straight-use-package 'telephone-line)
(straight-use-package 'notmuch)
;;(straight-use-package 'exwm)

;; Initialisation
(require 'telephone-line)
(setq telephone-line-lhs
      '((evil   . (telephone-line-evil-tag-segment))
	(accent . (telephone-line-vc-segment
		   telephone-line-erc-modified-channels-segment
		   telephone-line-process-segment))
	(nil    . (telephone-line-minor-mode-segment
		   telephone-line-buffer-segment))))
(setq telephone-line-rhs
      '((nil    . (telephone-line-misc-info-segment))
	(accent . (telephone-line-major-mode-segment))
	(evil   . (telephone-line-airline-position-segment))))

(setq telephone-line-evil-use-short-tag t)

(telephone-line-mode 1)

(require 'projectile)
(projectile-mode)

(require 'magit)
;; (magit-mode)

(require 'counsel)
(counsel-mode)

(require 'helpful)

(require 'notmuch)
(setq send-mail-function 'sendmail-send-it
      sendmail-program "/usr/bin/msmtp"
      mail-specify-envelope-from t
      message-sendmail-envelope-from 'header
      mail-envelope-from 'header)

(require 'smartparens)
(smartparens-mode)

(require 'rainbow-delimiters)
(rainbow-delimiters-mode)

;;(require 'exwm)
;;(require 'exwm-config)
;;(exwm-config-default)

;; Bienvenue et duration
(let ((inhibit-message t))
     (message "Welcome to GNU Emacs T R /\\ C N /\\ C. Edition")
     (message (format "Initialization time: %s" (emacs-init-time))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
)
