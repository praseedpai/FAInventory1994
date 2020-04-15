* Program to Delete an invoice
* hypersensitive
*
*
*/////////////////////////////////////////
Set century on 
Set deleted on
*-------------------------------invoice summary
sele 1
use stock\invoice  index stock\invoice,stock\invoice1
*--------------------------------invoice detail
sele 2
use stock\stock inde stock\stock
*---------------------------------- sub_heads for valid code
sele 3
use stock\e_subhea index stock\e_subhea,stock\e_sub1,stock\e_sub2,stock\e_sub3
*-----------------------------------------------------FILE FOR DBEDIT
sele 4
use stock\tdet
Zap
*------------------------------------------dealer file
SELE 5
 use stock\dealer index stock\dealer
*-------------------------------------------------------

 scroll(0,0,24,79,0)
 @ 2,1 to 7,75 double
*---------------------------------- PROMPTING
  @ 3,3 say  " Invoice no"
  @ 3,30 SAY " Date      "
  @ 3,54 SAY " customer  "
  @ 4,3 say  " order no  "
  @ 4,30 say " orddate   "
  @ 4,50 say " despatched"
  @ 5,3  say " to        "
  @ 5,40 say " r.r. lr.no"
  @ 6,3 say  " dATE      "
  @ 6,30 SAY " Through   "
 *------------------------  END PROMPT
 Public in[12]
 in[1]=0
 in[2]=date()
 in[3]=space(4)
 in[4]=space(10)
 in[5]=ctod("")
 in[6]=space(10)
 in[7]=space(25)
 in[8]=space(20)
 in[9]=ctod("")
 in[10]=space(46)

 set colo to /w
@ 24,0 say space(79)
@ 24,0 say center(  "  F1-Codelist   F7-change DIscount rate   ESC-cancel while not editing ")
 *----------------------------
 set colo to
*---------------------------array of picture to dbedit
private pic[8]
pic[1]="@!"
pic[2]="@s20!"
pic[3]="99999"
pic[4]="99999"
pic[5]="999.99"
pic[6]="999999999999999.99"
pic[7]="Y"
pic[8]="99.99"
*---------------------------------
private _head[8]
_head[1]=" code "
_head[2]=" Descr. "
_head[3]=" packing "
_head[4]=" RATE   "
_head[5]=" QTY    "
_head[6]=" Amount "
_head[7]=" Taxable "
_head[8]=" DISC    "
SET KEY 27 TO EsC_PROC
 set colo to w+/n+,n/w,,,w+/n+
public Ful
BEGIN SEQUENCE
Do while .t.
   Sele 4
   zap
   @ 3,17 get in[1] pict "9999999999"
   read
     if (in[1]<=0)
       err_msg(" INVALID INVOICE NUMBER ")
      LOOP
     ENDIF
  sele 1
     SEEK IN[1]
      IF !FOUND()
        ERR_MSG(" No SUch invoice Exists  ")
        LOOP
      ENDIF
  FOr i =1 to 11
     sdmj=field(i)
     in[i]=&sdmj
  Next i
in[12]=trate
mdoi=doi
sele 4
   rdef=month(mdoi)
   rdef=if(rdef<=3,rdef+9,rdef-3)
    vfile='stock\'+"inv"+if(rdef<=9,'0'+str(rdef,1),str(rdef,2))
       if !file(vfile+".dbf")
           err_msg(" Power may have gone while updating this invoice")
           loop
       endif
  sele 6
    use &vfile index &vfile
       seek in[1]
     do while invno=in[1]
         sele 4
           append blank
         replace code with f->code,desc with f->desc,;
         packing with f->packing,rate with f->rate,;
         quant with f->quant ,amount with f->amount;
         taxable with f->taxable,disc with f->disc
      sele 6
         skip
 enddo
   @ 3,41 say in[2]
   @ 3,65 say in[3]
   @ 4,17 say in[4]
   @ 4,41 say in[5]
   @ 4,60 say in[6]
   @ 5,17 say in[7] pict "@s15!"
   @ 5,50 say in[8]
   @ 6,17 say in[9]
   @ 6,41 say SUBSTR(in[10],1,30)
   sele 4
    go top
       Copy to Scratch\Safe
    @8,1 to 23,76
   BEGIN SEQUENCE
    dbedit(9,2,22,75,"","mon",pic,_head)
     if last()=-1
      *  Found in invcha.prg
        showbox()
        Dat_del()
        hidebox()
     ENDIF
  END
 enddo
 END
SET KEY 28 TO
SET KEY 27 TO
CLOSE ALL
RETU
*----------------------------------------
Function mon
param s,i
 if lastkey()=-1
   retu 0
 elseif lastkey()=-9
  retu 0
endif
retu 1














