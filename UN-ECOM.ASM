; ENcryptCOM v3.01 Unpacker
; Coded by dR.No // Delirium Tremens Group
; Greets to MERLiN for good idea ;-)

model tiny
.386
.code
org 100h

Start:
                mov     dx,offset Msg
                call    write

                pusha

                mov     ah,4Ah
                mov     bh,10h
                int     21h

                mov     si,81h
                mov     di,offset File2Run

                lodsb
                dec     si
                cmp     al,0Dh
                jne     @CopyStr
                mov     dx,offset Usage
                jmp     short write
@CopyStr:
                lodsb
                cmp     al,20h
                je      @CopyStr
                cmp     al,0Dh
                je      _EndStr
                stosb
                jmp     short @CopyStr
_EndStr:
                xor     al,al
                stosb

                mov     dx,offset File2Run
                mov     ax,3d02h
                int     21h
                jnc     FileOk
                mov     dx,offset File_Not
                jmp     short write
FileOk:
                xchg    bx,ax
                mov     ah,3Fh
                mov     dx,offset Buf
                mov     cx,-1
                int     21h

                mov     ax,4202h
                xor     cx,cx
                xor     dx,dx
                int     21h
                mov     bp,ax
                mov     ah,3Eh
                int     21h

                mov     di,offset Buf-4
                add     di,bp
                cmp     dword ptr [di],0103634Eh
                je      ID_Ok
                mov     dx,offset Not_Crypted
                jmp     short write
ID_Ok:
                mov     _oldseg,ds
                mov     ax,cs
                add     ax,1010h
                mov     es,ax
                lea     si,_start
                xor     di,di
                mov     cx,_end-_start
                rep     movsb

                push    0
                pop     ds

                mov     word ptr ds:[3*4],New3-_start
                mov     word ptr ds:[3*4+2],es

                push    es
                push    0
                retf
Write:
                mov     ah,9h
                int     21h
                ret
_start:
                push    es
                pop     ds
                mov     dx,File2Run-_start
                mov     ax,3d02h
                int     21h

                push    ax dx
                mov     dx,offset Process-_start
                mov     ah,9
                int     21h
                pop     dx ax

                push    ss
                pop     ds
                xchg    bx,ax
                mov     ah,3Fh
                mov     dx,100h
                mov     cx,-1
                int     21h

                mov     ah,3Eh
                int     21h
                popa
                push    100h
                push    ds
                push    100h
                xor     bx,bx
                xor     ax,ax
                mov     cs:(_seg-_start),cs
                push    ss ss
                pop     es ds
                iret
New1:
                push    bp
                mov     bp,sp
                cmp     word ptr [bp+2],100h
                je      Go
Back:
                pop     bp
                iret

_seg            dw      ?
_oldseg         dw      ?

Go:
                or      ax,ax
                jne     Back
                or      bx,bx
                jne     Back

                mov     ds,cs:(_seg-_start)
                mov     ah,3Ch
                mov     dx,FileName-_start
                xor     cx,cx
                int     21h

                xchg    ax,bx

                mov     ah,40h
                push    ds

                push    cs
                pop     ds
                mov     cx,FSize
                inc     cx
                inc     cx
                pop     ds

                mov     dx,100h
                mov     ds,cs:(_oldseg-_start)

                int     21h

                pop     bp

                mov     ds,cs:(_seg-_start)
                mov     dx,offset Success-_start
                mov     ah,9
                int     21h
                mov     ah,4Ch
                int     21h
New3:
                push    ds
                push    si
                push    cx

                push    es
                pop     ds

                mov     si,100h
                mov     cx,0FA00h

Search:
                cmp     dword ptr [si],000516F7h
                jne     SearchNext
                mov     dword ptr [si],90909090h
                push    cs
                pop     ds
                inc     Counter
                cmp     Counter,2
                je      Do_it
                push    es
                pop     ds
SearchNext:
                inc     si
                loop    Search

                pop     cx si ds
                iret
Do_It:
                push    es
                pop     ds

                mov     si,100h
                mov     cx,0FA00h

@SearchSize:
                cmp     dword ptr [si],46070180h
                je      SizeSrched
                inc     si
                loop    @SearchSize
SizeSrched:
                mov     cx,[si-0Dh]
                push    cs
                pop     ds
                mov     FSize,cx

                push    0
                pop     ds
                mov     word ptr ds:[1*4],offset New1-_start
                mov     word ptr ds:[1*4+2],cs

                mov     word ptr ds:[3*4],offset New3_-_start
                mov     word ptr ds:[3*4+2],cs
                pop     cx si ds
New3_:
                iret

Msg             db      0dh,0ah,'ENcryptCOM v3.01 Unpacker Coded by dR.No // ViP // DTg ',24h
Process         db      0dh,0ah,'NoW oR NeVeR! Please wait... Unpacking... $'
Success         db      'completed!',0dh,0ah,24h
Usage           db      0dh,0ah,'Usage: UN-ENCOM <FiLENAME-2-UNP>',0dh,0ah,24h
File_Not        db      0dh,0ah,'File not found',0dh,0ah,24h
Not_Crypted     db      0dh,0ah,'Specified file is not crypted with ENcryptCOM v3.01',0dh,0ah,24h
Counter         db      ?
FSize           dw      ?
FileName        db      'unpacked.com',0
File2Run        db      80 dup(0)
Buf:
_end:
End Start

; GAME!OVER