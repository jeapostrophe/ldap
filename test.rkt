#lang racket
(require "main.rkt"
         tests/eli-tester)

(define (authenticate server port rdn passwd)
  (define db (ldap-connect server port))
  (ldap-bind db rdn passwd))

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
           (authenticate "ldap://ldap.byu.edu" 389 (format "uid=~a,ou=People,o=BYU.edu" u) p)))
 
 (get-up "BYU CS"
         (λ (u p) 
           (authenticate "ldap://ldap.cs.byu.edu" 389 (format "uid=~a,ou=people,dc=cs,dc=byu,dc=edu" u) p))))