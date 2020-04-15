Param _what
Set deleted on
Sele 1
 Do case
   Case _what=="1"
     Use stock\R_head index stock\r_head
   Case _what=="2"
     Use stock\C_head index stock\C_head
   case _what=="3"
     Use stock\E_head index stock\E_head
 Endcase
 GO TOP

   SET DEVICE TO PRINTER
   SET PRINTER TO FOOL.txt
 Tnn_head()
MLIN=8
   K=1
   DO WHILE !EOF()
   @ MLIN,1 SAY STR(K,5)+chr(186)+"   "+code+"  "+chr(186)+"  "+Desc+"   "+chr(186)+"  "+unit+"  "+chr(186)
K=K+1
    SKIP
    if mlin>60
      mlin=8
      Eject
      tnn_head()
    endif
   MLIN=MLIN+1
ENDDO
eJECT
SET DEVICE TO SCREEN
SET PRINTER TO
BROW("FOOL.txt")
RETU








FUNCTION Tnn_HEAD
 @ 1,5 say "       S I M I L I A  H O M O E O  L A B O R A T O R Y   "
 @ 2,15 say "     List of Group heads      "+if(_what=="1","RAW  MATERIALS",IF(_WHAT==;
 "2","CONTAINERS ","END PRODUCTS  "))
 @ 3,0 say "  DATE :- " +DTOC(DATE())
 @ 4,0 SAY "  TIME :- "+TIME()
 @ 5,0 SAY REPLI(chr(205),55)
 @ 6,0 say  " S.no    Code       DESCREPTION                 Unit   "
 @ 7,0 SAY REPLI (chr(205),55)
 RETU 0


