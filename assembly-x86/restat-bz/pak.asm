;load from .mpk files and lzw decompress
;LZW code by MikroLab (Andr s B rth zi)<-Megathanx

sysload proc
;in:cs:dx->filename,al=sorsz m,es:di->c‚l memc¡m
               push ds
               push cs
               pop ds
               push ax
               mov ax,3d00h
               int 21h
               mov bx,ax
               pop ax
               xor ah,ah
               mov cl,3
               shl ax,cl
               add ax,6
               mov dx,ax
               xor cx,cx
               mov ax,4200h
               int 21h
               mov ah,3fh
               mov cx,8
               mov dx,offset sysfhead
               int 21h
               mov dx,cs:[sysfoffs]
               mov cx,cs:[sysfoffs+2]
               mov ax,4200h
               int 21h
               mov cx,cs:[sysflen]
               mov ax,cs:[filesegm]
               mov ds,ax
               xor dx,dx
               mov ah,3fh
               int 21h
               mov ah,3eh
               int 21h
               xor si,si
               call lzwdecompress
               mov cx,di
               pop ds
               ret
sysload endp

sysfhead label byte
sysfoffs dw 0,0
sysflen  dw 0
         dw 0
;------------------------------LZW---------------------------------------
lzwclear_code equ 256
lzwend_code equ 257
lzwfirst equ 258
lzwmaximum_table equ 4096


lzwdecompress proc

          mov cs:rd_buffer,si
          mov cs:rd_pointer,0

decompress_restart:
          mov cs:bitlimit,512
          mov cs:nbit,9
          mov cs:free_ent,lzwfirst

          call read_value
          cmp ax,lzwend_code
          jne folyt1
          ret
folyt1:   mov cs:oldcode,ax
          mov cs:finchar,al
          stosb

mainloop: call read_value
          cmp ax,lzwclear_code
          je  decompress_restart
          cmp ax,lzwend_code
          jne folyt2
          ret

folyt2:   mov cs:newcode,ax
          lea si,zivstack

          cmp cs:free_ent,ax
          jnbe bpc_if1
          mov al,cs:finchar
          mov cs:[si],al
          inc si
          mov ax,cs:oldcode
bpc_if1:

bpc_loc2:
          or ah,ah
          je bpc_if2
          xchg bx,ax
          push es
          mov dx,cs:[sufsegm]
          mov es,dx
          mov al,es:[bx]
          mov cs:[si],al
          inc si
          shl bx,1
          mov dx,cs:[presegm]
          mov es,dx
          mov ax,es:[bx]
          pop es
          jmp bpc_loc2
bpc_if2:  mov cs:[si],al
          inc si
          mov cs:finchar,al
bpc_loc3: dec si
          mov al,cs:[si]
          stosb
          cmp si,offset zivstack
          jne bpc_loc3

          mov bx,cs:free_ent
          cmp bx,lzwmaximum_table
          jnb bpc_if4
          mov al,cs:finchar
          push es
          mov dx,cs:[sufsegm]
          mov es,dx
          mov es:[bx],al
          mov ax,cs:oldcode
          shl bx,1
          mov dx,cs:[presegm]
          mov es,dx
          mov es:[bx],ax
          pop es
          inc cs:free_ent
bpc_if4:  mov ax,cs:newcode
          mov cs:oldcode,ax
          jmp mainloop
read_value:
          mov ax,cs:free_ent
          cmp cs:bitlimit,ax
          jne bpc_if5
          cmp byte ptr cs:nbit,12
          je bpc_if5
          inc cs:nbit
          shl cs:bitlimit,1
bpc_if5:  cmp cs:rd_pointer,32768
          jna bpc_if6
          add cs:rd_buffer,4096
          sub cs:rd_pointer,32768
bpc_if6:  mov bx,cs:rd_pointer
          mov si,bx
          mov bp,cs:rd_buffer
          add bl,cs:nbit
          adc bh,0

          mov cx,si
          shr si,1
          shr si,1
          shr si,1
          and cl,7

          mov ax,ds:[bp][si]
          xchg al,ah
          xor dh,dh
          shl ax,cl

          mov ch,16
          sub ch,cl
          sub ch,cs:nbit

          jnb bpc_if7
          mov cl,8
          add cl,ch
          mov dh,ds:[bp][si][2]
          shr dh,cl
bpc_if7:

          xor bx,bx
          mov bl,cs:nbit
          add cs:rd_pointer,bx
          mov cl,16
          sub cl,bl
          shr ax,cl
          or al,dh
bpc_ret1:
bpc_ret2:
ret
lzwdecompress endp

zivstack db  512 dup(?)
finchar db ?
oldcode dw ?
newcode dw ?
rd_buffer dw ?
rd_pointer dw ?
bitlimit dw ?
nbit db ?
free_ent dw ?