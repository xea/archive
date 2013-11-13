debugon         proc
                pusha
                call txtmode
                popa
                ret
debugon         endp

debugoff        proc
                pusha
                call gfxmode
                call mainscreen
                popa
                ret
debugoff        endp

MainScreen      proc
                pusha
                push bp
                push ds
                push es
                mov ax, cs:[colors+5*2]
                call cls
                xor al,al
                mov cs:[szuktart],al
                call fomenudrw
                xor al,al
                call windows
                call almenudrw
                pop es
                pop ds
                pop bp
                popa
                ret
MainScreen      endp

Almenutorl      proc
                pusha
                push bp
                push ds
                push es
                mov ah,cs:[aktivmenu]
                cmp ah,-1
                jz almntrl90
                mov cx,cs:[aktivmenx]
                dec cx
                mov dx,18
                add dx,cs:[y0screen]
                mov si,cs:[aktivalmenys]
                add si,2
                mov di,16*8+2
                call regioredraw
almntrl90:      pop es
                pop ds
                pop bp
                popa
                ret
Almenutorl      endp

Regioredraw     proc
                pusha
                call resetvisible
                mov ax,cs:[colors+5*2]
                inc si
                call squad
                add di,cx
                add si,dx
                call setszukvis
                mov al,1
                mov cs:[szuktart],al
                xor al,al
                call windows
                xor al,al
                mov cs:[szuktart],al
                call setscreenvisible
                popa
                ret
Regioredraw     endp

Windows         proc
;in: al=first refreshable window (in queue)
                pusha
                mov bl,cs:[maxwindow]
                cmp bl,0
                jz wnds90
                mov bx,cs:[winsorsegm]
                mov es,bx
                xor ah,ah
wnds10:         call setscreenvisible
                mov bx,ax
                inc ax
                xor dl,dl
                cmp al,cs:[maxwindow]
                jnz wnds12
                mov dl,80h
wnds12:         mov cs:[winparam],dl
                mov bl,es:[bx]
                xor bh,bh
                shl bx,3
                inc bh
                mov dx,es:[bx+2]
                cmp dx,0
                jz wnds80
                mov ds,dx
                mov bp,es:[bx]
                call swindraw
wnds80:         cmp al,cs:[maxwindow]
                jc wnds10
wnds90:         popa
                ret
Windows         endp


;----------------------- Modifying graphical objects------------------------
swindraw        proc
;in:ds:bp->leiro
                pusha
                push ds
                push es
                push bp
                mov al,ds:[bp+8]
                test al,10h
                jnz swindrw90
                call setscreenvisible
                call windraw
                call setwinvisible
                sub bp,2
                call swinmezo
swindrw90:      pop bp
                pop es
                pop ds
                popa
                ret
swindraw        endp

swinmezo        proc
                pusha
                push bp
swdrw0:         add bp,24
                mov al,ds:[bp]
                cmp al,-1
                jnz swdrw00
                jmp swdrw90
swdrw00:        cmp al,0
                jnz swdrw01
                call sablak
                jmp swdrw0
swdrw01:        cmp al,1
                jnz swdrw02
                call sgroup
                jmp swdrw0
swdrw02:        cmp al,2
                jnz swdrw03
                call sgomb
                jmp swdrw0
swdrw03:        cmp al,3
                jnz swdrw04
                call srollbar
                jmp swdrw0
swdrw04:        cmp al,4
                jnz swdrw05
                call srollbutt
                jmp swdrw0
swdrw05:        cmp al,5
                jnz swdrw06
                call skapcs
                jmp swdrw0
swdrw06:        cmp al,6
                jnz swdrw07
                call sradiogmb
                jmp swdrw0
swdrw07:        cmp al,7
                jnz swdrw08
                call sicondrw
                jmp swdrw0
swdrw08:        cmp al,8
                jnz swdrw90
                call stext
                jmp swdrw0
swdrw90:        pop bp
                popa
                ret
swinmezo        endp

sablak          proc
                ret
sablak          endp

sgroup          proc
                ret
sgroup          endp

srollbar        proc
                ret
srollbar        endp

srollbutt       proc
                ret
srollbutt       endp

skapcs          proc
                call wposobject
                call kapcsolo
                ret
skapcs          endp

sradiogmb       proc
                call wposobject
                call radiogomb
                ret
sradiogmb       endp

sicondrw        proc
                ret
sicondrw        endp

stext           proc
                call wposobject
                call text
                ret
stext           endp

sgomb           proc
                call wposobject
                call gomb
                ret
sgomb           endp

wposobject      proc
                mov cx,ds:[bp+2]
                mov dx,ds:[bp+4]
                mov di,ds:[bp+6]
                mov si,ds:[bp+8]
                mov bx,ds:[bp+10]
                mov al,ds:[bp+1]
                add cx,cs:[posx0]
                sub cx,cs:[posxeltol]
                add dx,cs:[posy0]
                sub dx,cs:[posyeltol]
                ret
wposobject      endp

sposmodify      proc
                sub cx,cs:[x0screen]
                sub dx,cs:[y0screen]
                inc cx
                ret
sposmodify      endp

resetvisible    proc
                push ax
                push bx
                mov ax,cs:[x0screen]
                mov bx,cs:[y0screen]
                mov cs:[x0visiblerange],ax
                mov cs:[y0visiblerange],bx
                mov cs:[x0szuk],ax
                mov cs:[y0szuk],bx
                add ax,cs:[horsiz]
                dec ax
                mov cs:[xlvisiblerange],ax
                add bx,cs:[versiz]
                mov cs:[ylvisiblerange],bx
                mov cs:[xmaxszuk],ax
                mov cs:[ymaxszuk],bx
                pop bx
                pop ax
                ret
resetvisible    endp

setvisible      proc
                cmp cx,cs:[x0visiblerange]
                jc setvis10
                mov cs:[x0visiblerange],cx
setvis10:       cmp dx,cs:[y0visiblerange]
                jc setvis12
                mov cs:[y0visiblerange],dx
setvis12:       cmp di,cs:[xlvisiblerange]
                jnc setvis14
                mov cs:[xlvisiblerange],di
setvis14:       cmp si,cs:[ylvisiblerange]
                jnc setvis16
                mov cs:[ylvisiblerange],si
setvis16:       ret
setvisible      endp

setwinvisible   proc
                mov cx,ds:[bp]
                mov dx,ds:[bp+2]
                mov di,ds:[bp+4]
                mov si,ds:[bp+6]
                add di,cx
                add si,dx
                add cx,3
                sub di,2
                add dx,18
                sub si,2
                mov cs:[posx0],cx
                mov cs:[posy0],dx
                mov al,ds:[bp+8]
                test al,32
                jz swv10
                sub di,16
                sub si,16
swv10:          call setvisible
                mov cx,ds:[bp+12]
                mov dx,ds:[bp+14]
                mov cs:[posxeltol],cx
                mov cs:[posyeltol],dx
                ret
setwinvisible   endp

setszukvis      proc
                pusha
                mov ax,cs:[x0screen]
                mov bx,cs:[y0screen]
                cmp cx,ax
                jnc stszukv10
                mov cx,ax
stszukv10:      mov cs:[x0szuk],cx
                cmp dx,bx
                jnc stszukv12
                mov dx,bx
stszukv12:      mov cs:[y0szuk],dx
                add ax,cs:[horsiz]
                dec ax
                add bx,cs:[versiz]
                cmp ax,di
                jnc stszukv14
                mov di,ax
stszukv14:      mov cs:[xmaxszuk],di
                cmp bx,si
                jnc stszukv16
                mov si,bx
stszukv16:      mov cs:[ymaxszuk],si
                popa
                ret
setszukvis      endp

szukvisload     proc
                mov cx,cs:[x0szuk]
                mov dx,cs:[y0szuk]
                mov di,cs:[xmaxszuk]
                mov si,cs:[ymaxszuk]
                ret
szukvisload     endp

setscreenvisible    proc
                pusha
                mov cx,cs:[x0screen]
                mov dx,cs:[y0screen]
                add dx,19
                mov di,cs:[horsiz]
                mov si,cs:[versiz]
                add di,cx
                add si,dx
                dec di
                sub si,19
                mov al,cs:[szuktart]
                test al,1
                jz stscrnvis20
                call szukvisload
stscrnvis20:
                mov cs:[x0visiblerange],cx
                mov cs:[y0visiblerange],dx
                mov cs:[xlvisiblerange],di
                mov cs:[ylvisiblerange],si
                mov cs:[posx0],cx
                mov cs:[posy0],dx
                mov ax, cs:[x0screen]
                mov cs:[posxeltol],ax
                mov ax, cs:[y0screen]
                mov cs:[posyeltol],ax
                popa
                ret
setscreenvisible    endp

schardraw       proc
;in:CX=x,DX=ykoord,BX=color,AL=ASCII code
                pusha
                push ax
                push bx
                push cx
                push dx
                mov si,16
                mov di,8
                add di,cx
                add si,dx
                mov ax,cs:[xlvisiblerange]
                dec ax
                cmp ax,cx
                jc scdrw90
                mov ax,cs:[ylvisiblerange]
                dec ax
                cmp ax,dx
                jc scdrw89
                mov ax,cs:[x0visiblerange]
                dec ax
                cmp di,ax
                jc scdrw89
                mov ax,cs:[y0visiblerange]
                dec ax
                cmp si,ax
                jc scdrw89
                mov si,16
                mov di,8
                add cx,di
                add dx,si
                mov ax,cs:[xlvisiblerange]
                cmp ax,cx
                jnc scdrw03
                sub cx,ax
                sub di,cx
scdrw03:        shl di,8
                mov ax,cs:[ylvisiblerange]
                cmp ax,dx
                jnc scdrw04
                sub dx,ax
                sub si,dx
scdrw04:        shl si,8
                pop dx
                pop cx
                mov ax,cs:[x0visiblerange]
                dec ax
                cmp ax,cx
                jc scdrw06
                mov bx,ax
                sub ax,cx
                add di,ax
                mov cx,bx
scdrw06:        mov ax,cs:[y0visiblerange]
                dec ax
                cmp ax,dx
                jc scdrw08
                mov bx,ax
                sub ax,dx
                add si,ax
                mov dx,bx
scdrw08:        pop bx
                pop ax
                call sposmodify
                call chardraw
                clc
                jmp scdrw99
scdrw89:        clc
scdrw90:        pop dx
                pop cx
                pop bx
                pop ax
scdrw99:        popa
                ret
schardraw endp

ssysdraw proc
;in: cx=x, dx=ykoord, al=typ, ah=colorset
                pusha
                push ax
                push cx
                push dx
                mov si,16
                mov di,si
                add di,cx
                add si,dx
                mov ax,cs:[xlvisiblerange]
                dec ax
                cmp ax,cx
                jc ssdrw90
                mov ax,cs:[ylvisiblerange]
                dec ax
                cmp ax,dx
                jc ssdrw90
                mov ax,cs:[x0visiblerange]
                dec ax
                cmp di,ax
                jc ssdrw90
                mov ax,cs:[y0visiblerange]
                dec ax
                cmp si,ax
                jc ssdrw90
                mov si,16
                mov di,si
                add cx,di
                add dx,si
                mov ax,cs:[xlvisiblerange]
                cmp ax,cx
                jnc ssdrw02
                sub cx,ax
                sub di,cx
ssdrw02:        shl di,8
                mov ax,cs:[ylvisiblerange]
                cmp ax,dx
                jnc ssdrw04
                sub dx,ax
                sub si,dx
ssdrw04:        shl si,8
                pop dx
                pop cx
                mov ax,cs:[x0visiblerange]
                dec ax
                cmp ax,cx
                jc ssdrw06
                mov bx,ax
                sub ax,cx
                add di,ax
                mov cx,bx
ssdrw06:        mov ax,cs:[y0visiblerange]
                dec ax
                cmp ax,dx
                jc ssdrw08
                mov bx,ax
                sub ax,dx
                add si,ax
                mov dx,bx
ssdrw08:        pop ax
                call sposmodify
                call sysdraw
                jmp ssdrw99
ssdrw90:        pop dx
                pop cx
                pop ax
ssdrw99:        popa
                ret
ssysdraw        endp

squad           proc
;in:cx=x,dx=ykoord,ax=color,di=x,si=ysize
                pusha
                push ax
                push cx
                push dx
                push si
                push di
                add di,cx
                add si,dx
                mov ax,cs:[xlvisiblerange]
                dec ax
                cmp ax,cx
                jnc sqdrw010
                jmp sqdrw90
sqdrw010:       mov ax,cs:[ylvisiblerange]
                dec ax
                cmp ax,dx
                jnc sqdrw012
                jmp sqdrw90
sqdrw012:       mov ax,cs:[x0visiblerange]
                dec ax
                cmp di,ax
                jnc sqdrw014
                jmp sqdrw90
sqdrw014:       mov ax,cs:[y0visiblerange]
                dec ax
                cmp si,ax
                jnc sqdrw016
                jmp sqdrw90
sqdrw016:       pop di
                pop si
                add cx,di
                add dx,si
                mov ax,cs:[xlvisiblerange]
                cmp ax,cx
                jnc sqdrw02
                sub cx,ax
                sub di,cx
sqdrw02:        cmp di,0
                jz sqdrw95
                test di,8000h
                jnz sqdrw95
                mov ax,cs:[ylvisiblerange]
                cmp ax,dx
                jnc sqdrw04
                sub dx,ax
                sub si,dx
sqdrw04:        cmp si,0
                jz sqdrw95
                test si, 8000h
                jnz sqdrw95
                pop dx
                pop cx
                mov ax,cs:[x0visiblerange]
                dec ax
                cmp ax,cx
                jc sqdrw06
                mov bx,ax
                sub ax,cx
                sub di,ax
                cmp di,0
                jz sqdrw98
                test di,8000h
                jnz sqdrw98
                mov cx,bx
sqdrw06:        mov ax,cs:[y0visiblerange]
                dec ax
                cmp ax,dx
                jc sqdrw08
                mov bx,ax
                sub ax,dx
                sub si,ax
                cmp si,0
                jz sqdrw98
                test si,8000h
                jnz sqdrw98
                mov dx,bx
sqdrw08:        pop ax
                call sposmodify
                call quad
                jmp sqdrw99
sqdrw90:        pop di
                pop si
sqdrw95:        pop dx
                pop cx
sqdrw98:        pop ax
sqdrw99:        popa
                ret
squad           endp

shorline        proc
;in:CX=x,DX=ykoord,AX=color,di=lenght
                pusha
                push ax
                push cx
                push dx
                push di
                add di,cx
                mov ax,cs:[xlvisiblerange]
                dec ax
                cmp ax,cx
                jc shdrw90
                mov ax,cs:[ylvisiblerange]
                dec ax
                cmp ax,dx
                jc shdrw90
                mov ax,cs:[x0visiblerange]
                dec ax
                cmp di,ax
                jc shdrw90
                mov ax,cs:[y0visiblerange]
                dec ax
                cmp dx,ax
                jc shdrw90
                pop di
                add cx,di
                mov ax,cs:[xlvisiblerange]
                cmp ax,cx
                jnc shdrw02
                sub cx,ax
                sub di,cx
shdrw02:        cmp di,0
                jz shdrw95
                test di,8000h
                jnz shdrw95
shdrw04:        pop dx
                pop cx
                mov ax,cs:[x0visiblerange]
                dec ax
                cmp ax,cx
                jc shdrw06
                mov bx,ax
                sub ax,cx
                sub di,ax
                cmp di,0
                jz shdrw98
                test di,8000h
                jnz shdrw98
                mov cx,bx
shdrw06:
shdrw08:        mov al,cs:[linemode]
                test al,1
                jnz shdrw09
                pop ax
                call sposmodify
                call horline
                jmp shdrw99
shdrw09:        pop ax
                call sposmodify
                call xhorline
                jmp shdrw99

shdrw90:        pop di
shdrw95:        pop dx
                pop cx
shdrw98:        pop ax
shdrw99:        popa
                ret
shorline        endp

sverline        proc
;in:CX=x,DX=ykoord,AX=color,di=lenght
                pusha
                push ax
                push cx
                push dx
                push di
                add di,dx
                mov ax,cs:[xlvisiblerange]
                cmp ax,cx
                jc svdrw90
                mov ax,cs:[ylvisiblerange]
                cmp ax,dx
                jc svdrw90
                mov ax,cs:[x0visiblerange]
                dec ax
                cmp cx,ax
                jc svdrw90
                mov ax,cs:[y0visiblerange]
                dec ax
                cmp di,ax
                jc svdrw90
                pop di
                add dx,di
                mov ax,cs:[ylvisiblerange]
                cmp dx,ax
                jc svdrw04
                sub dx,ax
                sub di,dx
svdrw04:        cmp di,0
                jz svdrw95
                test di,8000h
                jnz svdrw95
                pop dx
                pop cx
                mov ax,cs:[y0visiblerange]
                dec ax
                cmp ax,dx
                jc svdrw08
                mov bx,ax
                sub ax,dx
                sub di,ax
                cmp di,0
                jz svdrw98
                test di,8000h
                jnz svdrw98
                mov dx,bx

svdrw08:        call sposmodify
                mov al,cs:[linemode]
                test al,1
                jnz svdrw09
                pop ax
                call verline
                jmp svdrw99
svdrw09:        pop ax
                call xverline
                jmp svdrw99

svdrw90:        pop di
svdrw95:        pop dx
                pop cx
svdrw98:        pop ax
svdrw99:        popa
                ret
sverline        endp

scrollverify    proc
;in:es:bp->leiro
                pusha
                push bp
                mov cx,2
scrllvrf02:     mov ax,es:[bp+4]
                sub ax,20
                mov bx,es:[bp+12]
                mov dx,es:[bp+16]
                add bx,ax
                cmp bx,dx
                jc scrllvrf10
                xor bx,bx
                sub dx,ax
                jc scrllvrf08
                mov bx,dx
scrllvrf08:     mov es:[bp+12],bx
scrllvrf10:     add bp,2
                loop scrllvrf02
                pop bp
                popa
                ret
scrollverify    endp


;---------------------------------------------------------------------------
charpos         proc
                mov cs:[charx],cx
                mov cs:[charx0],cx
                mov cs:[chary],dx
                ret
charpos         endp

charcolor       proc
                mov cs:[chcolor],ax
                ret
charcolor       endp

String          proc
;in: ds:bx-> offset
                pusha
                mov si,bx
                mov bx,cs:[chcolor]
                mov cx,cs:[charx]
                mov dx,cs:[chary]
str01:          lodsb
                cmp al,0
                jz str90
                cmp al,250
                jnz str02
                lodsw
                mov bx,ax
                jmp str01
str02:          cmp al,13
                jnz str04
                mov al,ds:[si]
                cmp al,10
                jnz str04
                lodsb
                add dx,16
                mov cx,cs:[charx0]
                jmp str01
str04:          call schardraw
                add cx,8
                jc str90
                jmp str01
str90:          popa
                ret
String          endp
;--------------------------------TXTMODE----------------------------
.386p
writedecnum     proc
;in:dx:ax=number
                shl     edx, 16
                mov     dx, ax
                mov     eax, edx
                xor     cx, cx
                xor     ebx, ebx
                mov     bl, 10
@wrtdn00:       xor     edx, edx
                div     ebx
                add     dl, '0'
                push    dx
                inc     cx
                cmp     eax, 0
                jnz     @wrtdn00
@wrtdn01:       pop     dx
                call    writechar
                loop    @wrtdn01
                ret
writedecnum     endp
.286
writechar       proc
                mov     ah, cs:[txtmod]
                cmp     ah, 0
                jnz     @wrtchgf0
                mov     ah, 2
                int     21h
@wrtchgf0:      ret
writechar       endp

escape          proc

                mov ah,4ch
                int 21h
escape          endp



;===========================================================================

txtmod               db      0
x0visiblerange       dw      0
y0visiblerange       dw      0
xlvisiblerange       dw      0
ylvisiblerange       dw      0
posx0                dw      0
posy0                dw      0
posxeltol            dw      0
posyeltol            dw      0
chcolor              dw      0
charx0               dw      0
charx                dw      0
chary                dw      0
aktivmenu            db      -1
aktivmenx            dw      0
aktivalmenu          db      -1
aktivalmenys         dw      0

maxwindow            db      0
topwindow            db      0
x0screen             dw      8000h
y0screen             dw      8000h
xmaxscreen           dw      2048
ymaxscreen           dw      1536

szuktart             db      1          ;Ha 1, csak egy tartomanyon belul all
x0szuk               dw      0
y0szuk               dw      0
xmaxszuk             dw      0
ymaxszuk             dw      0

linemode             db      1