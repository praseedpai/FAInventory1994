Param _what
Public headers,R_co
Set deleted on
 Do case
   Case _what=="1"
     Sele 1
     Use stock\R_head index stock\r_head
     Sele 2
     Use stock\rsub index  stock\rsub
     headers= " S.no    Code       DESCREPTION                     Rate   "
    R_co=62
Case _what=="2"

   Sele 1
     Use stock\C_head index stock\C_head
   Sele 2

     Use stock\csub index stock\csub
     headers= " S.no    Code      DESCREPTION                     Rate   "
   R_co=62
case _what=="3"
   sele 1
     Use stock\E_head index stock\E_head
   Sele 2
     Use stock\E_subhea index stock\E_subhea
    headers=" S .No    Code       Descreption                      Pack"+;
    "       Rate        pack      Rate      pack      Rate      Unit  "
  R_co =132
endcase
 GO TOP
   SET DEVICE TO PRINTER
   SET PRINTER TO FOOL
 _Tnn_head()
MLIN=8
   K=1
   DO WHILE !EOF()
    If _what$"12"
      @ MLIN,1 SAY STR(K,5)+chr(124)+"   "+code+"  "+chr(124)+"  "+Desc+"   "+chr(124)+"  "+Str(rate)+"  "+chr(124)
    else
    Sele 1
    Seek left(B->S_code,2)
    sele 2
      @ mlin,1 say chr(15) +str(k,5)+chr(124)+"  "+S_code+" "+chr(124)+"  "+S_desc+;
      chr(124)+"  "+str(S_pack1)+"  "+ chr(124)+str(S_rate1)+"  ";
     +chr(124)+str(S_pack2)+"  "+ chr(124)+str(S_rate2)+;
     chr(124)+str(S_pack3)+"  "+ chr(124)+str(S_rate3)+"  "+chr(124)+"  "+a->unit+" "+chr(124)
    Endif

K=K+1
    SKIP
    if mlin>60
      mlin=8
      Eject
      _tnn_head()
    endif
   MLIN=MLIN+1
ENDDO
Eject
SET DEVICE TO SCREEN
SET PRINTER TO
BROW("FOOL.PRN")
RETU








FUNCTION _Tnn_HEAD
 @ 1,5 say chr(15)+"       S I M I L I A  H O M O E O  L A B O R A T O R Y   "
 @ 2,15 say chr(15)+"     List of Subgroups   "+if(_what=="1","RAW  MATERIALS",IF(_WHAT==;
 "2","CONTAINERS ","END PRODUCTS  "))
 @ 3,0 say chr(14)+"  DATE :- " +DTOC(DATE())
 @ 4,0 SAY chr(15)+ "  TIME :- "+TIME()

 @ 5,0 SAY chr(15)+REPLI(chr(45),r_co)
 @ 6,0 say chr(15)+headers
 @ 7,0 SAY chr(15)+REPLI (chr(45),r_co)
 RETU 0


