; substitute.scm

; Utility to substitute atoms in a graph according to given mapping of terms
; to be substituted.

; Usage
;(define term (VariableNode "$A"))
(define term pln-rule-member-to-subset)
(define subst-map (make-hash-table 10))
(hash-set! subst-map (VariableNode "$A") (ConceptNode "apple"))
;(substitute term subst-map)


(define (substitute term subst-map)
    (define outgoing #f)
    ;(display "substitute() term: ")(display term)
    ;(display "subst-map: ")(display subst-map)(newline)
    (cond
          ; handle term is in substitution map
          ((hash-ref subst-map term) (begin
                ;(display "pre-outgoing: ")(display outgoing)(newline)
                (set! outgoing (hash-ref subst-map term))
                ;(display "outgoing: ")(display outgoing)
          ))

          ; handle term is a link
          ((> (length (cog-outgoing-set term)) 0) (begin
            ;(display "link")(newline)
            ;(set! outgoing (cog-new-link (cog-type term) (cog-outgoing-set term)))
            ;(set! outgoing (substitute (list-ref (cog-outgoing-set term) 1) subst-map))
             (let ((subterms (map substitute (cog-outgoing-set term)
                        (make-list (length (cog-outgoing-set term)) subst-map))))

                    ; if term is VariableList, remove any concept nodes from list
                    (if (eq? (cog-type term) 'VariableList)
                        (begin
                            ;(display "--- found VariableList ---\n")
                            ;(display subterms)(newline)
                            ;(for-each (lambda(x)
                            ;    (display x)(display " -type-> ")(display (cog-type x))(newline)
                            ;    (display (eq? (cog-type x) 'VariableNode)) (newline))
                            ;    subterms)
                            (set! subterms (filter (lambda(x) (eq? (cog-type x) 'VariableNode))
                                            subterms))
                        ))
                    ;(display "subterms: ")(display subterms)(newline)
                    ;(display "link type: " ) (display (cog-type term))(newline)
                    (set! outgoing (cog-new-link (cog-type term) subterms))
             )
          ))

          ; handle term is a node (or empty link)
          ((= (length (cog-outgoing-set term)) 0) (begin
                ;(display "node")(newline)(display term)
                (set! outgoing term)
                ;(display "outgoing: " )(display outgoing)
           ))
    )
    ;(display "post-outgoing: ")(display outgoing)(newline)
    outgoing
)






