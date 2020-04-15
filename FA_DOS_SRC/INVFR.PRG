Sele 1
Use Stock\tdet
zap
Sele 2
Use Stock\E_head index stock\E_head
Sele 3
Use stock\invoice index stock\invoice
SELE 4
USE STOCK\DEALER INDEX STOCK\DEALER

 PUBLIC DEAL[4]
  AFILL(DEAL,25)



 Public in[11]
 in[1]=0
 in[2]=date()
 in[3]=space(5)
 in[4]=space(10)
 in[5]=ctod("")
 in[6]=space(10)
 in[7]=space(25)
 in[8]=space(20)
 in[9]=ctod("")
 in[10]=space(30)
 in[11]=0
@ 9,0 clea to 13,35
@ 9,0 to 13,35 double
set key 27 to Esc_proc

ino=0
begin sequence
Do while .t.
@ 11,2  Say " Invoice no " get ino
read
  if ino==0
   err_msg(" invalid invoice no ")
    loop
 endif

  rs='\invdump\i'+alltrim(str(int(ino)))+".dbf"
   if !file(rs)
     err_msg(" No such invoice Exists ")
   loop
   endif
  Sele 1
  appen from &rs
  Sele 3
   seek ino
   for i=1 to 10
     fg=field(i)
    in[i]=&fg
  next i
  in[11]=trate
exit
Enddo
  go top
Public _gooflag
SELE 4
SEEK IN[3]
IF FOUND()
  DEAL[1]=DLR_NAME
  DEAL[2]=DLR_ADD1
  DEAL[3]=DLR_ADD2
  DEAL[4]=DLR_ADD3
ENDIF
sele 3
_gooflag=if(tind=='0',"K","C")

uti()
end
set key 27 to
set key 28 to
close all
retu

function uti
set device to printer
set printer to fool.rep

  mlin=19
  sele 1
  k=1
 _head()
  go top
 do while !EOF()
    @ mlin,0 say str(k,3)
    @ mlin,3 say chr(179)
    Sele 2
    Seek left(A->code,2)
    sele 1
    @ mlin,4 say  alltrim(desc)+" "+alltrim(str(packing,4))+B->unit
    @ mlin,33 say chr(179)
    @ mlin,34 say quant pict "999999"
    @ mlin,42 say chr(179)
    @ mlin,43 say rate pict "9999.99"
    @ mlin,52 say chr(179)
    if  taxable$"Y "
         @ mlin,53 say Str(quant*rate,12,2)
    endif

    @ mlin,66 say chr(179)
    if taxable=="N"
         @ mlin,66 say str(quant*rate,12,2)
    endif

      @mlin, 79 say chr(179)
   mlin=mlin+1
     if mlin=60
         @ mlin,0 say repli(chr(205),80)
          TAIL()
          eject
          _head()
         mlin=19
       endif
    k=k+1
  skip
enddo
if mlin>50
  do while mlin<=59
  @ mlin,3 say chr(179)
    @ mlin,33 say chr(179)
    @ mlin,42 say chr(179)
    @ mlin,52 say chr(179)
    @ mlin,66 say chr(179)
    @mlin, 79 say chr(179)
  mlin=mlin+1
 Enddo
 @ mlin,0 say repli(chr(205),80)
 Eject
 _head()
 mlin=19
endif
taxrate=in[11]/100
sum amount to grsales
sum (amount -amount*disc/100)*taxrate to taxes for taxable="Y"
sum amount*disc/100 to netdis
Sal=(grsales-netdis)+taxes

  @ mlin,3 say chr(179)
    @ mlin,33 say chr(179)
    @ mlin,52 say chr(179)
    @ mlin,66 say chr(179)
    @mlin, 79 say chr(179)
mlin=mlin+1
@ mlin,3 say chr(179)+"Total          "+space(12)+"  "+chr(179)+str(grsales,17,2)
@ mlin,52 say chr(179)
@ mlin,66 say chr(179)
@mlin, 79 say chr(179)
@ mlin,3 Say chr(179)+"Less Total discount"+space(7)+"   "+chr(179)+str(netdis,17,2)
@ mlin,52 say chr(179)
@ mlin,66 say chr(179)
@mlin, 79 say chr(179)
mlin=mlin+1
*------------------Added on request from babu

@ mlin,3 Say chr(179)
@ mlin,33 say chr(179)
@ mlin,34 Say repli(chr(205),17)
@ mlin,52 say chr(179)
@ mlin,66 say chr(179)
@ mlin,79 say chr(179)
mlin=mlin+1
@ mlin,3 Say chr(179)
@ mlin,33 say chr(179)
@ mlin,34 Say str(grsales-netdis,17,2)
@ mlin,52 say chr(179)
@ mlin,66 say chr(179)

@ mlin,79 say chr(179)
mlin=mlin+1
@ mlin,3 Say chr(179)
if _gooflag="K"
@ mlin,4 Say " ADD   K G S T "
else
@ mlin,4 Say " ADD   C S T   "
endif
@ mlin,33 say chr(179)
@ mlin,34 Say str(Taxes,17,2)
@ mlin,52 say chr(179)
@ mlin,66 say chr(179)
@ mlin,79 say chr(179)
mlin=mlin+1

@ mlin,3 Say chr(179)
@ mlin,33 say chr(179)
@ mlin,34 Say repli(chr(205),18)
@ mlin,52 say chr(179)
@ mlin,66 say chr(179)
@ mlin,79 say chr(179)
mlin=mlin+1
@ mlin,3 say chr(179)

@ mlin,4 say " Total      "
@ mlin,33 say chr(179)

@ mlin,34 Say  str(grsales+taxes -(netdis),17,2)
@ mlin,52 say chr(179)
@ mlin,66 say chr(179)
@ mlin,79 say chr(179)
mlin=mlin+1
@ mlin,3 Say chr(179)
@ mlin,33 say chr(179)
@ mlin,34 Say repli(chr(205),18)
@ mlin,52 say chr(179)
@ mlin,66 say chr(179)
@ mlin,79 say chr(179)
mlin=mlin+1
  do while mlin<=59
  @ mlin,3 say chr(179)
    @ mlin,33 say chr(179)
    @ mlin,42 say chr(179)
    @ mlin,52 say chr(179)
    @ mlin,66 say chr(179)
    @mlin, 79 say chr(179)
  mlin=mlin+1
 Enddo
 @ mlin,0 say repli(chr(205),80)
 tail()
set printer to
 SET DEVICE TO SCREEN
brow("fool.rep")

 retu  0
 *-------------------------------_heading
  function _head
  @ 1,0 say space(15)+chr(14)+" SIMILIA "+" HOMOEO LABORATORY   " +SPACE(13)+"  OFF    26481  "
  @ 2,0 SAY SPACE(12)+" P. B. NO 614, ALWAYE-683102,"+"KERALA "+SPACE(15)+" PH:"
  @ 3,0 SAY SPACE(60)+" RES 24651 "
  @ 4,0 SAY SPACE(55)+" c.s.t no"+" 24176134 "
  @ 5,0 SAY SPACE(55)+" k.g.s.t "+" 24171134 "
  @ 6,0 SAY SPACE(55)+" drug lic .no 3/25c/86 "
  @ 7,0 say repli(CHR(196),80)
  @ 8,0 say "m/s   "+ALLTRIM(DEAL[1])
  @ 8,51 say "INVOICE NO :"+alltrim(str(in[1]))
  @ 9,0 SAY SUBSTR(ALLTRIM(DEAL[2])+" "+ALLTRIM(DEAL[3]),1,49)

  @ 9,0 SAY ALLTRIM(DEAL[4])
  @ 9,50 SAY " DATE       : " +DTOC(in[2])
  @ 10,0 say repli(CHR(196),80)
  @ 11,0 SAY " YOUR ORDER NO " +  in[4]
  @ 11,35 SAY "DATED"+dtoc(in[5])
  @ 11,50 SAY " DESPATCHED BY " +in[6]
  @ 12,0 SAY  " TO" +in[7]
  @ 12,35 SAY "UNDER R. R / L. R NO" +in[8]
  @ 13,0 SAY " DATE "+dtoc(in[9])
  @ 13,25 SAY "DOCUMENTS THROUGH   "+in[10]
  @ 14,0 say repli(CHR(95),80)
  @ 15,53 say "          AMOUNT         "
  @ 16,53 SAY REPLI(CHR(205),26)
  @ 17,0 SAY "NO "+CHR(179)+"      DESCREPTION            "+CHR(179)+"   QTY  "+chr(179)+"   rate  "+chr(179)+"  taxable    "+chr(179)+"  n.taxable "+chr(179)
  @ 18,0 SAY REPLI(CHR(205),80)
  retu 0

function tail
@ 62,0 say " Subject to kerala jurisdiction " + space(15)+" for SIMILIA HOMOEO LABORATORY "
@ 64,0 SAY "PREPARED by "
RETU 0

