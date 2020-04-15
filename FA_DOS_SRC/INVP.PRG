* Program to Print invoices
* give the invoice number
*
*

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
AFILL(DEAL,space(25))



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
mon=0
begin sequence
Do while .t.
sele 1
zap
@ 11,2  Say " Invoice no " get ino  pict "9999999"
read
  if ino==0
   err_msg(" invalid invoice no ")
    loop
 endif
 sele 3
 seek ino
   if !found()
     err_msg("No such invoice exists ")
     loop
   endif
 rsd=month(doi)
 rsd=if(rsd>3,rsd-3,rsd+9)
 fil="stock\inv"+iif(rsd<=9,'0'+str(rsd,1),str(rsd,2))
 sele 7
   Use &fil index &fil
    seek ino

     Do while invno==ino
        sele 1
         append blank
          replace code with g->code
          replace desc with g->desc
          replace packing with g->packing
          replace rate with g->rate
          replace quant with g->quant
          replace amount with g->amount
          replace taxable with g->taxable
          replace disc with g->disc
          sele 7
          skip
     enddo

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
seek ino
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
 _head()
  mlin=19
  sele 1
  k=1
  go top
Tax_tot=0
ntax_tot=0
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
    if  taxable=="Y"
         @ mlin,53 say Str(quant*rate,12,2)
         tax_tot=tax_tot+quant*rate
    endif

    @ mlin,66 say chr(179)
    if taxable=="N"
         @ mlin,67 say str(quant*rate,12,2)
          nTax_tot=ntax_tot+quant*rate

    endif

      @mlin, 79 say chr(179)
     mlin=mlin+1
    if mlin>=54
         @ mlin,3 say chr(179)
         @ mlin,33 say chr(179)
         @ mlin,42 say chr(179)
         @ mlin,52 say chr(179)
         @ mlin,53 say repli(chr(196),13)  
         @ mlin,66 say chr(179)
         @ mlin,67 say repli(chr(196),12)
         @ mlin,79 say chr(179)
         mlin=mlin+1
         @ mlin,3  say chr(179)
         @ mlin,4 Say "       C/F   "
         @ mlin,33 say chr(179)
         @ mlin,42 say chr(179)
         @ mlin,52 say chr(179)
         @ mlin,53 say str(Tax_tot,13,2)  
         @ mlin,66 say chr(179)
         @ mlin,67 say str(ntax_tot,12,2)
         @ mlin,79 say chr(179)
           mlin=mlin+1
         @ mlin,0 say repli(chr(205),80)
          TAIL()
          eject
          _head()
           mlin=19
         @ mlin,3 say chr(179)
         @ mlin,4 Say "       B/F   "
         @ mlin,33 say chr(179)
         @ mlin,42 say chr(179)
         @ mlin,52 say chr(179)
         @ mlin,53 say str(tax_tot,13,2)  
         @ mlin,66 say chr(179)
         @ mlin,67 say str(ntax_tot,12,2)
         @ mlin,79 say chr(179)
          mlin=mlin+1
       endif
    k=k+1
  skip
enddo
if mlin>46
 do while mlin<=54
    @ mlin,3 say chr(179)
    @ mlin,33 say chr(179)
    @ mlin,42 say chr(179)
    @ mlin,52 say chr(179)
    @ mlin,66 say chr(179)
    @mlin, 79 say chr(179)
  mlin=mlin+1
 Enddo
         @ mlin,3 say chr(179)
         @ mlin,33 say chr(179)
         @ mlin,42 say chr(179)
         @ mlin,52 say chr(179)
         @ mlin,53 say repli(chr(196),13)  
         @ mlin,66 say chr(179)
         @ mlin,67 say repli(chr(196),12)
         @ mlin,79 say chr(179)
         mlin=mlin+1
         @ mlin,3  say chr(179)
         @ mlin,4 Say "       C/F   "
         @ mlin,33 say chr(179)
         @ mlin,42 say chr(179)
         @ mlin,52 say chr(179)
         @ mlin,53 say str(Tax_tot,13,2)  
         @ mlin,66 say chr(179)
         @ mlin,67 say str(ntax_tot,12,2)
         @ mlin,79 say chr(179)
           mlin=mlin+1
         @ mlin,0 say repli(chr(205),80)
          TAIL()
          eject
          _head()
           mlin=19
         @ mlin,3 say chr(179)
         @ mlin,4 Say "       B/F   "
         @ mlin,33 say chr(179)
         @ mlin,42 say chr(179)
         @ mlin,52 say chr(179)
         @ mlin,53 say str(tax_tot,13,2)  
         @ mlin,66 say chr(179)
         @ mlin,67 say str(ntax_tot,12,2)
         @ mlin,79 say chr(179)
mlin=mlin+1
endif
taxrate=in[11]/100
sum amount to grsales
sum (amount -amount*disc/100)*taxrate to taxes for taxable="Y"
sum amount*disc/100 to netdis
sum amount*disc/100 to nt_disc for taxable="N"

sum amount for taxable="Y" to t_axable
nt_axable=grsales-t_axable
Sal=(grsales-netdis)+taxes

    @ mlin,3 say chr(179)
    @ mlin,33 say chr(179)
    @ mlin,42 say chr(179)
    @ mlin,52 say chr(179)
    @ mlin,53 say repli(chr(196),13)
    @ mlin,66 say chr(179)
    @ mlin,67 say repli(chr(196),12)
    @mlin, 79 say chr(179)
  mlin=mlin+1
@ mlin,3 say chr(179)+"Total          "
@ mlin,33 say chr(179)
@ mlin,42 say chr(179)
@ mlin,52 say chr(179)
@ mlin,53 say str(T_axable,12,2)
@ mlin,66 say chr(179)
@ mlin,67 say iif(nt_axable>0,str(nt_axable,12,2),space(5))
@mlin, 79 say chr(179)
IF netdis>0
mlin=mlin+1
@ mlin,3 Say chr(179)+"Less Total Discount"
@ mlin,33 say chr(179)
@ mlin,42 say chr(179)
@ mlin,52 say chr(179)
@ mlin,66 say chr(179)
@mlin, 79 say chr(179)
mlin=mlin+1
*------------------Added on request from babu
locate for disc>0
do while !eof()
     sam=recno()
      sre=disc
      if disc==0
         skip
        loop
      endif   
Do while disc==sre .and. !eof()
     skip
Enddo
 @ mlin,3 Say chr(179)
 if recno()-1<>sam
@ mlin,4 say "ITem "+str(sam,3)+" To"+ str(recno()-1,3)+" "+ str(sre,5,2)+"%"
else
@ mlin,4 say "ITem "+str(sam,3) +"        "+  str(sre,5,2)+"%"
endif
@ mlin,33 say chr(179)
@ mlin,42 say chr(179)
@ mlin,52 say chr(179)
@ mlin,66 say chr(179)
@ mlin,79 say chr(179)
mlin=mlin+1
enddo
@ mlin,3 Say chr(179)
@ mlin,33 say chr(179)
@ mlin,42 Say chr(179)
@ mlin,52 say chr(179)
@ mlin,53 say str(netdis-nt_disc,13,2)
@ mlin,66 say chr(179)
@ mlin,67 say str(nt_disc,12,2)
@ mlin,79 say chr(179)
 mlin=mlin+1
@ mlin,3 Say chr(179)
@ mlin,33 say chr(179)
@ mlin,42 Say chr(179)
@ mlin,52 say chr(179)
@ mlin,53 say  repli(chr(196),13)
@ mlin,66 say chr(179)
@ mlin,67 say repli (chr(196),12)
@ mlin,79 say chr(179)

mlin=mlin+1
@ mlin,3 Say chr(179)
@ mlin,33 say chr(179)
@ mlin,42 Say chr(179)
@ mlin,52 say chr(179)
@ mlin,53 say str(T_axable-(netdis-nt_disc),13,2)
@ mlin,66 say chr(179)
@ mlin,67 say str(nt_axable-(nt_disc),12,2)
@ mlin,79 say chr(179)
endif
mlin=mlin+1

@ mlin,3 Say chr(179)
@ mlin,33 say chr(179)
@ mlin,42 Say chr(179)
@ mlin,52 say chr(179)
@ mlin,53 say repli(chr(196),26)
@ mlin,79 say chr(179)
mlin=mlin+1
@ mlin,3 Say chr(179)
@ mlin,33 say chr(179)
@ mlin,42 Say chr(179)
@ mlin,52 say chr(179)
@ mlin,56 say str(grsales-netdis,17,2)
@ mlin,79 say chr(179)

if taxes>0
mlin=mlin+1
@ mlin,3 Say chr(179)
if _gooflag="K"
@ mlin,4 Say " ADD   K G S T " +str(taxrate*100,5,2)+"%"
else
@ mlin,4 Say " ADD   C S T   " +str(taxrate*100,5,2)+"%"
endif
@ mlin,33 say chr(179)
@ mlin,42 say chr(179)
@ mlin,52 say chr(179)
@ mlin,56 say str(Taxes,17,2)
@ mlin,79 say chr(179)
mlin=mlin+1
endif
@ mlin,3 Say chr(179)
@ mlin,33 say chr(179)
@ mlin,42 Say chr(179)
@ mlin,52 say chr(179)
@ mlin,53 say repli(chr(196),26)
@ mlin,79 say chr(179)
 mlin=mlin+1
@ mlin,3 say chr(179)

@ mlin,4 say "Grand Total....."+space(8)+"Rs."
@ mlin,33 say chr(179)
@ mlin,42 say chr(179)
@ mlin,52 say chr(179)
@ mlin,56 Say  str(grsales+taxes -(netdis),17,2)
@ mlin,79 say chr(179)
mlin=mlin+1
@ mlin,3 Say chr(179)
@ mlin,33 say chr(179)
@ mlin,42 Say chr(179)
@ mlin,52 say chr(179)
@ mlin,53 say repli(chr(205),26)
@ mlin,79 say chr(179)
mlin=mlin+1
  do while mlin<=56
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
  @ 1,0 say space(15)+chr(14)+" SIMILIA "+" HOMOEO LABORATORY   " +SPACE(13)
  @ 2,0 SAY CENTER(ALLTRIM(SPACE(12)+" P. B. NO 614, ALUVA-683102,"+"KERALA "+SPACE(15)))
  @ 3,0 SAY " K.G.S.T No"+" 24171134 "
  @ 3,66 SAY " PHONE : "
  @ 4,0 SAY " C.S.T   No"+" 24176134 "
  @ 4,66 SAY " OFF. "+" 26481 "
  @ 5,0 SAY " Drug Lic No  3/25c/86 "
  @ 5,66 SAY " RES. "+" 24651 "
  @ 6,0 say repli(CHR(196),80)
  @ 7,0 say "m/s   "+ALLTRIM(DEAL[1])
  @ 7,56 say "INVOICE NO :"+alltrim(str(in[1]))
  @ 8,0 SAY ALLTRIM(DEAL[2])+" "+ALLTRIM(DEAL[3])
  @ 9,0 SAY "Pin "+ ALLTRIM(DEAL[4])
  @ 9,56 SAY " DATE       : " +DTOC(in[2])
  @ 10,0 say repli(CHR(196),80)
  @ 11,0 SAY " YOUR ORDER NO " +  in[4]
  @ 11,35 SAY "DATED"+dtoc(in[5])
  @ 11,50 SAY " DESPATCHED BY " +in[6]
  @ 12,0 SAY  " TO" +in[7]
  @ 12,35 SAY "UNDER R. R / L. R NO" +in[8]
  @ 13,0 SAY " DATE "+dtoc(in[9])
  @ 13,17 SAY " DOCUMENTS THRO'  "+left(in[10],39)
  @ 14,0 say repli(CHR(95),80)
  @ 15,53 say "          AMOUNT         "
  @ 16,53 SAY REPLI(CHR(205),26)
  @ 17,0 SAY "NO "+CHR(179)+"      DESCREPTION            "+CHR(179)+"   QTY  "+chr(179)+"   rate  "+chr(179)+"  taxable    "+chr(179)+"  n.taxable "+chr(179)
  @ 18,0 SAY REPLI(CHR(205),80)
  retu 0

function tail
@ 58,0 say " Subject to Aluva jurisdiction " + space(16)+" for SIMILIA HOMOEO LABORATORY "
@ 60,0 SAY "PREPARED by "
@ 61,0 say "                                                 "
RETU 0

