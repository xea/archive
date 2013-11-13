;Graphic routines

vidseg          equ     0a000h                             ;Videomemory-segment
maxicon         equ     20
buttsbegin      equ     8

palgen256       proc
                push    es
                push    ds
                mov     ah, 48h
                mov     bx, 48
                int     21h
                mov     es, ax
                xor     ax, ax
                xor     di, di
                mov     bx, offset comps5
                mov     ah, 5
pal00:          push    ax
                mov     cx, offset comps10
                mov     ah, 10
pal01:          push    ax
                mov     dx, offset comps5
                mov     ah, 5
pal02:          mov     si, bx
                mov     al, ds:[si]
                stosb
                mov     si, cx
                mov     al, ds:[si]
                stosb
                mov     si, dx
                mov     al, ds:[si]
                stosb
                inc     dx
                dec     ah
                jnz     pal02
                pop     ax
                inc     cx
                dec     ah
                jnz     pal01
                pop     ax
                inc     bx
                dec     ah
                jnz     pal00
                push    es
                pop     ds
                xor     si, si
                mov     cx, 250*3
                mov     dx, 3c8h
                xor     al, al
                out     dx, al
                inc     dx
pal03:          lodsb
                out     dx, al
                loop    pal03
                mov     ah, 49h
                int     21h
                pop     ds
                pop     es
                ret
palgen256       endp

Syscolorgen proc
                push bx
                mov bl,cs:[grfhi]
                test bl,1
                jz syscolgen01
                call syscolorgenhi
                pop bx
                ret
syscolgen01:    call syscolorgen256
                pop bx
                ret
Syscolorgen endp

syscolorgen256  proc
                pusha
                push ds
                push cs
                pop ds
                mov si,offset syscolors
                mov cx,5*3
                mov dx,3c8h
                mov al,251
                out dx,al
                inc dx
syscolgen201:   lodsb
                shr al,2
                out dx,al
                loop syscolgen201
                pop ds
                popa
                ret
syscolorgen256  endp

syscolorgenhi   proc
                pusha
                mov si,offset syscolors
                mov di,offset colors+2
                mov cx,5
syscolgenh01:   mov dh,cs:[si]
                mov al,cs:[si+1]
                mov dl,cs:[si+2]
                call szinosszehi
                mov cs:[di],dx
                add si,3
                add di,2
                loop syscolgenh01
                xor dx,dx
                dec dx
                mov cs:[di],dx
                popa
                ret
syscolorgenhi   endp

szinszethi proc
;in: dx=color
;out: dh=R, dl=B, al=G
            push cx
            mov cx,dx
            and ch,00000111b
            shl ch,3
            shr cl,5
            or cl,ch
            mov al,cl
            and dh,11111000b
            and dl,00011111b
            shl dl,3
            shl al,2
            pop cx
            ret
szinszethi endp
szinosszehi proc
;in: dh=R, dl=B, al=G
;out: dx=color
            push cx
            mov cl,al
            shr cl,2
            mov ch,cl
            shr ch,3
            shl cl,5
            and dh,11111000b
            shr dl,3
            or dx,cx
            pop cx
            ret
szinosszehi endp

;!!!!!!!!!!!!!!!!!!!!
szinossze256 proc
;in: dh=R, dl=B, al=G
;out: dx[dl]=color
            ret
            push ax
            push cx
            push bx
            mov bl,64
            mov bh,10
            mov cl,5
            xor ah,ah
            mul bh
            div bl
            mul cl
            mov ch,al
            mov al,dl
            mul cl
            div bl
            add ch,al
            mov al,dh
            mul cl
            div bl
            mul bh
            mul cl
            add ch,al
            mov dl,ch
            xor dh,dh
            pop bx
            pop cx
            pop ax
            ret
szinossze256 endp

Gfxmode         proc                                       ;Set graphics mode
                mov     bx, cs:[grdrsegm]
                mov     cs:[vidcall+2], bx
                mov     es, bx
                xor     bx, bx
                mov     dx, es:[bx+2]
                mov     cs:[vidcall], dx
                mov     dx, es:[bx+6]
                mov     al, cs:[grfhi]
                test    al,1
                jz      gfxm01
                mov     dx,es:[bx+8]
gfxm01:         mov     bx, dx
                mov     dl, cs:[grmodnum]
                xor     dh, dh
                shl     dx, 2
                add     bx, dx
                mov     dx, es:[bx]
                mov     cs:[grfmode1], dx
                mov     dx, es:[bx+2]
                mov     cs:[grfmode2], dx
                mov     bl, cs:[grmodnum]
                xor     bh, bh
                shl     bx, 1
                shl     bx, 1
                add     bx, offset monsizes
                mov     dx, cs:[bx]
                mov     cs:[horsiz], dx
                mov     dx, cs:[bx+2]
                mov     cs:[versiz], dx
                push    es
                mov     ax, cs:[grfmode1]
                mov     bx, cs:[grfmode2]
                call    dword ptr cs:[vidcall]
                pop     es
                jc      gfxmerr
                xor     bx, bx
                mov     dx, es:[bx]
                mov     cs:[vidcall], dx
                xor     al, al
                dec     al
                mov     cs:[vmempage], al
                mov     bl,cs:[grfhi]
                test    bl,1
                jnz     gfxm02
                call    palgen256
gfxm02:         call    syscolorgen
                mov     ax, 7
                mov     dx, cs:[horsiz]
                mov     cl, 3
                shl     dx, cl
                dec     dx
                xor     cx, cx
                int     33h
                mov     ax, 8
                mov     dx, cs:[versiz]
                mov     cl, 3
                shl     dx, cl
                dec     dx
                xor     cx, cx
                int     33h
                mov     ax, 15
                mov     cx, 1
                mov     dx, 2
                int     33h
                ret
gfxmerr:        mov     dx, offset mesg8sz
                call    message
                push    ds
                mov     bx, cs:[grdrsegm]
                mov     ds, bx
                xor     bx,bx
                mov     dx, ds:[bx+10]
                mov     ah,9
                int     21h
                pop     ds
                mov     dx, offset mesg8bsz
                call    message
                call    escape
                ret
Gfxmode         endp

Txtmode         proc
                push    es
                mov     bx, cs:[grdrsegm]
                mov     cs:[vidcall+2], bx
                mov     es, bx
                xor     bx, bx
                mov     dx, es:[bx+4]
                mov     cs:[vidcall], dx
                call    dword ptr cs:[vidcall]
                mov     ax, 3
                int     10h
                pop     es
                ret
Txtmode         endp

lassit proc                             ;Szinkroniz l s a monitorfrekvenci hoz.
        push dx
        push ax
        mov dx,03dah
las00:  in al,dx
        and al,8
        jnz las00
las01:  in al,dx
        and al,8
        jz las01                        ;Csak fgg“leges visszafut s kezdet‚n
        pop ax                          ;enged rajzolni
        pop dx
        ret
lassit endp


Chbank          proc
;Change bank
;in:al=newbank
                cmp     al, cs:[vmempage]
                jz      chb9
                push    bx
                push    si
                push    di
                push    cx
                push    dx
                mov     cs:[vmempage], al
                call    dword ptr cs:[vidcall]
                pop     dx
                pop     cx
                pop     di
                pop     si
                pop     bx
chb9:           ret
Chbank          endp

Bankup          proc
;Change  to the next bank
                push    ax
                mov     al, cs:[vmempage]
                inc     al
                call    chbank
                pop     ax
                ret
Bankup          endp

Bankres         proc
                push ax
                xor al,al
                not al
                mov cs:[vmempage],al
                pop ax
                ret
Bankres         endp

Cls             proc
;Clear screen
;in:ax(al)=color
                push    dx
                push    bx
                call    bankres
                xor     di,di
                mov     bl, cs:[grfhi]
                test    bl, 1
                jz      clsc2
                call    clshi
                jmp     clsc9
clsc2:          call    cls256
clsc9:          pop     bx
                pop     dx
                ret
Cls             endp

Cls256          proc
;Clear screen
;in:al=color
                push    es
                push    ax
                xor     al, al
                call    chbank
                mov     ax, vidseg
                mov     es, ax
                mov     ax, cs:[horsiz]
                mov     dx, cs:[versiz]
                mul     dx
                mov     cx, ax
                pop     ax
                rep     stosb
cls1:           stosb
                cmp     di, 1
                jnc     cls2
                call    bankup
cls2:           loop    cls1
                dec     dx
                jnz     cls1
                pop     es
                ret
Cls256          endp

Clshi           proc
;Clear screen
;in:ax=color
                push    es
                push    ax
                xor     al, al
                call    chbank
                mov     ax, vidseg
                mov     es, ax
                mov     ax, cs:[horsiz]
                shl     ax, 1
                mov     dx, cs:[versiz]
                mul     dx
                mov     cx, ax
                shr     cx,1
                pop     ax
                rep     stosw
clsh1:          stosw
                cmp     di, 2
                jnc     clsh2
                call    bankup
clsh2:          loop    clsh1
                dec     dx
                jnz     clsh1
                pop     es
                ret
Clshi           endp


Quad            proc
;Draw a filled quad
;in:cx=x,dx=ykoord,ax=color,di=x,si=ysize
                push    bx
                push    cx
                push    dx
                push    si
                push    di
                push    ax
                call    bankres
                mov     bl,cs:[grfhi]
                test    bl,1
                jz      qud00b
                shl     cx,1
                shl     dx,1
qud00b:         mov     ax, cs:[horsiz]
                mul     dx
                add     ax, cx
                adc     dx, 0
                mov     cx, di
                mov     di, ax
                mov     al, dl
                call    chbank
                mov     ax, vidseg
                mov     es, ax
                pop     ax
qud01:          push    cx
                mov     bl,cs:[grfhi]
                test    bl,1
                jnz     qud02h
qud02:          stosb
                cmp     di, 1
                jnc     qud03
                call    bankup
qud03:          loop    qud02
                pop     cx
                jmp     qud05
qud02h:         stosw
                cmp     di, 2
                jnc     qud03h
                call    bankup
qud03h:         loop    qud02h
                pop     cx
qud05:          mov     dx, cs:[horsiz]
                sub     dx, cx
                add     di, dx
                jnc     qud06
                call    bankup
qud06:          mov     bl,cs:[grfhi]
                test    bl,1
                jz      qud07
                add     di,dx
                jnc     qud07
                call    bankup
qud07:          dec     si
                jnz     qud01
                pop     di
                pop     si
                pop     dx
                pop     cx
                pop     bx
                ret
Quad            endp

Border          proc
;Draw a single-line border
;in:CX=x,DX=ykoord,DI=x,SI=ysize,AX=color1,BX=color2
                pusha
                dec     cx
                dec     dx
                inc     si
                inc     di
                call    bankres
                call    shorline
                xchg    si, di
                inc     dx
                call    sverline
                xchg    ax, bx
                add     cx, si
                dec     dx
                call    sverline
                sub     cx, si
                inc     cx
                add     dx, di
                xchg    si, di
                call    shorline
                popa
                push    ax
                push    di
                mov     al,cs:[linemode]
                test    al,1
                jz bord99
                mov ax,cs:[debugsegm]
                mov es,ax
                mov di,cs:[debugpoint]
                mov ax,cx
                stosw
                mov ax,dx
                stosw
                mov cs:[debugpoint],di
bord99:         pop di
                pop ax
                ret
Border          endp

debugpoint dw 0
debugname db 'border.log',0

Horline         proc
;Horizontal line
;in:CX=x,DX=ykoord,AX=color,di=lenght
                push    ax
                push    bx
                push    cx
                push    dx
                push    di
                call    bankres
                mov     bx, di
                call    vidaddrcalc
                mov     cx, bx
                mov     bl,cs:[grfhi]
                test    bl,1
                jz      horl01
horl01h:        stosw
                cmp     di,2
                jnc     horl02h
                call    bankup
horl02h:        loop    horl01h
                jmp     horl05
horl01:         stosb
                cmp     di, 1
                jnc     horl02
                call    bankup
horl02:         loop    horl01
horl05:         pop     di
                pop     dx
                pop     cx
                pop     bx
                pop     ax
                ret
Horline         endp

Xhorline        proc
;Horizontal line
;in:CX=x,DX=ykoord,di=lenght
                push    ax
                push    bx
                push    cx
                push    dx
                push    di
                call    bankres
                mov     bx, di
                call    vidaddrcalc
                mov     cx, bx
                mov     bl,cs:[grfhi]
                test    bl,1
                jz      xhorl01
xhorl01h:       mov     ax,es:[di]
                xor     ax,1000010000010000b
                stosw
                cmp     di,2
                jnc     xhorl02h
                call    bankup
xhorl02h:       loop    xhorl01h
                jmp     xhorl05
xhorl01:        mov     al,es:[di]
                not     al
                stosb
                cmp     di, 1
                jnc     xhorl02
                call    bankup
xhorl02:        loop    xhorl01
xhorl05:        pop     di
                pop     dx
                pop     cx
                pop     bx
                pop     ax
                ret
Xhorline        endp

Verline         proc
;in:CX=x,DX=ykoord,AX=color,di=lenght
;Vertical line
                push    ax
                push    bx
                push    cx
                push    dx
                push    di
                call    bankres
                mov     bx, di
                call    vidaddrcalc
                mov     cx, bx
                mov     bl, cs:[grfhi]
verl01:         mov     es:[di],al
                test    bl, 1
                jz      verl02
                mov     es:[di+1],ah
                add     di, cs:[horsiz]
                jnc     verl02
                call    bankup
verl02:         add     di, cs:[horsiz]
                jnc     verl03
                call    bankup
verl03:         loop    verl01
                pop     di
                pop     dx
                pop     cx
                pop     bx
                pop     ax
                ret
Verline         endp

Xverline        proc
;in:CX=x,DX=ykoord,di=lenght
;Vertical line
                push    ax
                push    bx
                push    cx
                push    dx
                push    di
                call    bankres
                mov     bx, di
                call    vidaddrcalc
                mov     cx, bx
                mov     dx, cs:[horsiz]
                mov     bl, cs:[grfhi]
                test    bl, 1
                jz      xverl02
                shl     dx,1
xverl01:        mov     ax,es:[di]
                xor     ax,1000010000010000b
                mov     es:[di],ax
                add     di, dx
                jnc     xverl015
                call    bankup
xverl015:       loop    xverl01
                jmp     xverl90
xverl02:        mov     al,es:[di]
                not     al
                mov     es:[di],al
                add     di, dx
                jnc     xverl03
                call    bankup
xverl03:        loop    xverl02
xverl90:        pop     di
                pop     dx
                pop     cx
                pop     bx
                pop     ax
                ret
Xverline        endp

Chardraw        proc
;Draw    a character
;in:CX=x,DX=ykoord,BX=color,AL=ASCII code
;si[b0..b7]=cut from up, si[b8..b15]=cut from down
;di[b0..b7]=cut from left, di[b8..b15]=cut from right
                pusha
                push    ds
                push    bx
                push    dx
                push    cx
                call    bankres
                mov     dl, al
                xor     dh, dh
                mov     cl, 4
                shl     dx, cl
                mov     ax, si                  ;ax=cut vetical
                add     dl, al
                adc     dh, 0
                mov     si, dx
                pop     cx
                pop     dx
                push    di
                call    vidaddrcalc
                pop     cx                      ;cx=cut horizontal
                pop     bx                      ;bx=color
                mov     dx, cs:[fontsegm]
                mov     ds, dx
                mov     dx, vidseg
                mov     es, dx
                mov     dl, 16
                cmp     ah, 0
                jz      chdr00
                mov     dl, ah
chdr00:         sub     dl, al
                jz      chdr8
                jc      chdr8
                mov     ax, cx
                mov     ch, 8
                cmp     ah, 0
                jz      chdr02
                mov     ch, ah
chdr02:         sub     ch, al
                jz      chdr8
                jc      chdr8
                mov     ah, cs:[grfhi]
chdr2:          lodsb
                shl     al, cl
                mov     dh, ch
chdr3:          add     al, al
                jnc     chdr4
                test    ah,1
                jz      chdr32
                mov     es:[di+1],bh
chdr32:         mov     es:[di],bl
chdr4:          inc     di
                test    ah,1
                jz      chdr5
                inc     di
                cmp     di,2
                jnc     chdr6
                call    bankup
                jmp     chdr6
chdr5:          cmp     di, 1
                jnc     chdr6
                call    bankup
chdr6:          dec     dh
                jnz     chdr3
                push    dx
                mov     dx, cs:[horsiz]
                sub     dl, ch
                jnc     chdr62
                dec     dh
chdr62:         add     di, dx
                jnc     chdr6h
                call    bankup
chdr6h:         test    ah,1
                jz      chdr7
                add     di,dx
                jnc     chdr7
                call    bankup
chdr7:          pop     dx
                dec     dl
                jz      chdr8
                jmp     chdr2
chdr8:          pop     ds
                popa
                ret
Chardraw        endp

Sysdraw         proc
;in: cx=x, dx=ykoord, al=typ, ah=colorset
;si[b0..b7]=cut from up (first line), si[b8..b15]=cut from down (last line)
;di[b0..b7]=cut from left (first col.), di[b8..b15]=cut from right (last col.)
                pusha
                push ds
                push es
                push ax
                push di
                push si
                call bankres
                mov bx,cs:[mousegm]
                mov ds,bx
                mov ah,al
                xor al,al
                mov bx,si
                xor bh,bh
                shl bx,4
                add ax,bx
                mov si,ax
                call vidaddrcalc
                pop cx                  ;cx=cut vertical
                pop ax                  ;ax=cut horizontal
                cmp ch,0
                jnz sdrw10
                mov ch,16
sdrw10:         sub ch,cl
                jnz sdrw101
                jmp sdrw85
sdrw101:        jnc sdrw102
                jmp sdrw85
sdrw102:        cmp ah,0
                jnz sdrw11
                mov ah,16
sdrw11:         mov cl,ah
                sub cl,al
                jnz sdrw111
                jmp sdrw85
sdrw111:        jnc sdrw112
                jmp sdrw85
sdrw112:        sub ah,16
                neg ah
                pop bx
                mov bl,bh
                xor bh,bh
                shl bx,2
                add bx,offset colorsets
                mov bp,bx
sdrw20:         push ax
                push cx
                mov bl,al
                xor bh,bh
                add si,bx
sdrw30:         lodsb
                cmp al,0
                jnz sdrw32
                mov al,cs:[grfhi]
                and al,1
                inc al
                xor ah,ah
                add di,ax
                jnc sdrw31
                call bankup
sdrw31:         jmp sdrw40
sdrw32:         mov bx,bp
                xor ah,ah
                add bx,ax
                mov al,cs:[bx]
                mov bx,offset colors
                add bx,ax
                mov ax,cs:[bx]
                mov bl,cs:[grfhi]
                test bl,1
                jz sdrw34
                stosw
                jmp sdrw36
sdrw34:         stosb
sdrw36:         cmp di,0
                jnz sdrw40
                call bankup
sdrw40:         dec cl
                jnz sdrw30
                pop cx
                pop ax
                mov bl,ah
                xor bh,bh
                add si,bx
                xor bh,bh
                mov bl,cl
                neg bx
                add bx,cs:[horsiz]
                add di,bx
                jnc sdrw48
                call bankup
sdrw48:         mov dh,cs:[grfhi]
                test dh,1
                jz sdrw50
                add di,bx
                jnc sdrw50
                call bankup
sdrw50:         dec ch
                jz sdrw90
                jmp sdrw20
sdrw85:         pop ax
sdrw90:         pop es
                pop ds
                popa
                ret
Sysdraw         endp

sdrwactset       dw 0

Mousrestor      proc
;Restore the mouse field
;in: cx=x, dx=ykoord
                pusha
                push ds
                push es
                call bankres
                mov bx,cs:[moussavsegm]
                mov ds,bx
                xor si,si
                call vidaddrcalc
                mov dl,16
mrst10:         mov cx,16
mrst11:         mov bl,cs:[grfhi]
                test bl,1
                jz mrst12
                movsw
                jmp mrst14
mrst12:         movsb
mrst14:         cmp di,0
                jnz mrst16
                call bankup
mrst16:         dec cx
                jnz mrst11
                mov ax,cs:[horsiz]
                sub ax,16
                add di,ax
                jnc mrst19
                call bankup
mrst19:         mov dh,cs:[grfhi]
                test dh,1
                jz mrst20
                add di,ax
                jnc mrst20
                call bankup
mrst20:         dec dl
                jnz mrst10
                pop es
                pop ds
                popa
                ret
Mousrestor      endp

Moussave        proc
;in: cx=x, dx=ykoord
                pusha
                push ds
                push es
                call bankres
                mov bx,cs:[moussavsegm]
                mov ds,bx
                call vidaddrcalc
                mov si,di
                xor di,di
                mov ax,es
                mov bx,ds
                mov es,bx
                mov ds,ax
                mov dl,16
msav10:         mov cx,16
msav11:         mov bl,cs:[grfhi]
                test bl,1
                jz msav12
                movsw
                jmp msav14
msav12:         movsb
msav14:         cmp si,0
                jnz msav16
                call bankup
msav16:         dec cx
                jnz msav11
                mov ax,cs:[horsiz]
                sub ax,16
                add si,ax
                jnc msav19
                call bankup
msav19:         mov dh,cs:[grfhi]
                test dh,1
                jz msav20
                add si,ax
                jnc msav20
                call bankup
msav20:         dec dl
                jnz msav10
                pop es
                pop ds
                popa
                ret
Moussave        endp

Vidaddrcalc     proc
;Calculate the video-bank and the memory-offset from the koords
;in: cx=x, dx=ykoords
;out: {vidbank}, di=offset
                push    ax
                push    bx
                mov     ax, cs:[horsiz]
                mul     dx
                add     ax, cx
                adc     dx, 0
                mov     bl, cs:[grfhi]
                test    bl, 1
                jz      vidadrc0
                shl     ax, 1
                adc     dx, dx
vidadrc0:       mov     di, ax
                mov     al, dl
                call    chbank
                mov     ax, vidseg
                mov     es, ax
                pop     bx
                pop     ax
                ret
Vidaddrcalc     endp
;--------------------------------------
Windraw          proc
;in:ds:bp->leiro
                push bp
                xor al,al
                mov cs:[linemode],al
                mov cx,ds:[bp]
                mov dx,ds:[bp+2]
                mov di,ds:[bp+4]
                mov si,ds:[bp+6]
                mov ax,cs:[colors+2*2]
                call squad
                mov ax,cs:[colors+4*2]
                mov bx,cs:[colors+1*2]
                call border
                add cx,2
                add dx,17
                sub di,4
                sub si,19
                mov bx,cs:[colors+4*2]
                mov ax,cs:[colors+1*2]
                call border
                xchg ax,bx
                call wheader
                call whbuttons
                call wscroll
                call wscrlbuts
                pop bp
                ret
Windraw         endp

Whbuttons       proc
                mov cx,ds:[bp]
                mov dx,ds:[bp+2]
                mov si,14
                mov di,si
                mov bl,ds:[bp+8]
                inc cx
                inc dx
                test bl,4
                jz whb02
                mov ax,cs:[colors]
                call squad
                push dx
                push cx
                mov al,cs:[winparam]
                test al,4
                jnz whb01
                dec cx
                dec dx
whb01:          mov ah,1
                mov al,0+buttsbegin
                call ssysdraw
                pop cx
                pop dx
whb02:          add cx,ds:[bp+4]
                mov bl,ds:[bp+8]
                sub cx,16
                test bl,2
                jz whb03
                mov ax,cs:[colors]
                call squad
                push dx
                push cx
                mov al,cs:[winparam]
                test al,2
                jnz whb025
                dec cx
                dec dx
whb025:         mov ah,1
                mov al,2+buttsbegin
                call ssysdraw
                pop cx
                pop dx
                sub cx,15
whb03:          mov bl,ds:[bp+8]
                test bl,1
                jz whb04
                mov ax,cs:[colors]
                call squad
                mov al,cs:[winparam]
                test al,1
                jnz whb035
                dec cx
                dec dx
whb035:         mov ah,1
                mov al,1+buttsbegin
                call ssysdraw
whb04:          ret
Whbuttons       endp

Wheader         proc
                mov cx,ds:[bp]
                mov dx,ds:[bp+2]
                mov si,16
                mov di,ds:[bp+4]
;                dec di
                mov ax,cs:[colors+3*2]
                mov bl,cs:[winparam]
                test bl,80h
                jnz whd05
                mov ax,cs:[colors+2*2]
whd05:          call squad
                mov bl,ds:[bp+8]
                test bl,4
                jz whd02
                add cx,16
                sub di,16
whd02:          test bl,2
                jz whd03
                sub di,16
whd03:          test bl,1
                jz whd04
                sub di,16
whd04:          add cx,4
                mov bx,di
                shr bx,3
                dec bx
                mov al,ds:[bp+9]
                xor ah,ah
                cmp bx,ax
                jnc whd10
                mov ax,bx
whd10:          mov ah,al
                mov si,ds:[bp+10]
                mov bx, cs:[colors+4*2]
                mov al,cs:[winparam]
                test al,80h
                jz whd11
                mov bx,cs:[colors+6*2]
whd11:          cmp ah,0
                jz whd14
                lodsb
                cmp al,0
                jz whd14
                call schardraw
                add cx,8
                dec ah
                jmp whd11
whd14:
                ret
Wheader         endp

Wrlbutt         proc
;a gorditosav egy gombjat rajzolja ki
;in: al[b0]..[b6]=sorszam, al[b7]=status, ds:[bp]->leiro
                pusha
                push ax
                and al,127
                mov cx,ds:[bp]
                mov dx,ds:[bp+2]
                mov bx,offset wrlbuts
                mov ah,al
                shl al,1
                add al,ah
                add bl,al
                adc bh,0
                mov al,cs:[bx]
                cbw
                test al,128
                jz wrlbt10
                add ax,ds:[bp+4]
wrlbt10:        add cx,ax
                mov al,cs:[bx+1]
                cbw
                test al,128
                jz wrlbt12
                add ax,ds:[bp+6]
wrlbt12:        add dx,ax
                mov si,16
                mov di,16
                mov ax,cs:[colors]
                call squad
                pop ax
                test al,128
                jz wrlbt14
                inc cx
                inc dx
wrlbt14:        mov ah,1
                mov al,cs:[bx+2]
                add al,buttsbegin
                call ssysdraw
                popa
                ret
Wrlbutt endp

wrlbuts db -18, -18, 7, -34, -18, 5, -18, -34, 4, 2, -18, 6, -18, 17, 3
;a gorditosav gombok koordinatai es ikonjai (a pozitiv ertekek balrol,
;a negativak jobbrol ertendok)

wscrlbuts       proc
                push ax
                mov al,ds:[bp+8]
                test al,32
                jz wscrlbts99
                xor al,al
wscrll1:        call wrlbutt
                inc al
                cmp al,5
                jnz wscrll1
wscrlbts99:     pop ax
                ret
wscrlbuts       endp

Wscroll         proc
                mov al,ds:[bp+8]
                test al,32
                jz wscrl99
                mov cx,ds:[bp]
                mov dx,ds:[bp+2]
                mov bx,ds:[bp+4]
                and bh,3fh
                add dx,ds:[bp+6]
                mov si,ds:[bp+12]
                mov di,ds:[bp+16]
                mov ax,bx
                sub ax,20
                sub dx,18
                add cx,18
                sub bx,52
                call scrollbar
                mov cx,ds:[bp]
                mov dx,ds:[bp+2]
                add cx,ds:[bp+4]
                mov bx,ds:[bp+6]
                mov si,ds:[bp+14]
                mov di,ds:[bp+18]
                mov ax,bx
                sub ax,20
                sub cx,18
                add dx,33
                sub bx,67
                or bh,80h
                call scrollbar
wscrl99:        ret
Wscroll         endp

Wtartmezoclear  proc
;ds:[bp]->leiro
                pusha
                mov cx,ds:[bp]
                mov dx,ds:[bp+2]
                mov di,ds:[bp+4]
                mov si,ds:[bp+6]
                add cx,2
                sub di,4
                add dx,17
                sub si,19
                mov al,ds:[bp+8]
                test al,32
                jz wtmcl10
                sub di,16
                sub si,16
wtmcl10:        mov ax,cs:[colors+2*2]
                call squad
                popa
                ret
Wtartmezoclear  endp

Scrollbar       proc
;in: cx=x,dx=ykoord; bx[b15]=h/v, bx[b0]..[b14]=size
;di=maxrange, si=value, ax=actrange
                pusha
                cmp di,ax
                jnc scrllbr02
                mov ax,di
                xor si,si
scrllbr02:      mov cs:[scrlbrval],si
                mov cs:[scrlbrmax],di
                mov cs:[scrlbrran],ax
                mov cs:[scrlbrsiz],bx
                xor al,al
                mov cs:[linemode],al
                inc cx
                inc dx
                mov di,bx
                and di,7fffh
                sub di,2
                mov si,14
                test bh,80h
                jz scrllbr10
                xchg si,di
scrllbr10:      mov ax,cs:[colors+2*2]
                call squad
                mov ax,cs:[colors+4*2]
                mov bx,cs:[colors+1*2]
                call border
                add cx,2
                add dx,2
                push dx
                mov ax,cs:[scrlbrran]
                mov bx,cs:[scrlbrsiz]
                and bh,00111111b
                sub bx,6
                mul bx
                mov bx,cs:[scrlbrmax]
                div bx
                cmp dx,0
                jz scrlbr12
                inc ax
scrlbr12:       mov si,ax
                mov ax,cs:[scrlbrsiz]
                and ah,00111111b
                sub ax,6
                mov bx,cs:[scrlbrval]
                mul bx
                mov bx,cs:[scrlbrmax]
                div bx
                pop dx
                mov bx,cs:[scrlbrsiz]
                test bh,80h
                jnz scrlbr20
                mov di,si
                mov si,10
                add cx,ax
                jmp scrlbr30
scrlbr20:       mov di,10
                add dx,ax
scrlbr30:       mov ax,cs:[colors+4*2]
                mov bx,cs:[colors+1*2]
                call border
                popa
                ret
Scrollbar       endp

Gomb            proc
;cx=x0, dx=y0, di=xs, si=ys, ds:bx->tartalom, al=kapcsolok
                pusha
                push ax
                push bx
                push ax
                inc si
                inc di
                xor bx,bx
                xor ax,ax
                mov cs:[linemode],al
                call border
                dec si
                dec di
                pop ax
                test al,40h
                jz gmb10
                inc cx
                inc dx
gmb10:          mov ax,cs:[colors+2*2]
                call squad
                mov ax,cs:[colors+4*2]
                mov bx,cs:[colors+1*2]
                call border
                pop bx
                pop ax
                test al,1
                jnz gmb20
                call charpos
                mov ax,cs:[colors+1*2]
                call charcolor
                call string
gmb20:          popa
                ret
Gomb            endp

Text            proc
                call charpos
                mov ax,cs:[colors+1*2]
                call charcolor
                call string
                ret
Text            endp

Kapcsolo        proc
;in: cx=x0, dx=y0, al=kapcsolo
                push bx
                mov bx,108h
                add bl,8
                test al,1
                jz kpcs01
                inc bl
kpcs01:         mov ax,bx
                call ssysdraw
                pop bx
                ret
Kapcsolo        endp

Radiogomb       proc
;in: cx=x0, dx=y0, al=kapcsolo
                push bx
                mov bx,10ah
                add bl,8
                test al,1
                jz rdog01
                inc bl
rdog01:         mov ax,bx
                call ssysdraw
                pop bx
                ret
Radiogomb       endp

Fomenudrw       proc
                pusha
                push cs
                pop ds
                xor al,al
                mov cs:[linemode],al
                call resetvisible
                mov cx,cs:[x0screen]
                mov dx,cs:[y0screen]
                inc dx
                mov si,16
                mov di,cs:[horsiz]
                sub di,2
                mov ax,cs:[colors+2*2]
                call squad
                mov ax,cs:[colors+4*2]
                mov bx,cs:[colors+1*2]
                call border
                call fomenuszovdrw
                popa
                ret
Fomenudrw       endp

Fomenuszovdrw   proc
                pusha
                push ds
                call resetvisible
                mov cx,cs:[x0screen]
                mov dx,cs:[y0screen]
                inc dx
                xor ah,ah
                mov bx,cs:[menusegm]
                mov es,bx
                xor bp,bp
fmndrw20:       mov bx,es:[bp+2]
                cmp bx,0
                jz fmndrw60
                mov ds,bx
                mov bx,es:[bp]
                mov al,ds:[bx]
                inc bx
                call fomenupont
                add al,3
                shl al,3
                add cl,al
                adc ch,0
fmndrw60:       add bp,8
                inc ah
                cmp ah,8
                jnz fmndrw20
                pop ds
                popa
                ret
Fomenuszovdrw   endp

Fomenupont      proc
;in:cx,dx=x0,y0; ds:bx->string; ah=number
                pusha
                push es
                push bp
                call charpos
                cmp ah,cs:[aktivmenu]
                jnz fomep10
                mov cs:[aktivmenx],cx
                mov ax,cs:[colors+4*2]
                jmp fomep15
fomep10:        mov ax,cs:[colors+1*2]
fomep15:        call charcolor
                call string
                pop bp
                pop es
                popa
                ret
Fomenupont      endp

Almenudrw       proc
                pusha
                xor al,al
                mov cs:[linemode],al
                call resetvisible
                mov bl,cs:[aktivmenu]
                cmp bl,-1
                jnz amdrw02
                jmp amdrw99
amdrw02:        xor bh,bh
                shl bx,3
                mov ax,cs:[menusegm]
                mov es,ax
                mov ax,es:[bx+6]
                cmp ax,0
                jnz amdrw04
                jmp amdrw99
amdrw04:        mov ds,ax
                mov bx,es:[bx+4]
                mov al,ds:[bx]
                mov al,16
                xor ah,ah
                shl ax,3
                mov di,ax
                mov al,ds:[bx+1]
                xor ah,ah
                shl ax,4
                mov si,ax
                mov cs:[aktivalmenys],ax
                mov dx,cs:[y0screen]
                add dx,19
                mov cx,cs:[aktivmenx]
                mov ax,cs:[colors+2*2]
                call squad
                push bx
                mov ax,cs:[colors+4*2]
                mov bx,cs:[colors+1*2]
                call border
                pop bx
                call Almenuszovdrw
amdrw99:        popa
                ret
Almenudrw       endp

Almenuszovdrw   proc
                pusha
                push ds
                push es
                call resetvisible
                mov bl,cs:[aktivmenu]
                cmp bl,-1
                jnz amdszrw02
                jmp amdszrw99
amdszrw02:      xor bh,bh
                shl bx,3
                mov ax,cs:[menusegm]
                mov es,ax
                mov ds,ax
                mov bx,es:[bx+4]
                mov al,ds:[bx]
                mov al,16
                xor ah,ah
                shl ax,3
                mov di,ax
                mov al,ds:[bx+1]
                xor ah,ah
                shl ax,4
                mov si,ax
                mov cs:[aktivalmenys],ax
                mov dx,cs:[y0screen]
                add dx,19
                mov cx,cs:[aktivmenx]
                mov al,ds:[bx+1]
                xor ah,ah
                add bx,2
amdrw10:        call almenupont
                add dx,16
                add bx,16
                inc ah
                cmp ah,al
                jc amdrw10
amdszrw99:      pop es
                pop ds
                popa
                ret
Almenuszovdrw   endp

Almenupont      proc
;in: cx=x0, dx=y0, di=xs, ds:bx-> szoveg
                pusha
                call charpos
                cmp ah,cs:[aktivalmenu]
                jnz almep10
                mov ax,cs:[colors+4*2]
                jmp almep15
almep10:        mov ax,cs:[colors+1*2]
almep15:        call charcolor
                call string
                popa
                ret
Almenupont      endp


scrlbrval       dw 0
scrlbrmax       dw 0
scrlbrran       dw 0
scrlbrsiz       dw 0
;==========================================================================
vmempage        db      0                                  ;Actual VideoMem. page
Grfmode1        dw      0                                  ;Graphic video mode
Grfmode2        dw      0
Horsiz          dw      320                                ;Horizontal display size
Versiz          dw      200                                ;Vertical display size

                                                           ;| 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
Winparam        db      00h                                ;|act|   |   |   |   |off|max|min|
                db      00h

Vidcall         dw      0, 0                               ;Gfxdriver segment and offset
Monsizes        dw      640, 480, 800, 600, 1024, 768, 1280, 1024


colors dw 0,251,252,253,254,255,249
;rendszerszinek sorszamai a 256 szinu palettan (hi-colorban atirodik
;konkret szinekre)

colorsets db 0,0,4,12                   ;Eger es ablak szinkompoziciok
          db 0,2,4,8

comps5 db 0,15,31,47,63                 ;256-os paletta komponensei
comps10 db 0,7,14,21,28,35,42,49,56,63  ;(5 R, 10 G, 5 B)

