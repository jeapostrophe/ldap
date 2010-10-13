#lang racket
(require "main.rkt"
         tests/eli-tester)

(define (get-up prompt k)
  (printf "~a > username: " prompt)
  (flush-output)
  (define u (read-line))
  (printf "~a > passsword " prompt)
  (flush-output)
  (define p (read-line))
  (k u p))

(test
 (get-up "Route Y"
         (λ (u p)
           (ldap-authenticate "ldap.byu.edu" 389 (format "uid=~a,ou=People,o=byu.edu" u) p)))
 =>
 #t
 
 (ldap-authenticate "ldap.byu.edu" 389 (format "uid=~a,ou=People,o=byu.edu" "bad") "password")
 =>
 #f
 
 (ldap-authenticate "ldap.byu.edu" 389 (format "uid=~a,ou=People,o=byu.edu" "jaymcc") "password")
 =>
 #f)