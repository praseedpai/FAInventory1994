* PROGRAM TO PRINT REPORTS OF GROUP HEADS
* NOT A GENERIC ONE
* DATE WRITTEN 2'ND FEB '1995
* AUTHOR PRASEED PAI
Param _why
  
   do case
      case  _why==2
        shead_r()
      case _why==1
        head_r()
    endc
cLOSE ALL
 retu




function head_r
SELE 1
USE DATA\GROUP INDEX DATA\GROUP
 GO TOP
   SET DEVICE TO PRINTER
   SET PRINTER TO FOOL
   TS_HEAD(1)
   MLIN=8
K=1
@ MLIN,1 SAY "S .NO    CODE       DESCREPTION       "
@ MLIN+1,1 SAY  REPLI(CHR(205),44)
MLIN=MLIN+2
DO WHILE !EOF()
  @ MLIN,1 SAY STR(K,2)
  @ MLIN,6 SAY "³"
  @ MLIN,7 SAY  "  "+A_CODE
   @ MLIN,13 SAY "³"
   @ MLIN,14 SAY SUBS(A_DESC,1,25)

@ MLIN,43 SAY "³"
K=K+1
    SKIP
   MLIN=MLIN+1
ENDDO
Eject
SET DEVICE TO SCREEN
SET PRINTER TO
BROW("FOOL.PRN")
RETU    0



FUNCTION TS_HEAD
PARAM F1
 @ 1,5 say "       S I M I L I A   H O M O E O   L A B O R A T O R Y    "
 @ 2,20 say IIF(F1==1,"        GROUP HEADS REPORT        ","      SUB GROUP  REPORT        " )
 @ 3,0 say "  DATE :- " +DTOC(DATE())
 @ 4,0 SAY "  TIME :- "+TIME()
 @ 5,0 SAY REPLI(chr(205),45)
 @ 7,0 SAY REPLI (chr(205),45)
 RETU 0


function shead_r
SELE 1
USE DATA\sGROUP INDEX DATA\sGROUP
GO TOP
  SET DEVICE TO PRINTER
  SET PRINTER TO FOOL
  TS_HEAD(2)
MLIN=8
 K=1
@ MLIN,1 SAY "S .NO   CODE         DESCREPTION       "
@ MLIN+1,1 SAY  REPLI(CHR(205),44)
MLIN=MLIN+2
DO WHILE !EOF()
  @ MLIN,1 SAY STR(K,3)
  @ MLIN,6 SAY "³"
  @ MLIN,7 SAY  "  "+s_CODE
   @ MLIN,15 SAY "³"
   @ MLIN,16 SAY SUBS(s_DESC,1,25)

@ MLIN,43 SAY "³"
K=K+1
    SKIP
   MLIN=MLIN+1
ENDDO
Eject
SET DEVICE TO SCREEN
SET PRINTER TO
BROW("FOOL.PRN")
RETU    0



