;Header and description

(define (domain shoe)

;remove requirements that are not needed
; (:requirements :strips :fluents :durative-actions :timed-initial-literals :typing :conditional-effects :negative-preconditions :duration-inequalities :equality)
(:requirements :strips :negative-preconditions :typing :fluents :equality)

(:types ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
    eyelet_left eyelet_right - eyelet
    aglet
    site
)

; un-comment following line if constants are needed
(:constants 
    aglet_a aglet_b - aglet
    site_left site_right - site
)

(:predicates ;todo: define predicates here
    (cursor_a ?el - eyelet)
    (cursor_b ?el - eyelet)    
    (aglet_at ?al - aglet ?s - site)
    (eyelet_laced ?el - eyelet)
    (next ?el_s - eyelet ?el_t - eyelet)
)

(:functions ;todo: define numeric functions here
    (id ?el - eyelet)
)

; ACTION DEFINITIONS
(:action left_insert_a
    :parameters (?el - eyelet_left ?el_n - eyelet ?c_b - eyelet)
    :precondition (and
        (cursor_a ?el)
        (cursor_b ?c_b)
        (next ?el ?el_n)
        (> (id ?c_b) (id ?el))
        (aglet_at aglet_a site_left)
    )
    :effect (and
        (eyelet_laced ?el)
        (cursor_a ?el_n)
        (not (cursor_a ?el))
    )
)

(:action left_insert_b
    :parameters (?el - eyelet_left ?el_n - eyelet ?c_a - eyelet)
    :precondition (and
        (cursor_a ?c_a)
        (cursor_b ?el)
        (next ?el ?el_n)
        (> (id ?c_a) (id ?el))
        (aglet_at aglet_b site_left)
    )
    :effect (and 
        (eyelet_laced ?el)
        (cursor_b ?el_n)
        (not (cursor_b ?el))
    )
)

(:action right_insert_a
    :parameters (?el - eyelet_right ?el_n - eyelet ?c_b - eyelet)
    :precondition (and
        (cursor_a ?el)
        (cursor_b ?c_b)
        (next ?el ?el_n)
        (> (id ?c_b) (id ?el))
        (aglet_at aglet_a site_right)
    )
    :effect (and 
        (eyelet_laced ?el)
        (cursor_a ?el_n)
        (not (cursor_a ?el))
    )
)

(:action right_insert_b
    :parameters (?el - eyelet_right ?el_n - eyelet ?c_a - eyelet)
    :precondition (and
        (cursor_a ?c_a)
        (cursor_b ?el)
        (next ?el ?el_n)
        (> (id ?c_a) (id ?el))
        (aglet_at aglet_b site_right)
    )
    :effect (and 
        (eyelet_laced ?el)
        (cursor_b ?el_n)
        (not (cursor_b ?el))
    )
)

(:action left_to_right_transfer
    :parameters (?al - aglet)
    :precondition (and 
        (aglet_at ?al site_left)
    )
    :effect (and 
        (aglet_at ?al site_right)
        (not (aglet_at ?al site_left))
        
    )
)

(:action right_to_left_transfer
    :parameters (?al - aglet)
    :precondition (and
        (aglet_at ?al site_right)
    )
    :effect (and
        (aglet_at ?al site_left)
        (not (aglet_at ?al site_right))
    )
)

)