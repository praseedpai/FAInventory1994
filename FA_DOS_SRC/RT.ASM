;Program to interface with clipper
;function Ret_num Can be Used to get a charecter matrix of
;a Particular charcahter
;Usage :-         RET_NUM(65*8+<n>)
; 0 <= n <=7

       Public ptRET_NUM
       Public ptGr_mode
       Public ptTr_mode
       Public Ptdtos
       Public   ptpset
       .model large
     extrn __parni:far
     extrn __retni:far
     extrn __retc:far
     extrn __pards:far
      .Code

PTRET_NUM  proc  far
   push  bp
   mov   bp,sp
   sub   sp,4
   mov   word ptr [bp-4],1111101001101110b
   mov   word ptr [bp-2],1111000000000000b
   mov   ax,1
   push  ax
   call  __parni
   pop   cx
   add   word ptr [bp-4],ax
   les   bx,dword ptr [bp-4]
   mov   al,es:[bx]
   xor   ah,ah
   push  ax
   call   __retni
   pop   cx
   pop   si
   mov   sp,bp
   pop   bp
   ret
PTRET_NUM  endp
; next function can be used to Set Screen to Graphics mode
; Usage :-  Gr_mode(<n>)
; 3 for textmode   : 4,5,6 for graphics

PTGr_mode Proc Far
     Mov Ah,00
     mov al,05
     int 10h
     retf
PTGr_mode endp
; next function can be used to set screen to text mode
PTTr_mode Proc Far
     Mov Ah,00
     mov al,03
     int 10h
     retf
PTTr_mode endp
; next function is anlogous to Dtos function

PTDTOS proc far
   mov   ax,1
   push  ax
   call  __pards
   pop   cx
   push  dx
   push  ax
   call  __retc
   pop cx
   pop cx
   retf
PTDTOS ENDP

Ptpset proc far
    Push ax
    mov ax,1
    push ax
    call __parni
    add sp,2
    mov dx,ax
    mov ax,2
    push ax
    call __parni
    add sp,2
    mov cx,ax
    mov ah,0ch
    int 10h
    pop ax
   retf
 Ptpset endp











end