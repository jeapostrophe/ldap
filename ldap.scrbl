#lang scribble/doc
@(require unstable/scribble
          scribble/manual
          (for-label racket
                     unstable/contract
                     "main.rkt"))

@title{LDAP}
@author{@(author+email "Jay McCarthy" "jay@racket-lang.org")}

@defmodule/this-package[]

This module contains a haphazard implementation of @link["http://en.wikipedia.org/wiki/LDAP"]{LDAP} Authentication. It is unprincipled, cobble together, and only tested on one LDAP server.

@defproc[(ldap-authenticate [server string?] [port port-number?] [user-dn string?] [password string?])
         boolean?]{
 Returns @racket[#t] if @racket[server] successfully BINDs when given @racket[user-dn] and @racket[password].
}
                  
                  