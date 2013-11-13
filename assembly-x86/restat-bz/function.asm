;Functions

Window_open     proc
;ds:bx->leiro
;out:CY:1=error, 0:OK; dl=handler
                push es
                push bp
                push ax
                push dx
                mov al,cs:[maxwindow]
                cmp al,255
                jz @winopenerr
                inc al
                mov cs:[maxwindow],al
                dec al
                mov dx,cs:[winsorsegm]
                mov es,dx
                call srchfreehand
                xor ah,ah
                mov bp,ax
                mov al,dl
                mov es:[bp],al
                mov bp,ax
                shl bp,3
                add bp,100h
                mov es:[bp],bx
                mov dx,ds
                mov es:[bp+2],dx
                mov ah,al
                cmp al, 0
                jz @winopen20
                dec al
@winopen20:     call windows
                call almenudrw
                pop dx
                mov dl,ah
                mov cs:[topwindow],ah
                clc
@winopen95:     pop ax
                pop bp
                pop es
                ret
@winopenerr:    stc
                pop dx
                jmp @winopen95
                ret
Window_open     endp

Window_close    proc
;in:al=window handler
                pusha
                push ds
                push ax
                call windowsearch
                jc @winclos99
                call windowdelete
                pop ax
                xor ah,ah
                shl ax,3
                inc ah
                mov bp,ax
                mov ax,cs:[winsorsegm]
                mov es,ax
                mov ax,es:[bp+2]
                mov ds,ax
                mov bx,es:[bp]
                xor ax,ax
                mov es:[bp+2],ax
                mov cx,ds:[bx]
                mov dx,ds:[bx+2]
                mov di,ds:[bx+4]
                mov si,ds:[bx+6]
                dec cx
                dec dx
                add si,3
                add di,2
                mov al,cs:[maxwindow]
                dec al
                mov cs:[maxwindow],al
                call mousoff
                call regioredraw
                dec al
                xor ah,ah
                mov bx,ax
                mov al,es:[bx]
                mov cs:[topwindow],al
                mov al,bl
                call windows
                call mouson
@winclos99:     pop ds
                popa
                ret
Window_close    endp

Window_maximize proc
;in:al=window handler, ah=max.mode: 1: only horizontal, 2:only vertical,
;ah=3:horizontal and vertical resize
                pusha
                push ds
                call winaddrset
                mov cx,es:[bp]
                mov dx,es:[bp+2]
                mov di,es:[bp+4]
                mov si,es:[bp+6]
                test ah,1
                jz @winmax20
                mov cx,cs:[x0screen]
                mov di,cs:[horsiz]
                dec di
                dec di
@winmax20:      test ah,2
                jz @winmax30
                mov dx,cs:[y0screen]
                add dx,19
                mov si,cs:[versiz]
                sub si,20
@winmax30:      mov es:[bp],cx
                mov es:[bp+2],dx
                mov es:[bp+4],di
                mov es:[bp+6],si
                call scrollverify
                call mousoff
                mov al,cs:[maxwindow]
                dec al
                call windows
                call mouson
                pop ds
                popa
                ret
Window_maximize endp

Window_minimize proc
;in:al=window handler
                pusha
                push ds
                call winaddrset
                mov al,es:[bp+8]
                test al,10h
                jnz @winmin90
                or al,10h
                mov es:[bp+8],al
                mov cx,es:[bp]
                mov dx,es:[bp+2]
                mov di,es:[bp+4]
                mov si,es:[bp+6]
                dec cx
                dec dx
                add si,3
                add di,2
                call mousoff
                call regioredraw
                call mouson
@winmin90:      pop ds
                popa
                ret
Window_minimize endp

Window_totop    proc
;in:al=window handler
                pusha
                push ds
                cmp al,cs:[topwindow]
                jz @wintotop90
                mov cs:[topwindow],al
                call windowsearch
                jc @wintotop90
                call windowdelete
                mov bl,cs:[maxwindow]
                xor bh,bh
                dec bl
                mov ds:[bx],al
                cmp bl,1
                jc @wintotop90
                dec bl
                xor al,al
                mov cs:[szuktart],al
                call setscreenvisible
                mov al,bl
                call mousoff
                call windows
                call mouson
@wintotop90:    pop ds
                popa
                ret
Window_totop    endp

windowsearch    proc
;in:al=handler
;out:CY=error: ah=number in queue
                push ds
                push bx
                mov bx,cs:[winsorsegm]
                mov ds,bx
                xor bx,bx
winsrch10:      mov ah,bl
                cmp al,ds:[bx]
                jz winsrch99
                inc bl
                cmp bl,cs:[maxwindow]
                jnz winsrch10
                stc
winsrch99:      pop bx
                pop ds
                ret
windowsearch    endp

windowdelete    proc
;in: ah=number in queue
                pusha
                push es
                mov bx,cs:[winsorsegm]
                mov ds,bx
                mov es,bx
                mov bl,ah
                xor bh,bh
                mov di,bx
                mov si,bx
                inc si
                mov cl,cs:[maxwindow]
                xor ch,ch
                sub cl,bl
                cld
                rep movsb
                pop es
                popa
                ret
windowdelete    endp

srchfreehand    proc
;out:dl=handler
                push ax
                push bx
                mov bx,cs:[winsorsegm]
                mov es,bx
                mov bx,102h
                xor dl,dl
schfrh10:       mov ax,es:[bx]
                cmp ax,0
                jz schfrh90
                add bx,8
                inc dl
                jnc schfrh10
schfrh90:       pop bx
                pop ax
                ret
srchfreehand    endp
