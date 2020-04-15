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
set deleted on
Public Awe
Public Pno
pno=1
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

     Do while invno=ino
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
  awe=adi
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
set century on
??CHR(27)+"C"+CHR(72)
 _head()
PUBLIC MLIN
  mlin=19
  sele 1
  k=1
  go top
  Tax_tot=0
  ntax_tot=0
  Grsales=0
  T_disc=0
  Nt_disc=0
  Taxrate=in[11]/100
  E1=0
  E2=0

 do while !EOF()
    @ mlin,1 say str(k,3)
   Sele 2
     Seek left(A->code,2)
   Sele 1
       RETY=LEFT(CODE,2)
  *IF (RETY=="MT" .OR. RETY=="D1" .OR. RETY=="D2" .OR. RETY=="D3") .AND. PACKING==450  
  *      @ mlin,5 say  LEFT(alltrim(desc)+" "+"30MLx15",30)
  *  ELSE
         @ mlin,5 say LEFT(alltrim(desc)+" "+alltrim(str(packing,4))+B->unit,30)
  *  ENDIF    
    @ mlin,35 say quant pict "999999"
    @ mlin,44 say IF(rate>0,rate,"   ")  pict "9999.99"
    if  taxable=="Y"
        @ mlin,54 say IIf(Quant*rate>0,Str(quant*rate,12,2),"      ")
        tax_tot=tax_tot+quant*rate && Taxable total
        T_disc=T_disc+(Quant*rate)*disc/100 
        E1=E1+ ((Quant*Rate)-(quant*Rate)*disc/100)*awe/100
      endif

    if taxable=="N"
         @ mlin,68 say IIF(quant*rate>0,str(quant*rate,12,2),"      ")
          nTax_tot=ntax_tot+quant*rate
          nt_disc=nt_disc+(Quant*rate)*disc/100 
          E2=E2+ ((Quant*Rate)-(quant*Rate)*disc/100)*awe/100
      endif
      Grsales=Grsales+Quant*Rate

     mlin=mlin+1
    if mlin>=60
         mlin=mlin+1
         @ mlin,5 Say "       C/F   "
         @ mlin,54 say IF(Tax_tot>0,str(Tax_tot,12,2),"   ")
         @ mlin,68 say IIF(ntax_tot>0,str(ntax_tot,12,2),"  ")
           mlin=mlin+1
          TAIL()
          EJECT
           pno=pno+1
          _head()
           mlin=19
         @ mlin,5 Say "       B/F   "
         @ mlin,54 say IIf(tax_tot>0,str(tax_tot,12,2),"   ")
         @ mlin,68 say IIf(ntax_tot>0,str(ntax_tot,12,2),"  ")
          mlin=mlin+1
       endif
    k=k+1
  skip
enddo
if mlin>43
 do while mlin<=59
  mlin=mlin+1
 Enddo
         @ mlin,54 say repli(chr(196),13)
         @ mlin,68 say repli(chr(196),12)
         mlin=mlin+1
         @ mlin,3  say chr(179)
         @ mlin,4 Say "       C/F   "
         @ mlin,54 say IIf(tax_tot>0,str(tax_tot,12,2),"  ")
         @ mlin,68 say IIf(ntax_tot>0,str(ntax_tot,12,2),"  ")
           mlin=mlin+1
          TAIL()
          EJECT
           pno=pno+1
          _head()
           mlin=19
         @ mlin,4 Say "       B/F   "
         @ mlin,54 say IIf(tax_tot>0,str(tax_tot,12,2),"  ")
         @ mlin,68 say IIf(ntax_tot>0,str(ntax_tot,12,2),"  ")
         mlin=mlin+1
endif


    @ mlin,54 say repli(chr(196),13)
    @ mlin,68 say repli(chr(196),12)
  mlin=mlin+1
@ mlin,5 say "Total          "
@ mlin,54 say IF(Tax_tot>0,str(Tax_tot,12,2),"  ")

@ mlin,68 say iif(ntax_tot>0,str(Ntax_tot,12,2),space(5))

Netdis=T_DISC+NT_DISC
IF netdis>0
mlin=mlin+1
@ mlin,5 Say "Less Total Discount"
mlin=mlin+1
*------------------Added on request from babu
Go top
flc=0

do while !eof()
  if disc==0
      skip
      loop
   Endif
   
 Sre=disc
 Sam=Recno()
Do while disc==sre .and. !eof()
     skip
Enddo
   
   if mlin>=61
       @ mlin,54 say repli(chr(196),13)
       @ mlin,68 say repli(chr(196),12)
       mlin=mlin+1
       @ mlin,5 Say "       C/F   "
       @ mlin,54 say If(Tax_tot>0,str(Tax_tot,12,2),"     ")
       @ mlin,68 say if(ntax_tot>0,str(ntax_tot,12,2),"   ")
       mlin=mlin+1
        TAIL()
        EJECT
        pno=pno+1
       _head()
        mlin=19
         @ mlin,6 Say "       B/F   "
         @ mlin,54 say IIf(tax_tot>0,str(tax_tot,12,2),"  ")
         @ mlin,68 say IIf(ntax_tot>0,str(ntax_tot,12,2),"  ")
          mlin=mlin+1
       endif          

if Recno()-1<>sam
   @ mlin,5 say "ITem "+str(sam,3)+" To"+ str(recno()-1,3)+" "+ str(sre,5,2)+"%"
else
    @ mlin,5 say "ITem "+str(sam,3) +"        "+  str(sre,5,2)+"%"
endif
mlin=mlin+1
enddo
@ mlin,54 say If(t_disc>0,str(t_disc,12,2),"   ")
@ mlin,68 say If(nt_disc>0,str(nt_disc,12,2),"  ")
endif


If (E1+E2>0)
mlin=mlin+1
@ mlin,5 say "Less ADDl. Disc "+str(awe,5,2)+"%"
@ mlin,54 say If(E1>0,str(E1,12,2),"  ")
@ mlin,68 say If(E2>0,str(E2,12,2),"  ")
Endif


mlin=mlin+1
@ mlin,54 say repli(chr(196),26)
mlin=mlin+1


@ mlin,54 say If(TAX_tot-T_disc-E1>0,str(Tax_tot-T_DISC-E1,12,2),"    ")
@ mlin,68 say if(ntax_tot-nT_disc-E2>0,str(ntax_tot-nt_disc-E2,12,2),"    ")

mlin=mlin+1

@ mlin,54 say repli(chr(196),26)
mlin=mlin+1

@ mlin,61 say str(grsales-netdis-E1-E2,17,2)

   Actamount=Grsales-Netdis-E1-E2
   Taxes=(Tax_tot-T_disc-E1)*taxrate
   


if taxes>0
  mlin=mlin+1
if _gooflag="K"
@ mlin,5 Say " ADD   K G S T " +str(taxrate*100,5,2)+"%"
else
@ mlin,5 Say " ADD   C S T   " +str(taxrate*100,5,2)+"%"
endif
@ mlin,61 say str(Taxes,17,2)
mlin=mlin+1
endif
@ mlin,54 say repli(chr(196),26)
 mlin=mlin+1

@ mlin,5 say "Grand Total....."+space(8)+"Rs."
@ mlin,61 Say  str(ACTamount+Taxes,17,2)
mlin=mlin+1
@ mlin,54 say repli(chr(205),26)
mlin=mlin+1
do while mlin<=61
 mlin=mlin+1
Enddo
 tail()
 EJECT
set printer to
 SET DEVICE TO SCREEN
brow("fool.rep")
 set century on 
 retu  0
 *-------------------------------_heading
  function _head
  @ 1,76 say STR(PNO,2)
  @ 7,7 say alltrim(deal[1])
  @ 7,69 say alltrim(str(in[1]))
  @ 8,2 SAY ALLTRIM(DEAL[2])+" "+ALLTRIM(DEAL[3])
  @ 9,2 SAY "PIN "+ alltrim(deal[4])
  @ 9,69 SAY DTOC(in[2])
  @ 11,17 SAY   in[4]
  @ 11,41 SAY dtoc(in[5])
  @ 11,68 SAY in[6]
  @ 12,5 SAY  in[7]
  @ 12,55 SAY in[8]
  @ 13,6 SAY str(day(in[9]),2)+" "+str(month(in[9]),2)+"  "+str(year(in[9]),4)
  @ 13,36 SAY left(in[10],46)
  retu 0

function tail
RETU 0
