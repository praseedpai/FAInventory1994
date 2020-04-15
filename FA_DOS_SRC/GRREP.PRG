*pROGRAM TO PRINT SEGMENTED INVOICE DETAILS
* DATE WRITTEN :- 01/04/95
Set date brit
SET DELETED ON
set key 27 to esc_proc
clear all
close all
sele 1
use stock\invoice index stock\invoice
code=space(5)
PUBLIC FRI,TO
fri=ctod("")
to=date()
begin sequence
curr=savescreen(9,9,13,40)
scroll(9,9,13,40,0)
@ 9,9 to 13,40 double
  Do while .t.
     set colo to w+/n+,n/w,,,w+/n+
      fri=ctod("")
        @ 11,10 say " from   " get fri
        read
 goo_dat=Ctod("01/04/"+if(month(date())<=3,str((year(date())-1 )%100,2),str(year(date())%100,2)))
  if fri< goo_dat  .or. fri ==ctod("")
     err_msg(" invalid date")
     loop
 endif
 @ 12,10 say " to     " get to
 read
   if to<fri .or. fri>date() .or. to ==ctod("")
     err_msg(" invalid date")
    loop
  endif
*sele 1
*use stock\invoice index stock\invoice

Sele 1
COPY TO SAPPY FOR INVDATE>=FRI .AND. INVDATE<=TO 
sele 2 
USE SAPPY
  if reccount()==0
       Err_msg("no entry")
       break
  endif
GO TOP
Set device to printer
set printer to fool.txt
??chr(27)+"C"+chr(72)
HRT_C()
lin=6
tote=0
tot8=0
tot4=0
tot10=0
tnil=0

 dO WHILE !EOF()
    @ LIN,1 SAY ltrim(STR(INVNO,8))
    @ LIN,10 SAY "|"
     IF TRATE==8
        @ LIN,11 SAY If(tamount>0,STR(tAMOUNT,10,2),"   ")
        tot8=tot8+tamount
       Endif
    @ lin,22 Say "|"
     IF TRATE==4
        tot4=tot4+tamount
       @ LIN,23 SAY if(tamount>0,STR(TAMOUNT,10,2),"    ")
     Endif
    @ lin,34 say "|"   
     IF TRATE==10
        tot10=tot10+tamount
       @ LIN,35 SAY If(tamount>0,STR(TAMOUNT,10,2),"   ") 
     ENDIF
    @ lin,46 say "|"
     tnil=tnil+namount
    @ LIN,47 SAY  If(namount>0,STR(NAMOUNT,12,2),"  ")
    @ lin,60 say "|"
    tote=tote+rtotal   
 @ LIN,61 SAY  STR(RTOTAL,12,2)
    @ lin,74 say "|"
       lin=lin+1
       if lin>65
          @lin,1 say repli("-",75)
          eject
         hrt_c()
       lin=6
      endif 
  SKIP
  ENDDO
@ lin,1 say repli("-",75)
lin=lin+1

@ lin,1 say  "Total:=" 
 @lin,11 say  If(tot8>0,str(tot8,10,2),"  ")
 @lin,23 say   if(tot4>0,str(tot4,10,2),"  ")
 @lin,34 say   if(tot10>0,str(tot10,10,2),"  ")
 @lin,47 say   if(tnil>0, str(tnil,12,2),"   ")
 @lin,61 say   if(tote>0, str(tote,12,2),"    ")        
Eject
SET DEVICE TO SCREEN
SET PRINTER TO
BROW("FOOL.TXT")
set key 27 to esc_proc
enddo
end
close all
set key 27 to
Set key 28 to
restscreen(9,9,13,40,curr)
retu

function hrt_C
@ 1,16 Say       "S I M I L I A  H O M O E O  L A B O R A T O R Y"
@ 3,1  SAY " INVOICE                    TAX                  NTAXABLE       TOTAL    "
@ 4,1 SAY  "  NO          8%          4%           10%                              "
@ 5,1 SAY REPLI("-",75)
RETU 0                       
