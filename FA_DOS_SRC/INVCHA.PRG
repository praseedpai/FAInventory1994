* Program to change details regarding invoices
* caution hypersensitive
*
*
*-------------------------------invoice summary
set century on 
set deleted on
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
*------------------------------------------dealer file
SELE 5
 use stock\dealer index stock\dealer
public awe
*---------------------------------------
Public TOt_sal,C_S_T,mpas
mpas=0
*-----------------------------------------------------
scroll(0,0,24,79,0)
@ 2,1 to 8,75 double
public sdis
sdis=0
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
 in[6]=space(15)
 in[7]=space(25)
 in[8]=space(20)
 in[9]=ctod("")
 in[10]=space(46)
 in[11]=0
 in[12]=0
 set colo to /w
@ 24,0 say space(79)
@ 24,0 say center(  "  F1-Codelist   F7-change DIscount rate   ESC-cancel while not editing ")
 *----------------------------
 set colo to
  declare ar[6]
sele 1
set delimiters to '()'
set delim on

*---------------------------array of picture to dbedit
private pic[8]
pic[1]="@!"
pic[2]="@s20!"
pic[3]="99999"
pic[4]="999.99"
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
public fill
Public mdoi
BEGIN SEQUENCE
Do while .t.
Sele 4
zap

set colo to w+/n+,n/w,,,w+/n+
   @ 3,17 get in[1] pict "99999999"
   read
     if (in[1]<0)
       err_msg(" INVALID INVOICE NUMBER ")
      LOOP
     ENDIF
  sele 1
     SEEK IN[1]
      IF !FOUND()
        ERR_MSG(" Such an Invoice Doe'sn'tExit")
        LOOP
      ENDIF
for i=2 to  11
  g=field(i)
  in[i]=&g
next i
in[12]=trate
mdoi=doi
awe=adi
sele 4
 rdef=month(mdoi)
 rdef=if(rdef<=3,rdef+9,rdef-3)
 vfile='stock\'+"inv"+if(rdef<=9,'0'+str(rdef,1),str(rdef,2))
 if !file(vfile+".dbf")
      err_msg("invoice file is lost or power gone while writing data for this invoice ")
      loop
endif
sele 6
 use &vfile index &vfile

  seek in[1]
    do while invno==in[1]
         sele 4
          append blank
           replace code with f->code,desc with f->desc,;
           packing with f->packing,rate with f->rate,;
           quant with f->quant ,amount with f->amount;
           taxable with f->taxable,disc with f->disc
           sele 6
          skip
   enddo


   @ 3,41 get in[2]
   read
     IF IN[2]>DATE()+10
        ERR_MSG(" INVALID DATE ")
         KEYB CHR(13)
         LOOP
     ENDIF
  SET KEY 28 TO CUST_HELP
   @ 3,65 get in[3] PICT "@!"
    read
      sele 5
       seek in[3]
        if !found()
          err_msg(" not frequent customer ??")
        endif
     sET KEY 28 TO
   set colo to w+/n+,n/w,,,w+/n+
   @ 4,17 get in[4] PICT "@!"
 read
    if in[4]==space(10)
           err_msg(" blank ??")
           keyb chr(13)+chr(13)+chr(13)
           loop
    endif
@ 4,41 get in[5]
 read
   @ 4,60 get in[6] PICT "@s10!"
 read
   @ 5,17 get in[7] pict "@s15!"
 read
   @ 5,50 get in[8] PICT "@!"
 read
  @ 6,17 get in[9]
 read
   @ 6,41 get in[10]   pict "@s20!"
   read

  Do while  .t.
  @ 7,3  Prompt "KGST"
  @ 7,10  Prompt "CST "
  menu to rmn
    if rmn==0
       loop
    elseif rmn==1
    indflag=" KGST "
   else
     indflag=" CST "

   endif
   @ 7,3 clea to  7,20
   @ 7,3 Say indflag
   exit
  enddo
 Do while .t.
   @ 7,20 Say "Tax Rate %  :-"  Get in[12] pict "9999999.99"
   Read
    if in[12]<=0
       Err_msg(" INVALid rate ")
       loop
    endif
   if Chr(err_msg("Confirm(y/n)"))$"Yy"
         Exit
   else
   loop
   endif
 Enddo
 @ 7,60 say "ADD DIs." get awe pict "99.99"
 read
sele 4
  Go top
 copy to Scratch\safe
  @9,1 to 23,76
  BEGIN SEQUENCE
     keyb chr(32)
  dbedit(10,2,22,75,"","rap",pic,_head)
     if last()=-1
       showbox()
       Dat_del()
       Dat_SAVE()
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
Func Dat_del
 Sele 1
   SEEK in[1]
   Delete
 SELE 10
   use Scratch\safe

  dO WHILE !EOF()
      SELE 2
         SEEK J->CODE
      SELE 10
         REPLACE  B->IT_QTY WITH B->IT_QTY +(qUANT*Packing)
        
          
      skip
   ENDDO
    sele 6

    delete all for invno=in[1] 
    Retu 0


