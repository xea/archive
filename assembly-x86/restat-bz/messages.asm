message         proc
                push    ds
                push    ax
                push    cs
                pop     ds
                mov     ah, 9
                int     21h
                pop     ax
                pop     ds
                ret
message         endp

introscreen     proc
                mov     ax, 3
                int     10h
                mov     dx, offset mesg7sz
                call    message
                ret
introscreen     endp

entercode       db      13, 10, '$'

err0sz          db      '#ERR0: Memory allocation error.', 13, 10, '$'

mesg0sz         db      ' OK', 13, 10, '$'
mesg1sz         db      ' detected.', 13, 10, '$'
mesg2sz         db      ' not detected.', 13, 10, '$'
mesg4sz         db      'XMS driver$'
mesg5sz         db      'Free extended memory: $'
mesg6sz         db      ' byte(s).', 13, 10, '$'
mesg7sz         db      'ReStation researching system v0.1 (c) Zolt n B cskai 2000.', 13, 10
                db      59 dup('-'), 13, 10, '$'
mesg8sz         db      'Error installing graphics driver: $'
mesg8bsz        db      '.',13,10,'Please run config!',13,10,'$'   