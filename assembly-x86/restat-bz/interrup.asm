function proc

        iret
function endp

setidoz proc
        mov ax,351ch
        int 21h
        mov cs:[oldint1c],bx
        mov bx,es
        mov cs:[oldint1c+2],bx
        mov ax,251ch
        mov dx,offset metronom
        int 21h
        ret
setidoz endp

residoz proc
        mov ax,251ch
        mov dx,cs:[oldint1c+2]
        mov ds,dx
        mov dx,cs:[oldint1c]
        int 21h
        ret
residoz endp

idolekerd proc
;in:ax=sz ml l¢
;out:CY=lej rt-e(CY=1 ha lej rt),bh=sebess‚g,bl=sz ml l¢ akt.‚rt‚ke,dx=info
        cmp ax,maxobj+1
        jc @ile0
        xor bx,bx
        ret
@ile0:  push ax
        push ds
        shl ax,2
        mov bx,ax
        mov ax,cs:[objsegm]
        mov ds,ax
        mov dx,ds:[bx+2]
        mov bx,ds:[bx]
        cmp bh,0
        jz @ile1
        cmp bh,bl
@ile1:  pop ds
        pop ax
        ret
idolekerd endp

idoallit proc
;in:ax=sz ml l¢,bl=sz ml l¢ £j ‚rt‚k
        cmp ax,maxobj+1
        jc @ibe0
        ret
@ibe0:  push ax
        push bx
        push ds
        shl ax,1
        shl ax,1
        push bx
        mov bx,ax
        mov ax,cs:[objsegm]
        mov ds,ax
        pop ax
        mov ds:[bx],al
        pop ds
        pop bx
        pop ax
        ret
idoallit endp

ujido proc
;in:cl=sebess‚g,dx=info
;out:ax=sz ml l¢ sorsz ma
        mov ax,cs:[objsegm]
        mov es,ax
        xor bx,bx
@ujid0: mov al,es:[bx+1]
        cmp al,0
        jz @ujid1
        add bx,4
        cmp bx,maxobj*4
        jc @ujid0
        stc
        ret
@ujid1: xor ch,ch
        mov es:[bx],cx
        mov es:[bx+2],dx
        mov ax,bx
        mov cl,4
        shr ax,cl
        clc
        ret
ujido endp

metronom proc
        push si
        push es
        push bx
        push cx
        mov bl,1
        mov cs:[ut0],bl
        mov cx,maxobj
        mov bx,cs:[objsegm]
        mov es,bx
        xor bx,bx
@metro0:inc byte ptr es:[bx]
        add bx,4
        loop @metro0
        pop cx
        pop bx
        pop es
        pop si
        jmp dword ptr cs:[oldint1c]
metronom endp

newintA0 proc
        push ax
        push bx
        push dx
        push ds
        push es
        mov ah,35h
        mov al,0f0h
        int 21h
        mov cs:[oldinta0],bx
        mov bx,es
        mov cs:[oldinta0+2],bx
        push cs
        pop ds
        mov ah,25h
        mov al,0A0h
        mov dx,offset function
        int 21h
        pop es
        pop ds
        pop dx
        pop bx
        pop ax
        ret
newintA0 endp

newint24 proc
        push ax
        push bx
        push dx
        push ds
        push es
        mov ah,35h
        mov al,024h
        int 21h
        mov cs:[oldint24],bx
        mov bx,es
        mov cs:[oldint24+2],bx
        push cs
        pop ds
        mov ah,25h
        mov al,024h
        mov dx,offset kritikal
        int 21h
        pop es
        pop ds
        pop dx
        pop bx
        pop ax
        ret
newint24 endp

inta0vissza proc
        push ax
        push dx
        push ds
        mov dx,cs:[oldinta0+2]
        mov ds,dx
        mov dx,cs:[oldinta0]
        mov ah,25h
        mov al,0a0h
        int 21h
        pop ds
        pop dx
        pop ax
        ret
inta0vissza endp

int24vissza proc
        push ax
        push dx
        push ds
        mov dx,cs:[oldint24+2]
        mov ds,dx
        mov dx,cs:[oldint24]
        mov ah,25h
        mov al,024h
        int 21h
        pop ds
        pop dx
        pop ax
        ret
int24vissza endp

kritikal proc
        push ax
        push dx
        mov dl,7
        mov ah,2
        int 21h
        mov ah,0
        int 16h
        pop dx
        pop ax
        mov al,1
        jmp dword ptr cs:[oldint24]
kritikal endp

;=========================================================================
oldinta0 dw 0,0
oldint24 dw 0,0
oldint1c dw 0,0
ut0 db 0
