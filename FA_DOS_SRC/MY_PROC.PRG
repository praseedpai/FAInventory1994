
*-----------FUNCTION ERROR MESSAGE TO DISPLAY ERROR MESSAGE
*-----------CALL WITH ONE PARAMETER
*--------------USAGE  err_msg( <message>)
function err_msg
param st
PRIVATE kq,kek,wid
kq=len(st)
wid= kq+6
mn=SEtcolor()
kek=savescreen(19,39-int(wid/2),21,39+int(wid/2))
setcolor("/w")
set cursor off
@ 19,39-int(wid/2)  clea to  21,39+int(wid/2)
@ 19,39-int(wid/2) to  21,39+int(wid/2) double
@ 20,39-int(kq/2) say st
tone(800,2)
tone(400,2)
ret_val=inkey(0)
SETCOLOr(mn)
restscreen(19,39-int(wid/2),21,39+int(wid/2),kek)
set cursor on
RETURN (ret_val)
* EOF err_msg
*--------------------------------------------------------------------
*PROCEDURE TO BE CALLED WHENEVER ESCAPE IS PRESSED
*RELYS HEAVILY ON BEGIN SEQUENCE..END STRUCTURE
*USE WITH CAUTION!
proc esc_proc
 private xd
 xd=savescreen(10,44,12,64)
 @ 10,44 to 12,64 double
rs=setcolor("n/w")
 @ 10,44 clea to 12,64
 set cursor off
 @ 11,45 say "   CANCEL /RESUME   "
     inkey(0)
 restscreen(10,44,12,64,xd)
   set cursor on
 if chr(lastkey())$"cC"
    setcolor("")
    keyb chr(32)
    break
 Endif
 keyb chr(32)
 setcolor(rs)
 retu
*---------------------

FUNCTION BROW
param foo
Set key 27 to
public filnam
filnam=foo
SELE 10
use text
ZAP
KS=SAVESCREEN(0,0,24,78)
append from &foo sdf
go top
set colo to /w
@ 0,0 say space(79)
@ 0,0 say  PADC( "  F5-print   F10-Exit     ",80)
set  colo to
@ 1,0 to 24,78 double

SET COLO TO G/W
@ 2,12 say " S I M I L I A  H O M O E O   L A B O R A T O R Y "
setcolor("w/n,n/W")

dbedit(3,1,23,77,"","RAPPY","","","_","","","")
SET KEY 27 TO eSC_PROC
SELE 10
USE
set color to
RESTSCREEN(0,0,24,78,KS)
RETU 0
*--------------------------------------------------
  FUNC RAPPY
  PARAM SN,FO
    if sn==1
        err_msg(" No more data ")
        set cursor off
        return 1
    endif
   kes=lastkey()
    Do case
      Case kes=-9
        Retu 0
      case kes=-4
        if !isprinter()
          ERR_msg(" Printer not Ready ")
         set cursor off
          
     Else
         SET DEVICE TO PRINTER
         TYPE &filnam TO PRINT
         SET DEVICE TO SCREEN       
         RETURN 0
 endif
      ENDCase
     retu 1

