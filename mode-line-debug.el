;;; mode-line-debug.el --- show status of `debug-on-error' in the mode line

;; Copyright (C) 2012  Jonas Bernoulli

;; Author: Jonas Bernoulli <jonas@bernoul.li>
;; Created: 20120526
;; Version: 1.0.1
;; Homepage: https://github.com/tarsius/mode-line-debug
;; Keywords: convenience, lisp

;; This is a beta release.  Version numbers are inspired by how
;; Emacs is versioned - 1.1.0 will be the first stable version.

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

;; Show the status of `debug-on-error' in the mode line.

;;; Code:

(defconst mode-line-debug
  '(:eval
    (cond (debug-on-error
           (propertize
            "?" 'help-echo "Debug on Error is enabled\nmouse-1 toggle"
            'mouse-face 'mode-line-highlight
            'local-map (purecopy (make-mode-line-mouse-map
                                  'mouse-1 #'toggle-debug-on-error))))
          (t
           (propertize
            " " 'help-echo "Debug on Error is disabled\nmouse-1 toggle"
            'mouse-face 'mode-line-highlight
            'local-map (purecopy (make-mode-line-mouse-map
                                  'mouse-1 #'toggle-debug-on-error)))))))


(put 'mode-line-debug 'risky-local-variable t)
(make-variable-buffer-local 'mode-line-debug)

;;;###autoload
(define-minor-mode mode-line-debug-mode
  "Mode to show the status of `debug-on-error' in the mode line."
  :global t
  (set-default 'mode-line-modes
               (if mode-line-debug-mode
                   (cons mode-line-debug mode-line-modes)
                 (delete mode-line-debug mode-line-modes))))

(provide 'mode-line-debug)
;; Local Variables:
;; indent-tabs-mode: nil
;; End:
;;; mode-line-debug.el ends here
