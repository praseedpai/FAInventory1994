* program to print stock Regs
*
*----------------------------------------
Sele 1
use stock\E_head index stock\E_head
sele 2
Use stock\E_subhea index stock\E_subhea
SEle 3
Use stock\stock index stock\Stock

set device to printer
Set printer to foo.rep
tsn_head()
mlin=8
sele 3
do while !eof()
  SELE 2
   SEEK C->IT_CODE
  SELE 1
   SEEK LEFT(C->IT_CODE,2)
  SELE 3 
 @ mlin,0 say it_code +"  "+"|"+" "+ B->s_desc+"  "+"|"+" "+str(it_qty)+" "+A->unit+"|"
  mlin=mlin+1
 if mlin=61
   @ MLIN,0 SAY REPLI("-",65)
   eJECT
   tSn_HEAD()
   mlin=8
 endif
 skip
enddo
Eject
set device to SCreen
set printer to
brow("foo.rep")
close all
retu




FUNCTION TSn_HEAD
 @ 1,5 say "       S I M I L I A   H O M O E O   L A B O R A T O R Y   "
 @ 2,20 say "        STOCK REGS                          "
 @ 3,0 say "  DATE :- " +DTOC(DATE())
 @ 4,0 SAY "  TIME :- "+TIME()
 @ 5,0 SAY REPLI("-",65)
 @ 6,0 say  "   Code              DESCREPTION                    QTY   "
 @ 7,0 SAY REPLI ("-",65)
 RETU 0



