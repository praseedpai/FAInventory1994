*------------------------------------------------------------------------
* Program to print ledger balance for
*-------------------------------------------------
param _whoo
set century on 
sumofvalue = 0.0 
Set date brit
set key 27 to esc_proc
sele 1
use stock\invoice index stock\invoice1,stock\invoice
    
sele 5
use stock\dealer index stock\dealer
code=space(4)
PUBLIC FRI,TO
fri=ctod("")
to=date()
begin sequence
curr=savescreen(9,9,13,40)
scroll(9,9,13,40,0)
@ 9,9 to 13,40 double
  Do while .t.
set colo to w+/n+,n/w,,,w+/n+
if _whoo=="1"
set key 28 to Cust_help
@ 10,10 say " Code   " get code
 read
  set key 28 to
   if code==space(4)
     err_msg(" invalid code ")
     loop
   endif
 sele 5
 seek code
   if !found()
     err_msg(" code not found ")
     loop
  endif
endif
  fri=ctod("")

 @ 11,10 say " from   " get fri
 read
 goo_dat=Ctod("01/04/"+if(month(date())<=3,str((year(date())-1 ),4),str(year(date()),4)))
  if fri< goo_dat  .or. fri ==ctod("")
     err_msg(" invalid date")
        IF _WHOO=="1"
          KEYB CHR(13)
          ENDIF
     loop
 endif

 @ 12,10 say " to     " get to
 read
   if to<fri .or. fri>date() .or. to ==ctod("")
     err_msg(" invalid date")
    keyb IIF(_WHOO=="1",chr(13) +chr(13),CHR(13))
    loop
  endif
Sele 1
if _whoo=="1"
  locate for party_cd==code .and. invdate>=fri
else
  SORT ON INVDATE to stock\scratch for invdate>=fri .and. invdate<=to
 sele 1
  use stock\scratch 
        

endif
Set device to printer
set printer to fool.txt
sumofvalue = 0.0 
??chr(27)+"C"+chr(72)
HRT_HEAD()
lin=6
@ lin,0 say repli(chr(205),80)
 if _whoo=="1"

 Do while Party_cd==code .and. invdate<=to

    @lin,0  Say invdate
    @lin,10 say chr(179)
    @lin,11 say str(invno,12)
    @ lin,23 say chr(179)
    @lin,24 say str(rtotal,15,2)
    sumofvalue = sumofvalue+rtotal
    lin=lin+1
    if lin>=65
      lin=6
      eject
      HRT_HEAD()
    endif
skip
enddo
@ lin,0 say repli(chr(205),80)
@ lin+1,0  say "Total Amount  "
@ lin+1,24 say str(sumofvalue,15,2)
set century on 
else
go top
 Do while  !Eof()
    @lin,0  Say invdate
    @lin,10 say chr(179)
    @lin,11 say str(invno,12)
    @ lin,23 say chr(179)
    @lin,24 say str(rtotal,15,2)
    @ lin,40 say chr(179)
    sele 5
    seek A->party_cd
    sele 1
    @ lin,41 Say E->dlr_name
    lin=lin+1
    if lin>=65
      lin=6
      eject
      HRT_HEAD()
    endif
    skip
enddo



endif
Eject
SET DEVICE TO SCREEN
SET PRINTER TO
BROW("FOOL.TXT")
set century on 
set key 27 to esc_proc
enddo
end
set key 27 to
Set key 28 to
restscreen(9,9,13,40,curr)
set century on 
retu

function hrt_head
@ 1,16 Say       "S I M I L I A  H O M O E O  L A B O R A T O R Y"
if _whoo=="1"
@ 2,18 sAY "INVOICE ISSUED TO "+SUBSTR(e->DLR_NAME,1,25)
@ 3,0 SAY"                     FROM "+DTOC(FRI) + " TO "+DTOC(TO)
@ 5,0 SAY " DATE        INVOICE NO        AMOUNT "
 else
 @ 2,30 say "INVOICE ISSUED "
 @ 3,0 SAY"                     FROM "+DTOC(FRI) + " TO "+DTOC(TO)
 @ 5,0 SAY " DATE        INVOICE NO        AMOUNT      ISSUED TO     "
ENDIF
RETU 0
