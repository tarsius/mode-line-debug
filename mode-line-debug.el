;;; mode-line-debug.el --- show status of `debug-on-error' in the mode-line

;; Copyright (C) 2012  Jonas Bernoulli

;; Author: Jonas Bernoulli <jonas@bernoul.li>
;; Created: 20120526
;; Version: 1.1.0
;; Homepage: https://github.com/tarsius/mode-line-debug
;; Keywords: convenience, lisp

;; This file is not part of GNU Emacs.

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; For a full copy of the GNU General Public License
;; see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Show the status of `debug-on-error' in the mode-line.

;; This provides Mode-Line-Debug mode whidh depending on the state of
;; `debug-on-error' inserts a different string into the mode-line
;; before the list of active modes.  The inserted character can be
;; used to toggle the state of `debug-on-error' can be customized
;; using `mode-line-debug-strings'.

;;; Code:

;;;###autoload
(define-minor-mode mode-line-debug-mode
  "Mode to show the status of `debug-on-error' in the mode-line.

Depending on the state of `debug-on-error' this mode inserts a
different string into the mode-line before the list of active
modes.  The inserted character can be used to toggle the state of
`debug-on-error'."
  :global t
  :group 'mode-line
  ;; We cannot insert `mode-line-debug' but have to insert it's value
  ;; because we insert at the head of `mode-line-modes'. A list whose
  ;; car is a symbol is interpreted as (CONDITION THEN ELSE).
  (setq mode-line-modes (delete mode-line-debug mode-line-modes))
  (when mode-line-debug-mode
    (setq mode-line-modes (cons mode-line-debug mode-line-modes))))

(defcustom mode-line-debug-strings '("?" . " ")
  "Strings indicating the state of `debug-on-error' in the mode-line.

The car is used when `debug-on-error' is off, the cdr when it is
off.  For the off state a string consisting of one space makes
most sense; this avoids cluttering the mode-line but still allows
clicking before the list of modes to toggle `debug-on-error'.

Also see `mode-line-debug-mode' which has to be enabled for this
to have any effect."
  :group 'mode-line
  :type '(cons (string :tag "On Indicator")
               (string :tag "Off Indicator")))

(defconst mode-line-debug
  '(mode-line-debug-mode (:eval (mode-line-debug-control))))

(defun mode-line-debug-control ()
  (cond (debug-on-error
         (propertize
          (car mode-line-debug-strings)
          'help-echo "Debug on Error is enabled\nmouse-1 toggle"
          'mouse-face 'mode-line-highlight
          'local-map (purecopy (make-mode-line-mouse-map
                                'mouse-1
                                #'mode-line-toggle-debug-on-error))))
        (t
         (propertize
          (cdr mode-line-debug-strings)
          'help-echo "Debug on Error is disabled\nmouse-1 toggle"
          'mouse-face 'mode-line-highlight
          'local-map (purecopy (make-mode-line-mouse-map
                                'mouse-1
                                #'mode-line-toggle-debug-on-error))))))

(defun mode-line-toggle-debug-on-error (event)
  "Toggle `debug-on-error' from the mode-line."
  (interactive "e")
  (with-selected-window (posn-window (event-start event))
    (toggle-debug-on-error)
    (force-mode-line-update)))

(put 'mode-line-debug 'risky-local-variable t)
(make-variable-buffer-local 'mode-line-debug)

(provide 'mode-line-debug)
;; Local Variables:
;; indent-tabs-mode: nil
;; End:
;;; mode-line-debug.el ends here
