vezerlo         proc
vezerl10:       call bemenet
                call bill
                call mouse
                call mouskoordcalc
                call maskcalc
                mov al,cs:[vezmode]
                and al,0fh
                cmp al,4
                jz vezerl12
                cmp al,6
                jz vezerl12
                jmp vezerl15
vezerl12:       call winmovres
                jmp vezerl90
vezerl15:       cmp al,1
                jnz vezerl18
                call moscrollperf
                jmp vezerl90
vezerl18:       cmp al,2
                jnz vezerl20
                call mousfejbut
                jmp vezerl90
vezerl20:       call mousperf
vezerl90:       jmp vezerl10
                ret
vezerlo         endp

mousperf        proc
                mov al,cs:[mousvis]
                test al,1
                jnz mosperf02
                jmp mosperf95
mosperf02:      mov bx,cs:[esemmaszk]
                mov ah,cs:[esemtyp]
                cmp ah,1
                jnz mosperf10
                mov al,-1
                call almenuvalt
                test bl,3
                jnz mosperf04
                jmp mosperf95
mosperf04:      mov al,cs:[esemnum]
                call fomenuvalt
                jmp mosperf95
mosperf10:      cmp ah,2
                jnz mosperf20
                test bl,00110100b
                jz mosperf14
                call menucommand
                mov al,-1
                mov cs:[aktivalmenu],al
                call fomenuvalt
                jmp mosperf95
mosperf14:      mov al,cs:[esemsub]
                call almenuvalt
                jmp mosperf95
mosperf20:      call menuvezerl
                cmp ah,3
                jnz mosperf25
                test bl,4
                jnz mosperf22
                jmp mosperf95
mosperf22:      mov al,cs:[esemnum]
                call window_totop
                jmp mosperf95


mosperf25:      cmp ah,5
                jnz mosperf30
                test bl,12
                jnz mosperf26
                jmp mosperf95
mosperf26:      mov al,cs:[esemnum]
                mov cs:[oldwinnum],al
                call window_totop
                mov ah,cs:[esemsub]
                mov cs:[ablsub],ah
                mov al,2
                test bl,4
                jnz mosperf28
                cmp ah,1
                jz mosperf27
                jmp mosperf95
mosperf27:      or al,40h
mosperf28:      mov cs:[vezmode],al
                jmp mosperf95


mosperf30:      cmp ah,4
                jnz mosperf35
                test bl,4
                jnz mosperf31
                jmp mosperf95
mosperf31:      mov al,cs:[esemnum]
                mov cs:[oldwinnum],al
                call window_totop
                mov al,4
                mov cs:[vezmode],al
                mov ax,cs:[esemrelx]
                mov cs:[ablrelx],ax
                mov ax,cs:[esemrely]
                mov cs:[ablrely],ax
                jmp mosperf95
mosperf35:      cmp ah,6
                jnz mosperf45
                test bl,4
                jnz mosperf36
                jmp mosperf95
mosperf36:      mov al,cs:[esemsub]
                cmp al,0
                jnz mosperf40
                mov al,cs:[esemnum]
                mov cs:[oldwinnum],al
                call window_totop
                mov al,6
                mov cs:[vezmode],al
                mov ax,cs:[esemrelx]
                mov cs:[ablrelx],ax
                mov ax,cs:[esemrely]
                mov cs:[ablrely],ax
                mov al,cs:[esemsub]
                mov cs:[ablsub],al
                jmp mosperf95
mosperf40:      mov al,1
                mov cs:[vezmode],al
                dec al
                mov cs:[scrollspeed],al
                mov al,cs:[esemsub]
                mov cs:[ablsub],al
                mov al,cs:[esemnum]
                mov cs:[oldwinnum],al
                call window_totop
                jmp mosperf95
mosperf45:
mosperf95:
                ret
mousperf        endp

mousfejbut      proc
                mov al,cs:[esemtyp]
                cmp al,5
                jz mosfejbut14
                jmp mosfejbut60          ;csak kinyomas
mosfejbut14:    mov al,cs:[oldwinnum]
                cmp al,cs:[esemnum]
                jz mosfejbut15
                jmp mosfejbut60
mosfejbut15:    mov cl,cs:[esemsub]
                cmp cl,cs:[ablsub]
                jz mosfejbut16
                jmp mosfejbut60
mosfejbut16:    mov ah,cs:[vezmode]
                test ah,80h
                jnz mosfejbut17
                jmp mosfejbut80          ;csak benyomas
mosfejbut17:    mov bx,cs:[esemmaszk]
                test bl,30h
                jnz mosfejbut20  ;aktivalas
                test bl,8
                jz mosfejbut18
                jmp mosfejbut90  ;inaktivalas
mosfejbut18:    jmp mosfejbut99
mosfejbut20:    xor al,al
                call fejbutvalt
                mov al,cs:[oldwinnum]
                test bl,10h
                jz mosfejbut23
                cmp cl,2
                jnz mosfejbut22
                call window_close
                jmp mosfejbut95
mosfejbut22:    cmp cl,0
                jnz mosfejbut24
                call window_minimize
                jmp mosfejbut95
mosfejbut23:    cmp cl,1
                jnz mosfejbut26
                mov bl,cs:[vezmode]
                test bl,40h
                jz mosfejbut26
                mov ah,2
                jmp mosfejbut248
mosfejbut24:    cmp cl,1
                jnz mosfejbut26
                mov ah,3
                mov bl,cs:[vezmode]
                test bl,40h
                jz mosfejbut248
                mov ah,1
mosfejbut248:   call window_maximize
                jmp mosfejbut95
mosfejbut26:    jmp mosfejbut90
mosfejbut60:    mov bx,cs:[esemmaszk]
                test bl,38h
                jnz mosfejbut90
                mov al,cs:[vezmode]
                test al,80h
                jz mosfejbut99
                xor al,al
                call fejbutvalt
                mov al,2
                mov cs:[vezmode],al
                jmp mosfejbut99
mosfejbut80:    mov al,1
                shl al,cl
                call fejbutvalt
                mov al,cs:[vezmode]
                or al,80h
                mov cs:[vezmode],al
                jmp mosfejbut99
mosfejbut90:    xor al,al
                call fejbutvalt
mosfejbut95:    xor al,al
                mov cs:[vezmode],al
mosfejbut99:    ret
mousfejbut      endp

fejbutvalt      proc
                push cx
                push bx
                mov cs:[winparam],al
                mov al,cs:[oldwinnum]
                call winaddrset
                push es
                pop ds
                call mousoff
                call whbuttons
                call mouson
                pop bx
                pop cx
                ret
fejbutvalt     endp

scrollmaxspeed  equ  32
moscrollperf    proc
                pusha
                push es
                push ds
                mov bx,cs:[esemmaszk]
                test bl,10h
                jz moscrlp01
                jmp moscrlp70   ;kilepes a hurokbol
moscrlp01:      mov ah,cs:[esemtyp]
                cmp ah,6
                jz moscrlp02
                jmp moscrlp80   ;speed=0
moscrlp02:      mov ah,cs:[esemsub]
                cmp ah,0
                jnz moscrlp03
                jmp moscrlp80
moscrlp03:      mov al,cs:[esemnum]
                cmp al,cs:[oldwinnum]
                jz moscrlp04
                jmp moscrlp80
moscrlp04:      mov al,cs:[ablsub]
                cmp ah,al
                jz moscrlp06
                mov al,cs:[vezmode]
                test al,80h
                jz moscrlp05
                jmp moscrlp80
moscrlp05:      mov cs:[ablsub],ah
moscrlp06:      mov ah,cs:[vezmode]
                test ah,80h
                jnz moscrlp08
                mov ah,80h
                call wrlbutvalt
                inc ah
                mov cs:[vezmode],ah
moscrlp08:      mov al,cs:[esemnum]
                call winaddrset
                push es
                pop ds
                mov cx,es:[bp+12]
                mov dx,es:[bp+14]
                mov bl,cs:[scrollspeed]
                cmp bl,scrollmaxspeed
                jz moscrlp10
                inc bl
                mov cs:[scrollspeed],bl
moscrlp10:      xor bh,bh
                shr bl,2
                mov ah,cs:[esemsub]
                cmp ah,3
                jnz moscrlp15
                sub cx,bx
                jnc moscrlp12
                xor cx,cx
moscrlp12:      jmp moscrlp50
moscrlp15:      cmp ah,4
                jnz moscrlp20
                sub dx,bx
                jnc moscrlp17
                xor dx,dx
moscrlp17:      jmp moscrlp50
moscrlp20:      cmp ah,1
                jnz moscrlp25
                mov ax,es:[bp+16]
                sub ax,es:[bp+4]
                add ax,20
                add cx,bx
                cmp ax,cx
                jnc moscrlp22
                mov cx,ax
moscrlp22:      jmp moscrlp50
moscrlp25:      cmp ah,2
                jnz moscrlp80
                mov ax,es:[bp+18]
                sub ax,es:[bp+6]
                add ax,20
                add dx,bx
                cmp ax,dx
                jnc moscrlp27
                mov dx,ax
moscrlp27:      jmp moscrlp50
moscrlp50:      cmp cx,es:[bp+12]
                jnz moscrlp52
                cmp dx,es:[bp+14]
                jnz moscrlp52
                jmp moscrlp95
moscrlp52:      mov es:[bp+12],cx
                mov es:[bp+14],dx
                call mousoff
                call resetvisible
                call wscroll
                call wtartmezoclear
                call setwinvisible
                sub bp,2
                call swinmezo
                call mouson
                jmp moscrlp95
moscrlp70:      xor ah,ah
                call wrlbutvalt
                xor al,al
                mov cs:[vezmode],al
                jmp moscrlp95
moscrlp80:      mov ah,cs:[vezmode]
                test ah,80h
                jz moscrlp84
                xor ah,ah
                call wrlbutvalt
                inc ah
                mov cs:[vezmode],ah
moscrlp84:      xor al,al
                mov cs:[scrollspeed],al
moscrlp95:      pop ds
                pop es
                popa
                ret
moscrollperf    endp

winmovres       proc
                pusha
                mov al,1
                mov cs:[linemode],al
                mov bx,cs:[esemmaszk]
                mov al,cs:[vezmode]
                test al,2
                jz wnmvrs05
                test al,20h
                jnz wnmvrs05
                mov ah,80h
                call wrlbutvalt
                mov al,cs:[vezmode]
                or al,20h
                mov cs:[vezmode],al
wnmvrs05:       test bh,1
                jz wnmvrs20
                mov al,cs:[vezmode]
                or al,40h
                mov cs:[vezmode],al
                test al,80h
                jz wnmvrs20
                call readwinold
                call mousoff
                call border
                call mouson
wnmvrs20:       call readwinnew
                mov al,cs:[vezmode]
                test al,2
                jnz wnmvrs22
                call winmove
                jmp wnmvrs24
wnmvrs22:       call winresize
wnmvrs24:       mov cs:[oldx0],cx
                mov cs:[oldy0],dx
                mov cs:[oldxs],di
                mov cs:[oldys],si
                mov ax,cs:[esemmaszk]
                test al,00011000b
                jnz wnmvrs70
                test ah,1
                jz wnmvrs99
                call mousoff
                call border
                call mouson
                mov al,cs:[vezmode]
                or al,80h
                mov cs:[vezmode],al
                jmp wnmvrs99
wnmvrs70:       mov al,cs:[vezmode]
                test al,40h
                jz wnmvrs78
                call readwinnew
                pusha
                call readwinold
                mov al,cs:[oldwinnum]
                call winrefresh
                popa
                dec cx
                dec dx
                add si,3
                add di,2
                call mousoff
                call regioredraw
                call resetvisible
                mov al,cs:[maxwindow]
                dec al
                call windows
                call mouson
wnmvrs78:
                mov al,cs:[vezmode]
                test al,2
                jz wnmvrs79
                xor ah,ah
                call wrlbutvalt
wnmvrs79:       xor al,al
                mov cs:[vezmode],al
                jmp wnmvrs99

wnmvrs90:       mov ax,cs:[esemmaszk]
                test al,00011000b
                jnz wnmvrs70
wnmvrs99:       popa
                ret
winmovres       endp

wrlbutvalt      proc
                pusha
                push ds
                mov al,cs:[oldwinnum]
                call winaddrset
                push es
                pop ds
                mov al,cs:[ablsub]
                or al,ah
                call mousoff
                call wrlbutt
                call mouson
                pop ds
                popa
                ret
wrlbutvalt      endp

winaddrset      proc
;in:al=handler
;out:es:bp->leiro
                push ax
                push bx
                push ds
                mov bl,al
                xor bh,bh
                mov ax,cs:[winsorsegm]
                mov ds,ax
                shl bx,3
                inc bh
                mov bp,ds:[bx]
                mov ax,ds:[bx+2]
                mov es,ax
                pop ds
                pop bx
                pop ax
                ret
winaddrset      endp

readwinold      proc
                mov dx,cs:[oldy0]
                mov di,cs:[oldxs]
                mov si,cs:[oldys]
                mov cx,cs:[oldx0]
                ret
readwinold      endp

readwinnew      proc
                mov al,cs:[oldwinnum]
                call winaddrset
                mov cx,es:[bp]
                mov dx,es:[bp+2]
                mov di,es:[bp+4]
                mov si,es:[bp+6]
                ret
readwinnew      endp

winmove         proc
                mov cx,cs:[mousx]
                add cx,cs:[x0screen]
                sub cx,cs:[ablrelx]
                mov dx,cs:[mousy]
                sub dx,cs:[ablrely]
                jc wnmv08
                cmp dx,19
                jnc wnmv10
wnmv08:         mov dx,19
wnmv10:         add dx,cs:[y0screen]
                ret
winmove         endp

winresize       proc
                mov ax,cs:[mousx]
                add ax,cs:[x0screen]
                add ax,di
                sub ax,cx
                jc wnrs10
                sub ax,cs:[ablrelx]
                jc wnrs10
                cmp ax,59
                jnc wnrs15
wnrs10:         mov ax,59
wnrs15:         mov di,ax
                mov ax,cs:[mousy]
                add ax,cs:[y0screen]
                add ax,si
                sub ax,dx
                jc wnrs20
                sub ax,cs:[ablrely]
                jc wnrs20
                cmp ax,73
                jnc wnrs25
wnrs20:         mov ax,73
wnrs25:         mov si,ax
                ret
winresize       endp

winrefresh      proc
                call winaddrset
                mov es:[bp],cx
                mov es:[bp+2],dx
                mov es:[bp+4],di
                mov es:[bp+6],si
                call scrollverify
                ret
winrefresh      endp

menuvezerl      proc
                push ax
                push bx
                mov al,-1
                mov bx,cs:[esemmaszk]
                test bl,00111100b
                jz mnvez50
                call fomenuvalt
                jmp mnvez99
mnvez50:        call almenuvalt
mnvez99:        pop bx
                pop ax
                ret
menuvezerl      endp

fomenuvalt      proc
;in: al=menupont
                cmp al,cs:[aktivmenu]
                jz fmvalt99
                call mousoff
                call almenutorl
                mov cs:[aktivmenu],al
                call fomenuszovdrw
                cmp al,-1
                jz fmvalt90
                call almenudrw
fmvalt90:       call mouson
fmvalt99:       ret
fomenuvalt      endp

almenuvalt      proc
;in: al=menupont
                push ax
                cmp al,cs:[aktivalmenu]
                jz amvalt99
                mov cs:[aktivalmenu],al
                mov ah,cs:[aktivmenu]
                cmp ah,-1
                jz amvalt99
                call mousoff
                call almenuszovdrw
                call mouson
amvalt99:       pop ax
                ret
almenuvalt      endp

menucommand     proc
                mov al,cs:[esemnum]
                cmp al,0
                jnz menucomm10
                call filemenu
menucomm10:
                ret
menucommand     endp

filemenu        proc
                mov al,cs:[esemsub]
                cmp al,4
                jnz filmn10
                call exit
filmn10:
                ret
filemenu        endp
;------------------------------------
maskcalc        proc
                pusha
                mov cx,cs:[esemmaszk]
                and ch,3
                xor cl,cl
                xor bh,bh
                mov bl,cs:[mgomb]
                and bl,3
                mov al,bl
                mov ah,cs:[mgombold]
                mov cs:[mgombold],bl
                shl ax,2
                mov dx,ax
                not ah
                and al,ah
                or bl,al
                shl dx,2
                not dl
                and dl,dh
                or bl,dl
                or bx,cx
                mov cs:[esemmaszk],bx
                popa
                ret
maskcalc        endp

mouskoordcalc   proc
                pusha
                call mousfomenue
                jc moskordc90
                call mousalmenue
                jc moskordc90
                call mousablake
                jc moskordc90
                mov al,0
                mov cs:[esemtyp],0
moskordc90:     popa
                ret
mouskoordcalc   endp

mousfomenue     proc
                mov cx,cs:[mousx]
                mov dx,cs:[mousy]
                cmp dx,16
                jnc mosfmno
                mov al,1
                mov cs:[esemtyp],al
                mov cs:[esemrely],dx
                mov cs:[esemrelx],cx
                xor dx,dx
                mov bx,cs:[menusegm]
                mov es,bx
                xor bp,bp
                xor ah,ah
mosfm20:        mov bx,es:[bp+2]
                cmp bx,0
                jz mosfm60
                mov ds,bx
                mov bx,es:[bp]
                mov al,ds:[bx]
                inc bx
                add al,3
                shl al,3
                add dl,al
                adc dh,0
                cmp cx,dx
                jc mosfm80
mosfm60:        add bp,8
                inc ah
                cmp ah,8
                jnz mosfm20
                mov ah,-1
mosfm80:        mov cs:[esemnum],ah
                stc
                ret
mosfmno:        clc
                ret
mousfomenue     endp

mousalmenue     proc
                pusha
                mov al,cs:[aktivmenu]
                cmp al,-1
                jz mosalmno
                mov cx,cs:[mousx]
                mov dx,cs:[mousy]
                mov bx,16
                cmp dx,bx
                jc mosalmno
                add bl,3
                add bx,cs:[aktivalmenys]
                cmp bx,dx
                jc mosalmno
                mov bx,cs:[aktivmenx]
                sub bx,cs:[x0screen]
                cmp cx,bx
                jc mosalmno
                add bx,8*16+1
                cmp bx,cx
                jc mosalmno
                mov al,2
                mov cs:[esemtyp],al
                mov cs:[esemrelx],cx
                sub dx,19
                mov ax,dx
                shr ax,4
                and dx,15
                mov cs:[esemrely],dx
                mov cs:[esemsub],al
                mov al,cs:[aktivmenu]
                mov cs:[esemnum],al
                popa
                stc
                ret
mosalmno:       popa
                clc
                ret
mousalmenue     endp

mousablake      proc
                pusha
                mov bx,cs:[winsorsegm]
                mov ds,bx
                mov al,cs:[maxwindow]
                cmp al,0
                jnz mosabl08
                jmp mosablno
mosabl08:       dec al
mosabl10:       xor ah,ah
                mov bx,ax
                mov bl,ds:[bx]
                shl bx,3
                inc bh
                mov bp,ds:[bx]
                mov dx,ds:[bx+2]
                mov es,dx
                mov cl,es:[bp+8]
                test cl,10h
                jnz mosabl30
                mov cx,cs:[mousx]
                add cx,cs:[x0screen]
                mov dx,cs:[mousy]
                add dx,cs:[y0screen]
                cmp cx,es:[bp]
                jc mosabl30
                cmp dx,es:[bp+2]
                jc mosabl30
                sub cx,es:[bp]
                mov di,es:[bp+4]
                add di,2
                cmp cx,di
                jnc mosabl30
                sub dx,es:[bp+2]
                mov si,es:[bp+6]
                add si,2
                cmp dx,si
                jnc mosabl30
                jmp mosabl40
mosabl30:       sub al,1
                jnc mosabl10
                jmp mosablno
mosabl40:       mov bx,ax
                mov al,ds:[bx]
                mov cs:[esemnum],al
                mov al,3
                mov cs:[esemtyp],al
                mov cs:[esemrelx],cx
                mov cs:[esemrely],dx
                call ablmezocalc
mosabl90:       popa
                stc
                ret
mosablno:       popa
                clc
                ret
mousablake      endp

ablmezocalc     proc
                mov bl,ds:[bx]
                shl bx,3
                inc bh
                mov bp,ds:[bx]
                mov bx,ds:[bx+2]
                mov es,bx

                cmp dx,16
                jnc ablmzc20
                mov al,5
                mov cs:[esemtyp],al
                mov al,es:[bp+8]
                cmp dx,15
                jnc ablmzc15
                cmp dx,1
                jc ablmzc15
                cmp cx,2
                jc ablmzc15

                cmp cx,16
                jnc ablmzc02
                test al,4
                jz ablmzc15     ;fejlec tisztan
                mov al,2
                mov cs:[esemsub],al
                jmp ablmzc90
ablmzc02:       mov di,es:[bp+4]
                sub di,cx
                cmp di,2
                jc ablmzc15
                cmp di,15
                jnc ablmzc08
                test al,2
                jz ablmzc04
                mov al,1
                mov cs:[esemsub],al
                jmp ablmzc90
ablmzc04:       test al,1
                jz ablmzc15
                xor al,al
                mov cs:[esemsub],al
                jmp ablmzc90
ablmzc08:       cmp di,17
                jc ablmzc15
                cmp di,30
                jnc ablmzc15
                and al,3
                xor al,3
                jnz ablmzc15
                xor al,al
                mov cs:[esemsub],al
                jmp ablmzc90
ablmzc15:       mov al,4
                mov cs:[esemtyp],al
                jmp ablmzc90
ablmzc20:       mov al,es:[bp+8]
                test al,32
                jz ablmzc40
                mov ax,es:[bp+4]
                mov bx,es:[bp+6]
                sub ax,cx
                sub bx,dx
                cmp ax,18
                jc ablmzc22
                cmp bx,18
                jc ablmzc22
                jmp ablmzc40
ablmzc22:       mov ah,0
                mov si,offset [wrlbuts]
                push cs
                pop ds
ablmzc23:       call mouswrlbute
                jc ablmzc25
                add si,3
                inc ah
                cmp ah,5
                jnz ablmzc23
                jmp ablmzc30
ablmzc25:       mov cs:[esemsub],ah
                mov al,6
                mov cs:[esemtyp],al
                jmp ablmzc90
ablmzc30:       ;scrollbar
ablmzc40:       ;objok
ablmzc90:
                ret
ablmezocalc     endp

mouswrlbute     proc
;in: es:[bp]-> ablakleiro, cx=relx, dx=rely, cs:[si]-> button koords
                push ax
                mov al,cs:[si]
                cbw
                test al,128
                jz mwrlbtte10
                add ax,es:[bp+4]
mwrlbtte10:     cmp cx,ax
                jc mwrlbtteno
                add ax,16
                cmp ax,cx
                jc mwrlbtteno
                mov al,cs:[si+1]
                cbw
                test al,128
                jz mwrlbtte14
                add ax,es:[bp+6]
mwrlbtte14:     cmp dx,ax
                jc mwrlbtteno
                add ax,16
                cmp ax,dx
                jc mwrlbtteno
                stc
                pop ax
                ret
mwrlbtteno:     clc
                pop ax
                ret
mouswrlbute     endp

;-----------------------------------

bill            proc
                mov ax,cs:[bscan]
                cmp al,27
                jnz @bill10
                call exit
@bill10:
                cmp al,32
                jnz @bill12
                mov al,cs:[mousvis]
                cmp al,1
                jz @bill102
                call mouson
                jmp @bill99
@bill102:       call mousoff
                jmp @bill99
@bill12:        cmp al,13
                jnz @bill14
                mov al,1
                call window_close
                jmp @bill99
@bill14:

@bill99:        ret
bill            endp

mouson          proc
                pusha
                mov al,cs:[mousvis]
                cmp al,1
                jz mouson99
                call resetvisible
                mov ax,3
                int 33h
                shr cx,3
                shr dx,3
                mov cs:[mousoldx],cx
                mov cs:[mousoldy],dx
                call moussave
                add cx,cs:[x0screen]
                add dx,cs:[y0screen]
                dec cx
                xor ah,ah
                mov al,cs:[moustyp]
                call ssysdraw
                mov al,1
                mov cs:[mousvis],al
mouson99:       popa
                ret
mouson          endp

mousoff         proc
                pusha
                mov al,cs:[mousvis]
                cmp al,1
                jnz mousof99
                mov cx,cs:[mousoldx]
                mov dx,cs:[mousoldy]
                call mousrestor
                xor al,al
                mov cs:[mousvis],al
mousof99:       popa
                ret
mousoff         endp

mouse           proc
                pusha
                mov cx,cs:[mousx]
                mov dx,cs:[mousy]
                mov al,cs:[mousvis]
                cmp al,1
                jnz mous99
                mov ax,cs:[mousoldx]
                mov bx,cs:[mousoldy]
                cmp cx,ax
                jnz mous20
                cmp dx,bx
                jz mous95
mous20:         push ax
                mov ax,cs:[esemmaszk]
                or ah,1
                mov cs:[esemmaszk],ax
                pop ax
                mov cx,ax
                mov dx,bx
                call mousrestor
                call resetvisible
                mov cx,cs:[mousx]
                mov dx,cs:[mousy]
                mov cs:[mousoldx],cx
                mov cs:[mousoldy],dx
                call moussave
                add cx,cs:[x0screen]
                add dx,cs:[y0screen]
                dec cx
                xor ah,ah
                mov al,cs:[moustyp]
                call ssysdraw
                jmp mous99
mous95:         mov ax,cs:[esemmaszk]
                and ah,0feh
                mov cs:[esemmaszk],ax
mous99:         popa
                ret
mouse           endp



input           proc
;out:cx,dx=eg‚r koord,bx=eg‚rgombok,ax=bill.Scan ‚s ASCII k¢d
                mov ah,1
                int 16h
                jz @i01
@i00:           mov ah,0
                int 16h
                jmp @i02
@i01:           xor ax,ax
@i02:           push ax
                mov ax,3
                int 33h
                shr cx,3
                shr dx,3
                pop ax
                ret
input endp

bemenet         proc
                call input
                mov cs:[mgomb],bl
                mov cs:[bscan],ax
                mov cs:[mousx],cx
                mov cs:[mousy],dx
                ret
bemenet         endp
;=========================================================================
vezmode db 0

mgomb           db      0
bscan           dw      0

mgombold        db      0
scrollspeed     db      0


mousx           dw      12
mousy           dw      2
mousoldx        dw      0
mousoldy        dw      0
mousfirstx      dw      0
mousfirsty      dw      0
moustyp         db      0                                  ;Type of mouse cursor
mousvis         db      0                                  ;1 if the  mouse is visible

ablrelx         dw      0               ;For move and resize
ablrely         dw      0
oldx0           dw      0
oldy0           dw      -1
oldxs           dw      0
oldys           dw      0
oldwinnum       db      0
ablsub          db      0
ablmaszk        db      0

;Az eger esemeny rogzitese
    esemtyp     db      0
    esemnum     db      0
    esemsub     db      0
    esemrelx    dw      0
    esemrely    dw      0
    esemmaszk   dw      0
