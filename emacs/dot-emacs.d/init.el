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
;;(straight-use-package 'exwm)

;; Add mu4e to the load-path:
(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")
(require 'mu4e)
(setq mu4e-drafts-folder "/Drafts")
(setq mu4e-sent-folder   "/Sent Items")
(setq mu4e-trash-folder  "/Trash")
(setq mu4e-get-mail-command "mbsync --config ~/.mbsyncrc mailfence")
(setq mu4e-html2text-command "w3m -T text/html" ; how to hanfle html-formatted emails
      mu4e-update-interval 300                  ; seconds between each mail retrieval
      mu4e-headers-auto-update t                ; avoid to type `g' to update
      mu4e-view-show-images t                   ; show images in the view buffer
      mu4e-compose-signature-auto-include nil   ; I don't want a message signature
      mu4e-use-fancy-chars t)                   ; allow fancy icons for mail threads
(setq mu4e-compose-reply-ignore-address '("no-?reply" "tracnac@devmobs.fr"))
(setq message-citation-line-function 'message-insert-formatted-citation-line)
(setq message-citation-line-format "Le %Y-%m-%d à %T %Z, %f a écrit :\n")

;; Initialisation
(require 'telephone-line)
(setq telephone-line-primary-left-separator 'telephone-line-cubed-left
      telephone-line-secondary-left-separator 'telephone-line-cubed-hollow-left
      telephone-line-primary-right-separator 'telephone-line-cubed-right
      telephone-line-secondary-right-separator 'telephone-line-cubed-hollow-right)
(setq telephone-line-height 24
      telephone-line-evil-use-short-tag t)
(telephone-line-mode 1)

(require 'projectile)
(projectile-mode)

(require 'magit)
;; (magit-mode)

(require 'counsel)
(counsel-mode)

(require 'helpful)

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
 '(smtpmail-smtp-server "smtp.mailfence.com")
 '(smtpmail-smtp-service 465))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
