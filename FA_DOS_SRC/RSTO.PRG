* program to print stock Regs
*
*----------------------------------------
Param _water
set century on 
Do Case
  Case _water="1"
     Sele 1
        use stock\R_head index stock\R_head
     sele 2
        Use stock\Rsub index stock\Rsub
     SEle 3
        Use stock\Rstock index stock\Rstock
Case _water="2"
   Sele 1
     use stock\C_head index stock\C_head
   sele 2
     Use stock\Csub index stock\Csub
     SEle 3
Use stock\Cstock index stock\Cstock
ENDCASe

Set Relation to Rcode into B
go top

set device to printer
Set printer to foo.rep
ts2_head()
mlin=8
do while !eof()
Sele 1
Seek Left(c->Rcode,2)
sele 3
 @ mlin,0 say Rcode +"  "+"|"+" "+ B->desc+"  "+"|"+" "+str(Rqty)+" "+A->unit+"|"
 mlin=mlin+1
 if mlin=61
   @ MLIN,0 SAY REPLI("-",55)
   eJECT
   tS2_HEAD()
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




FUNCTION TS2_HEAD
 @ 1,5 say "       S I M I L I A  H O M O E O  L A B O R A T O R Y   "
 @ 2,20 say "        Stock Regs                          "
 @ 3,0 say "  DATE :- " +DTOC(DATE())
 @ 4,0 SAY "  TIME :- "+TIME()
 @ 5,0 SAY REPLI("-",55)
 @ 6,0 say  " Code            DESCREPTION             QTY   "
 @ 7,0 SAY REPLI ("-",55)
 RETU 0



