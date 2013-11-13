Menufilesize equ 312

meminst         proc
                push    cs
                pop     ds
                call    xmsdetect
                jc      @mierr
@mi01:          call    writmemsiz
                call    memallocs
                ret
@mierr:         mov     dx, offset err0sz
                call    message
                stc
                ret
meminst         endp

xmsdetect       proc
                mov     dx, offset mesg4sz
                call    message
                mov     ax, 4300h
                int     2fh
                cmp     al, 80h
                jz      @xmsdet01
                mov     dx, offset mesg2sz
                call    message
                stc
                ret
@xmsdet01:      mov     ax, 4310h
                int     2fh
                mov     word ptr cs:[memcalladdr], bx
                mov     word ptr cs:[memcalladdr+2], es
                mov     dx, offset mesg1sz
                call    message
                clc
                ret
xmsdetect       endp

memfunc         proc
;ah=1:xms_available;out:dx:ax=size
;ah=2:xms_request;in:dx=size(Kbyte);out:dx:ax=handler
;ah=3:xms_free;in:dx:ax=handler
;ah=4:xms_read;in:dx:ax=handler;es:di=segmaddr;cx=size(byte)
;ah=5:xms_write;in:dx:ax=handler;ds:si=segmaddr;cx=size(byte)
;ah=6:conv_mem_request;in:dx=size(byte);out:dx=segmaddr
;ah=7:conv_mem_free;in:dx=segmaddr

@mmf00:         dec     ah
                jnz     @mmf01
                mov     ah, 8
                call    dword ptr cs:[memcalladdr]
                mov     ax, dx
                shl     ax, 10
                shr     dx, 6
                clc
                ret

@mmf01:         dec     ah
                jnz     @mmf02
                mov     ah, 9
                call    dword ptr cs:[memcalladdr]
                cmp     ax, 1
                ret

@mmf02:         dec     ah
                jnz     @mmf03
                mov     ah, 0ah
                call    dword ptr cs:[memcalladdr]
                ret

@mmf03:         stc
                ret
memfunc         endp

writmemsiz      proc
                mov     dx, offset mesg5sz
                call    message
                mov     ah, 1
                call    memfunc
                call    writedecnum
                mov     dx, offset mesg6sz
                call    message
                ret
writmemsiz      endp

memallocs       proc
                mov     ah, 48h
                mov     bx, 4096
                int     21h
                mov     cs:[filesegm], ax
                mov     ah, 48h
                mov     bx, 512
                int     21h
                mov     cs:[presegm], ax
                mov     ah, 48h
                mov     bx, 256
                int     21h
                mov     cs:[sufsegm], ax
                mov     ah, 48h
                mov     bx, 256
                int     21h
                mov     cs:[grdrsegm], ax
                mov     ah, 48h
                mov     bx, maxicon*16
                int     21h
                mov     cs:[mousegm], ax
                mov     ah, 48h
                mov     bx, 32
                int     21h
                mov     cs:[moussavsegm], ax
                mov     ah, 48h
                mov     bx, 256
                int     21h
                mov     cs:[fontsegm], ax
                mov     ah,48h
                mov     bx,maxobj/4
                int     21h
                mov     cs:[objsegm],ax
                call    memtorl
                mov     ah, 48h
                mov     bx,menufilesize/16+1
                int     21h
                mov     cs:[menusegm],ax
                mov     ah, 48h
                mov     bx, 144
                int     21h
                mov     cs:[winsorsegm], ax
                call    memtorl
                mov ah,48h
                mov bx,4096
                int 21h
                mov cs:[debugsegm],ax
                ret
memallocs       endp

memtorl proc
;in:ax=segm,bx=size/16
        mov cl,3
        shl bx,cl
        mov cx,bx
        mov es,ax
        xor di,di
        xor ax,ax
        cld
        rep stosw
        ret
memtorl endp


memcalladdr     dd      0

filesegm        dw      0                                  ;4096 =64 Kbyte

objsegm         dw      0                                  ; ~64 (maxobj/4)
grdrsegm        dw      0                                  ; 256
presegm         dw      0                                  ; 512
sufsegm         dw      0                                  ; 256
mousegm         dw      0                                  ;~320 (maxicon*16)
moussavsegm     dw      0                                  ;  32
fontsegm        dw      0                                  ; 256
menusegm        dw      0                                  ;  16 (menufilesize/16)
winsorsegm      dw      0                                  ; 144 (16*8+16)
                                                           ;---------
                                                           ;1856 ~29 Kbyte
debugsegm dw 0