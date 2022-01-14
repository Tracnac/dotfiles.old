;; Cosmetique
(setq inhibit-startup-message t)

(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)

(set-fringe-mode 10)
(setq visible-bell nil)
(setq ring-bell-function 'ignore)

(load-theme 'misterioso)
(set-default 'cursor-type '(hbar . 2))
(set-face-attribute 'default nil :font "Fantasque Sans Mono" :height 120)
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
;; (straight-use-package 'projectile)
;; (straight-use-package 'counsel)
;; (straight-use-package 'magit)
;; (straight-use-package 'eshell)
;; (straight-use-package 'helpful)
(straight-use-package 'smartparens)
(straight-use-package 'rainbow-delimiters)
(straight-use-package 'telephone-line)
;; (straight-use-package 'notmuch)
;;(straight-use-package 'exwm)
(straight-use-package
  '(nano-emacs :type git :host github :repo "rougier/nano-emacs"))

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

;;
;;(require 'projectile)
;;(projectile-mode)
;;
;;(require 'magit)
;;;; (magit-mode)
;;
;;(require 'counsel)
;;(counsel-mode)
;;
;;(require 'helpful)
;;
;;(require 'notmuch)
;;(setq send-mail-function 'sendmail-send-it
;;      sendmail-program "/usr/bin/msmtp"
;;      mail-specify-envelope-from t
;;      message-sendmail-envelope-from 'header
;;      mail-envelope-from 'header)
;;
(require 'smartparens)
(smartparens-mode)
;;
(require 'rainbow-delimiters)
(rainbow-delimiters-mode)
;;
;;(require 'exwm)
;;(require 'exwm-config)
;;(exwm-config-default)

(require 'nano-faces)
(require 'nano-base-colors)
(nano-faces)

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

;; Don't want scratch file
(setq initial-major-mode (quote text-mode))
(setq initial-buffer-choice 'new-empty-buffer)

(defun new-empty-buffer ()
  (interactive)
  (let (($buf (generate-new-buffer "untitled")))
    (switch-to-buffer $buf)
    (funcall initial-major-mode)
    (setq buffer-offer-save t)
    $buf
    ))

;; Just for fun...
;; My Keybindings
(use-global-map (make-keymap))
(global-set-key [t] #'self-insert-command)
;; Need to restore the standard keys...
(let ((c ?\s))
  (while (< c ?\d)
    (global-set-key (vector c) #'self-insert-command)
    (setq c (1+ c)))
  (when (eq system-type 'ms-dos)
    (setq c 128)
    (while (< c 160)
      (global-set-key (vector c) #'self-insert-command)
      (setq c (1+ c))))
  (setq c 160)
  (while (< c 256)
    (global-set-key (vector c) #'self-insert-command)
    (setq c (1+ c))))


;; [(control ?h)]
;; [delete]


(defun reload-dotemacs ()
  (interactive)
  (load-file "~/.emacs.d/init.el"))
(global-set-key (kbd "<f12>") 'reload-dotemacs)

(global-set-key (kbd "C-w") 'kill-emacs)
(global-set-key (kbd "C-b k") 'kill-buffer)

(global-set-key (kbd "RET") 'newline)
(global-set-key (kbd "<return>") 'newline)

(global-set-key (kbd "<tab>") 'forward-button)
(global-set-key (kbd "TAB") 'forward-button)

(global-set-key [delete] 'delete-forward-char)
(global-set-key (kbd "<S-delete>") 'kill-word)
(global-set-key (kbd "<backspace>") 'backward-delete-char-untabify)
(global-set-key (kbd "DEL") 'backward-delete-char-untabify)
(global-set-key (kbd "S-<backspace>") 'backward-kill-word)
(global-set-key (kbd "S-DEL") 'backward-kill-word)

(global-set-key (kbd "<escape>") 'keyboard-quit)
(global-set-key (kbd "<pause>") 'execute-extended-command)

(global-set-key (kbd "<up>") 'previous-line)
(global-set-key (kbd "<down>") 'next-line)
(global-set-key (kbd "<left>") 'left-char)
(global-set-key (kbd "S-<left>") 'backward-word)
(global-set-key (kbd "C-<left>") 'move-beginning-of-line)
(global-set-key (kbd "<right>") 'right-char)
(global-set-key (kbd "S-<right>") 'forward-word)
(global-set-key (kbd "C-<right>") 'move-end-of-line)
