* Program to Print Schedule Of Balnce sheet Items
* Better to Recalculate Balances Brfore Doing this
 Param _why
 Sele 1
  Use Data\group index data\group
 Sele 2
  Use Data\sgroup index  data\sgroup
 Sele 3
  Use data\bal_ledg index data\bal_ledg

  Sele 1
IF _why=="1"
    Set Filter to a_code<'25'
Else
    Set filter to a_code>='25' .and. a_code<'50'
Endif
 ac_ount=space(2)

scroll(10,10,15,30)

@ 10,10 to 15,30 double
@ 11,11 clea to 14,29
sET INTEN OFF
bEGIN sEQUENCE
Do while .t.

set key 28 to code_h
 keyb chr(28)
@ 13,11 sAY " GROUP CODE "  Get ac_ount
Read
 sELE 1
 
   SEek ac_ount
    If !found()
      err_msg("invalid code ")
      loop
    endif

Sele 3
 locate for left(is_code,2)==ac_ount
Set device to printer
Set Printer to fool.txt
mlin=8
ns=month(date())
 ns=if(ns>=4 .and. ns<=12,ns-3,ns+9)
 fie='month'+if(ns<=9,'0'+str(ns,1),str(ns,2))
 HEADER_S()
rtot=0
  Do while left(is_code,2)==ac_ount
   Sele 2
    Seek C->is_code
   Sele 3
   rma=&fie
   rtot=rma+rtot   
@ mlin,1 Say  B->S_desc+"  "+CHR(186)+"  "+str(abs(rma))+if(rma>0," DR" ," CR")
   
   skip
   mlin=mlin+1
 Enddo
@ mlin,10 say "total "+str(abs(rtot),15,2)
Eject
Set device to Screen
Set printer to
Brow("fool.txt")

Sele 2
Enddo
eND
SET KEY 27 TO
SET KEY 28 TO
CLOSE ALL
sET INTEN ON
rETU

Function Header_s
@ 2,15 Say "  S I M I L I A  H O M O E O  L A B O R A T O R Y  "
@ 3,25 sAY "   SCHEDULE OF  "+  a->A_DESC
@ 4,0 SAY REPLI(CHR(205),80)
@ 5,0 SAY "        DESCREPTION                         AMOUNT       "
@ 6,0 SAY REPLI(CHR(205),80)
RETURN 0
