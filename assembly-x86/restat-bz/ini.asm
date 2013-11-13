;Initialize

Init            proc
                call    introscreen
                call    meminst
                jc      @initerr
                call    cfgload
                call    altini
                call    proba1
                call    gfxmode
                call    mousini
                call    fontini
                ret
@initerr:       mov     ah, 4ch
                int     21h
Init            endp

Mousini         proc
                mov     dx, cs:[mousegm]
                mov     es, dx
                xor     di, di
                mov     dx, offset mainfilnam
                mov     al, 0
                call    sysload
                ret
Mousini         endp

Cfgload         proc
                push    cs
                pop     ds
                jmp     cfg01                              ;Majd kit”r”lni!!!!
                mov     ax, 3d00h
                mov     dx, offset cfgfilnam
                int     21h
                mov     bx, ax
                mov     ah, 3fh
                mov     dx, offset config
                mov     cx, 3                              ;Hossz
                int     21h
cfg01:
                mov     dx, cs:[grdrsegm]
                mov     al, cs:[grfcard]                   ;Videocard driver load
                mov     es, dx
                xor     di, di
                mov     dx, offset gdfilnam
                call    sysload
                mov     bx, cx
                mov     cl, 4
                shr     bx, cl
                inc     bx
                mov     ah, 4ah
                mov     dx, cs:[grdrsegm]
                mov     es, dx
                int     21h
                ret
Cfgload         endp

Cfgsave         proc

                ret
Cfgsave         endp

Fontini         proc
                mov     ax, cs:[fontsegm]
                mov     es, ax
                xor     di, di
                mov     dx, offset mainfilnam
                mov     al, 1
                call    sysload
                ret
Fontini         endp

Altini          proc
                call    menureset
                ret
Altini          endp

Menureset       proc
                mov     ax, cs:[menusegm]
                mov     es, ax
                xor     di, di
                mov     dx, offset mainfilnam
                mov     al, 2
                call    sysload
                mov     ax, cs:[menusegm]
                mov     es, ax
                xor     bx, bx
menurst00:      mov     cx, es:[bx]
                cmp     cx, 1
                jnz     menurst02
                mov     es:[bx], ax
menurst02:      add     bx, 2
                cmp     bx, 8*8
                jc      menurst00
                ret
Menureset       endp

Exit            proc
                call txtmode

                mov ah,3ch
                xor cx,cx
                push cs
                pop ds
                mov dx,offset debugname
                int 21h
                mov bx,ax
                mov ax,cs:[debugsegm]
                mov ds,ax
                xor dx,dx
                mov cx,cs:[debugpoint]
                mov ah,40h
                int 21h
                mov ah,3eh
                int 21h

                mov ah,4ch
                int 21h
Exit            endp

Config  label byte

Grfcard         db      0
Grmodnum        db      0
Grfhi           db      0

Syscolors       db      3fh,3fh,3fh       ;Panel color, dark
                db      7fh,7fh,7fh       ;Panel color, med1
                db      070h,0a4h,0ffh    ;Panel color, med2
                db      0bfh,0bfh,0bfh    ;Panel color, light
                db      0,3fh,16h         ;Desktop color

cfgfilnam       db      'RESTAT.CFG', 0
sysfilnum       db      2

sysfiles label byte
gdfilnam        db      'GFXDRVS.MPK', 0, 0, 0, 0, 0
mainfilnam      db      'RESTAT.MPK' , 0, 0, 0, 0, 0, 0
