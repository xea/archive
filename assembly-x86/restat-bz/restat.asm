maxobj equ 256

.286
code    segment use16
assume  cs:code, ds:code
org     100h
start:
                mov     bx, offset @last
                shr     bx, 4
                inc     bx
                push    cs
                pop     es
                mov     ah, 4ah
                int     21h
                mov     ah, 48h
                mov     bx, 1024
                int     21h
                mov     ss, ax
                mov     sp, 16382
                call    init
                call    proba2
                mov     ah,0
                int     16h
                call    exit

proba1          proc
                ret
proba1          endp

proba2          proc
                call mainscreen
                mov bx,offset probawin
                push cs
                pop ds
                call window_open
                mov bx,offset proba3win
                push cs
                pop ds
                call window_open
                mov bx,offset proba2win
                push cs
                pop ds
                call window_open
                call mouson
                call vezerlo
                call mousoff
                ret
proba2 endp

moustest proc
                call resetvisible
                mov ax,3
                int 33h
                shr cx,3
                shr dx,3
mt00:           mov cs:[mousoldx],cx
                mov cs:[mousoldy],dx
                call moussave
                mov ax,0
                add cx,cs:[x0screen]
                add dx,cs:[y0screen]
                dec cx
                call ssysdraw
mt02:           mov ax,3
                int 33h
                shr cx,3
                shr dx,3
                cmp cx,cs:[mousoldx]
                jnz mt10
                cmp dx,cs:[mousoldy]
                jnz mt10
                mov ah,1
                int 16h
                jz mt02
                ret
mt10:           push cx
                push dx
                mov cx,cs:[mousoldx]
                mov dx,cs:[mousoldy]
                call mousrestor
                pop dx
                pop cx
                jmp mt00
moustest endp

                INCLUDE SYS
                INCLUDE MEM
                INCLUDE MESSAGES
                INCLUDE INI
                INCLUDE PAK
                INCLUDE INTERRUPT
                INCLUDE FUNCTION
                INCLUDE GFX
                INCLUDE VEZERLO


Probawin dw 31+8000h, 69+8000h, 538, 360
         db 26h, 14
         dw offset probaszov, 0, 0, 1024, 768,0
         dw -1

Proba3win dw 351+8000h, 249+8000h, 160, 120
         db 04h, 16
         dw offset probaszov3, 0, 0, 156, 116, 0
         dw -1


probaszov db 'Window Manager'
probaszov3 db 'Screen Navigator'
gmbszov0 db '  OK',0
gmbszov1 db ' M�gse',0
gmbszov2 db ' M�gis',0
szov db 'Kapcs1',13,10,'Kapcs2',13,10,'Kapcs3',13,10,'Radio1',13,10,'Radio2',0

Proba2win dw 70+8000h, 400+8000h, 138, 114, 825h
         dw offset proba2szov, 0, 0 ,320, 320,0
         dw 2, 8, 8, 50, 16, offset gmbszov0, 6 dup(0)
         dw 2, 8, 27, 50, 16, offset gmbszov1, 6 dup(0)
         dw 2, 8, 46, 50, 16, offset gmbszov2, 6 dup(0)
         dw 2, 8, 65, 50, 16, offset gmbszov0, 6 dup(0)
         dw 5, 64, 8, 9 dup (0)
         dw 105h, 64, 24, 9 dup (0)
         dw 105h, 64, 40, 9 dup (0)
         dw 6, 64, 56, 9 dup (0)
         dw 106h, 64, 72, 9 dup (0)
         dw 8, 80, 8, 0,0, offset szov, 6 dup (0)
         dw -1


proba2szov db 'H�lyes�g'

@last:
                code    ends
                end     start       