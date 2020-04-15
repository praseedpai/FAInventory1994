// program to Report Any thing Fast

#include "set.ch"

Scroll(0,0,24,79)
Set( _SET_EXACT ,.t.)
Set( _SET_DECIMALS , 2 )
Set( _SET_DELETED , .t.)


PUBLIC MENU_PROMPT  := ;
  { ;
     " LEDGER            " ,; 
     " TRIAL BALANCE     " ,;
     " CASH & BANK       ",;
     " OPTION                ",;
     " OPTION                ",;
     " EXIT                  "}
 PUBLIC MENU_ACT := ;
 { ;
   { || LEDGER() },;
   { || TRIAL() },;
   { || BAL_PRI() },;
   { || FAKE() },;
   { || FAKE() },;
   { || FAKE() },;
     }

   
  
 

  PRIVATE NCHOICE


    	DO WHILE .T.
              CLEAR GETS
           SAVE SCREEN TO FOLY

           dISPbOX(4,11,20,43,2,"b+/g+/N")
           NCHOICE := ACHOICE( 5,12,20,42,MENU_PROMPT,,,1)
              
               IF NCHOICE == 6
                    CLOSE ALL
                    CLEAR
                    QUIT
               ELSEIF NCHOICE == 0
                  
                  LOOP
               ELSE
                 EVAL(MENU_ACT[NCHOICE])
                 nchoice:=1
               ENDIF
            RESTORE  SCREEN FROM FOLY

        ENDDO
  


function fake()
return 0

*------------------------------------------------------------------------
* Program to print ledger balance for
*-------------------------------------------------
FUNCTION LEDGER()
Set date brit
set key 27 to esc_proc
sele 1

use data\ledger index data\ledger1,data\ledger2,data\ledger3

sele 2
use data\sgroup index data\sgroup,DATA\SGR1
sele 3
use data\bal_ledg index data\bal_ledg
sELE 4
uSE DATA\NARR INDEX DATA\NARR
pUBLIC dESCRT
code=space(5)
fri=ctod("")
to=date()
begin sequence
curr=savescreen(9,9,13,40)
scroll(9,9,13,40,0)
@ 9,9 to 13,40 double
  Do while .t.
set colo to w+/n+,n/w,,,w+/n+
set key 28 to dode_h

@ 10,10 say " Code   " get code
 read
  set key 28 to
   if code==space(5)
     err_msg(" invalid code ")
     loop
   ENDIF   
    SN:=LEFT(CODE,2)
   IF (SN=="11" .OR. SN=="12" .OR. SN=="35")
          eRR_MSG(" cAN'T TAKE REPORT OF CASH & BANK ITEMS ")
          LOOP
  
   ENDIF
 sele 2
 seek code
   if !found()
     err_msg(" code not found ")
     loop
  endif
  DESCRT=S_DESC
  fri=ctod("")

 @ 11,10 say " from   " get fri
 read
 goo_dat=Ctod("01/04/"+if(month(date())<=3,str((year(date())-1 )%100,2),str(year(date())%100,2)))

  if fri< goo_dat  .or. fri ==ctod("")
     err_msg(" invalid date")
     keyb chr(13)
     loop
 endif

 @ 12,10 say " to     " get to
 read
   if to<fri .or. fri>date() .or. to ==ctod("")
     err_msg(" invalid date")
    keyb chr(13) +chr(13)
    loop
  endif
if month(fri)<>4
smk=month(fri)-1
smk=iif(smk>=4 .and. smk<=12,smk-3,smk+9)
else
smk=0
endif

public open_bal
  LIN=7
sele 3
seek code
rs="month"+iif(smk<=9,"0"+str(smk,1),str(smk,2))
open_bal=&rs
sele 1
store 0 to foo1,foo2
       
tap =month(fri)
seek_expr = ctod("01/"+IF( tap>=9,str(tap,2),'0'+str(tap,1) )+str(year(fri)%100,2) ) 

 set order to 1
          
   
set softseek on
    
  seek code + dtos(seek_expr)
     
       
  
sum amount to foo1 while ac_1==code .and.  jdate<fri 
  
 set order to 2
     seek code+dtos(seek_expr)

sum amount to foo2  while ac_2 ==code   .and. jdate<fri 
open_bal=open_bal+foo1-foo2
sele 2
seek code
sele 1
 SET DEVICE TO PRINTER
 SET PRINTER TO FOOL.TXT
  ??CHR(27)+"C"+CHR(72)
  L_HEAD()
    @ lin,0 say CHR(15)+CHR(124)
    @ lin,10 say CHR(124)
    @ lin,19 say CHR(124)
    @ lin,20 say iif(opEN_bal<0,"By ","To ")+"OPENING BALANCE "
    @ lin,49 say CHR(124)
           if open_bal>0
               @ lin,50 say Str(abs(open_bal),13,2)
        endif
    @ lin,64 say CHR(124)
       if open_bal<0
        @ lin,65 say str(abs(open_bal),13,2)
       endif
    @ lin,79 say CHR(124)

lin=lin+1
 Do while fri<=to
  sele 1
   set order to 1
   seek dtos(fri)+code
     if found()
      Do while jdate==fri .and. ac_1==code .and. !eof()
              IF LIN>65
                @ lin,0 say repli(chr(205),78)
                 LIN=7
                 L_HEAD()
                ENDIF

            @ LIN,0  SAY CHR(15)+ CHR(124)
            @ lin,2 say STR(a->jid,7)
            @ lin,10 say CHR(124)
             @ LIN,11  SAY DTOC(A->JDATE)
            @ LIN,19 SAY CHR(124)
           sele 2
           seek a->ac_2

           @ LIN,20 SAY "TO "+SUBSTR(B->S_DESC,1,25)
           @ LIN,49 SAY CHR(124)
           @ LIN,50 SAY str(A->AMOUNT,13,2)
           @ LIN,64 SAY CHR(124)
           @ LIN,79 SAY CHR(124)
           SELE 4
            SEEK A->JID
           @ LIN,80 SAY LEFT(NARRATION,49)
           @LIN,131 SAY CHR(124)
            
              open_bal=open_bal+(a->amount)
           LIN=LIN+1
         sele 1
          skip
        enddo
    endif
SELE 1
  set order to 2
 seek dtos(fri)+code
     if found()
       Do while jdate==fri .and. ac_2==code .and. !eof()

                IF LIN>65
                @ lin,0 say repli(chr(205),78)
                  LIN=7
                  L_HEAD()
                ENDIF

            @ LIN,0  SAY  CHR(15)+CHR(124)
            @ lin,2 say STR(a->jid,7)
            @ lin,10 say CHR(124)
            @ LIN,11  SAY dTOC(A->JDATE)
            @ LIN,19 SAY CHR(124)
           sele 2
           seek a->ac_1

           @ LIN,20 SAY "BY "+SUBSTR(B->S_DESC,1,25)
           @ LIN,49 SAY CHR(124)
           @ LIN,64 SAY CHR(124)
           @ LIN,65 SAY str(A->AMOUNT,13,2)
           @ LIN,79 SAY CHR(124)
                      SELE 4
            SEEK A->JID
           @ LIN,80 SAY LEFT(NARRATION,49)
           @LIN,131 SAY CHR(124) 
         

           
           open_bal=open_bal-(a->amount)
           LIN=LIN+1

         sele 1
          skip
        enddo
    endif
 fri= fri +1

enddo
@ lin,0 SAY CHR(15)+ repli(chr(205),130)

@ lin+1,35 say CHR(18)+" CLOSING BALNCE "+str(abs(open_bal),15,2)+iif(open_bal>0," DR "," CR ")
Eject
SET DEVICE TO SCREEN
SET PRINTER TO
BROW("FOOL.TXT")
set key 27 to esc_proc
enddo
end
set key 27 to
Set key 28 to
restscreen(9,9,13,40,curr)
retu

FUNCTION L_HEAD
 @ 1,5 say "       S I M I L I A   H O M O E O   L A B O R A T O R Y   "
 @ 2,20 say "  Ledger Balance Of   "+DESCRT
 @ 3,20 say "   from    " + dtoc(fri) + "  to "+dtoc(to )
 @ 4,0 SAY  CHR(15)+REPLI(chr(45),130)
 @ 5,0 say CHR(15)+ "   jr.no     Date             Descreption              Debit            Credit            narraTION      "
 @ 6,0 SAY CHR(15)+REPLI (chr(45),130)
 RETU 0


   *FUNCTION MODE_H
    PROC dODE_H
    Set key 27 to
    set key 28 to
   PRIVATE FIL[2],SAMP[2]
     fil[1]="S_code"
     FIL[2]="S_desc"
     samp[1]=" CODE  "
     SAMP[2]="  DESCRIPTION  "
      xf=savescreen(4,9,23,61)
      public foo
      foo=""
       set key 28 to
          rST=SELECT()
         sele 2
         sET ORDER TO 2
        msav=setcolor("/w+,w+/n")
          @ 4,9 to 21,61 double
           dbedit(5,10,20,60,fil,"sUNCR","",samp)
          sET ORDER TO 1          
 sELECT(RST)        
    
  setcolor(msav)
         set key 27 to Esc_proc
         set key 28 to dode_h
          restscreen(4,9,23,61,xf)
          release xf

function sUNCR
param dfg,klm
   kes=lastkey()
 do case
   case kes=13
      KEYB b->s_code
      RETURN 0
   case KES=27
      RETURN 0
      CASE KES>=32
        FOO=FOO+upper(CHR(KES))
      CASE KES==8
        FOO=SUBSTR(FOO,1,LEN(FOO)-1)
      OTHERWISE
       RETU 1
     ENDCASE
      @ 22,9 SAY SPACE(52)
      @ 22,9 SAY FOO
          set softseek on
              seek foo
          set softseek off
            keyb chr(0)
             return 2
         
*--------------------------------------------------
*---------------FUNCTION TO SAVE THE DATA TO THE FILE
* Program to Print Trial Balance
*
*********************************************
 
FUNCTION TRIAL()
Set date brit
set key 27 to esc_proc
sele 1
use data\ledger index data\ledger1,data\ledger2,data\ledger3

sele 2
use data\sgroup index data\sgroup
Lin=0
fri=ctod("")
to=date()
begin sequence
curr=savescreen(9,9,13,40)
scroll(9,9,13,40,0)
@ 9,9 to 13,40 double
  Do while .t.
set colo to w+/n+,n/w,,,w+/n+
  set key 28 to

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
    keyb chr(13)
    loop
  endif

  Exit
 Enddo

   sele 1
    index on AC_1 to Scratch\PT_temp FOR ( jdate>=fri .and. jdate<=to)
    index on AC_2 to Scratch\PT_temp1 FOR ( jdate>=fri .and. jdate<=to)

       SET INDEX TO SCRATCH\PT_TEMP,SCRATCH\PT_TEMP1
        
    
              Sele 2
                     Dr_tot=0
                      Cr_tot=0
                       LIN=6
                        sET dEVICE tO pRINTER
                        sET pRINTER TO pREP.REP
                          tROJAN()
                    Do While !Eof()
                        Rs=S_code
                         SEle 1
                          Set order to 1
                           Seek Rs
                             Sum amount To  Foo  While Ac_1==Rs
                           Set order to 2
                             sEEK rS
                             Sum Amount to  Foo1 while Ac_2==Rs
                               Bal=Foo-Foo1
                               IF Bal <>0
                                 @ lin,1  Say b->S_desc
                                 @ lin,37 Say CHR(186)
                                   IF Bal >0
                                      Dr_tot=Dr_tot+Bal
                                      @ lin,38 Say Str(bal,15,2)
                                      @ lin,54 Say CHR(186)
                                   Else
                                      Cr_Tot=Cr_tot+aBS(Bal)
                                      @ LIN,54 sAY CHR(186)
                                      @ lin,55 Say Str(-Bal,15,2)
                                   Endif

                                    @ lin,72 Say CHR(186)

                                     Lin=lin+1
                                      eNDIF
                                       IF LIN>60

                                           LIN=6
                                           eJECT
                                       tROJAN()
                                        eNDIF

                                  Sele 2
                                    sKIP
                               ENDDO

@ lin,1 Say Repli(chr(205),72)
LIN=LIN+1
@ LIN,1 sAY " tOTAL      >>"
@ LIN,38 sAY sTR(dR_TOT,15,2)
@ LIN,55 sAY sTR(CR_TOT,15,2)
@ LIN+1,1 sAY rEPLI(CHR(205),72)
                          SET dEVICE tO sCREEN
                          sET pRINTER TO
                          bROW("pREP.REP")
       end
    Set key 27 to
                          Clear Gets
                         cLOSE ALL
                         rETURN




fUNCTION tROJAN
@ 1,0 sAY  cENTER(" S I M I L I A  H O M O E O   L A B O R A T O R Y ")
@ 2,0 sAY  cENTER(" TRIAL BALANCE ")
@ 3,0 sAY  cENTER(" From   "+dTOC(fRI) + "     tO    "+dTOC(TO) )
@ 4,0 sAY  "         aCCOUNTS                       dEBIT            cREDIT   "
@ 5,0 sAY  rEPLI(chr(205),72)
rETURN 0


FUNCTION CENTER(SDE)
RETURN PADC(SDE,80)







FUNCTION BAL_PRI()
Set date brit
set key 27 to esc_proc
sele 1
use data\ledger index data\ledger1,data\ledger2,data\ledger3
sele 2
use data\sgroup index data\sgroup,DATA\SGR1
sele 3
use data\bal_ledg index data\bal_ledg
sELE 4
uSE DATA\NARR INDEX DATA\NARR
pUBLIC dESCRT,CODE,FRI,TO
code=space(5)
fri=ctod("")
to=date()
begin sequence
curr=savescreen(9,9,13,40)
scroll(9,9,13,40,0)
@ 9,9 to 13,40 double
  Do while .t.
set colo to w+/n+,n/w,,,w+/n+
set key 28 to dode_h

@ 10,10 say " Code   " get code
 read
  set key 28 to
   if code==space(5)
     err_msg(" invalid code ")
     loop
   endif
 sele 2
 seek code
   if !found()
     err_msg(" code not found ")
     loop
  endif
  DESCRT=S_DESC
  fri=ctod("")

 @ 11,10 say " from   " get fri
 read
 goo_dat=Ctod("01/04/"+if(month(date())<=3,str((year(date())-1 )%100,2),str(year(date())%100,2)))

  if fri< goo_dat  .or. fri ==ctod("")
     err_msg(" invalid date")
     keyb chr(13)
     loop
 endif

 @ 12,10 say " to     " get to
 read
   if to<fri .or. fri>date() .or. to ==ctod("")
     err_msg(" invalid date")
    keyb chr(13) +chr(13)
    loop
  endif
if month(fri)<>4
smk=month(fri)-1
smk=iif(smk>=4 .and. smk<=12,smk-3,smk+9)
else
smk=0
endif

public open_bal
  LIN=7
sele 3
seek code
rs="month"+iif(smk<=9,"0"+str(smk,1),str(smk,2))
open_bal=&rs
sele 1

PUBLIC FOO1 , FOO2 , SNT

snt:=month(fri)

store 0 to foo1,foo2

DBEVAL( { | | A1Q()},,,,,)

 // sum amount TO FOO1 for ac_1==code .and. month(jdate)=month(fri) .and. jdate<fri 
 // sum  amount TO FOO2 for ac_2 ==code  .and. month(jdate)=month(fri) .and. jdate<fri 

open_bal=open_bal+foo1-foo2
sele 2
seek code
sele 1
 SET DEVICE TO PRINTER
 SET PRINTER TO FOOL.TXT
  ??CHR(27)+"C"+CHR(72)
  L_HEAD()
    @ lin,0 say CHR(15)+CHR(124)
    @ lin,10 say CHR(124)
    @ lin,19 say CHR(124)
    @ lin,20 say iif(opEN_bal<0,"By ","To ")+"OPENING BALANCE "
    @ lin,49 say CHR(124)
           if open_bal>0
               @ lin,50 say Str(open_bal,13,2)
           endif
    @ lin,64 say CHR(124)
       if open_bal<0
        @ lin,65 say str(-open_bal,13,2)
       endif
    @ lin,79 say CHR(124)

lin=lin+1
 Do while fri<=to
  sele 1
   set order to 1
   seek dtos(fri)+code
     if found()
      Do while jdate==fri .and. ac_1==code .and. !eof()
              IF LIN>65
                @ lin,0 say repli(chr(205),78)
                 LIN=7
                 L_HEAD()
                ENDIF

            @ LIN,0  SAY CHR(15)+ CHR(124)+STR(A->JID,7)+" "+CHR(124)+DTOC(A->JDATE)+CHR(124)
        //    @ lin,2 say STR(a->jid,7)
         //   @ lin,10 say CHR(124)
          //   @ LIN,11  SAY DTOC(A->JDATE)
          //   @ LIN,19 SAY CHR(124)
           sele 2
           seek a->ac_2

           @ LIN,20 SAY "TO "+SUBSTR(B->S_DESC,1,26)+CHR(124)+str(A->AMOUNT,13,2)+CHR(124)
       //    @ LIN,49 SAY CHR(124)
        //   @ LIN,50 SAY str(A->AMOUNT,13,2)
         //  @ LIN,64 SAY CHR(124)
         //   @ LIN,79 SAY CHR(124)
           SELE 4
            SEEK A->JID
           @ LIN,80 SAY LEFT(NARRATION,49)+"  "+CHR(124)
          //  @LIN,131 SAY CHR(124)
            
              open_bal=open_bal+(a->amount)
           LIN=LIN+1
         sele 1
          skip
        enddo
    endif
SELE 1
  set order to 2
 seek dtos(fri)+code
     if found()
       Do while jdate==fri .and. ac_2==code .and. !eof()

                IF LIN>65
                @ lin,0 say repli(chr(205),78)
                  LIN=7
                  L_HEAD()
                ENDIF

        
           @ LIN,0  SAY CHR(15)+ CHR(124)+STR(A->JID,7)+CHR(124)+DTOC(A->JDATE)+CHR(124)
        ///    @ LIN,0  SAY  CHR(15)+CHR(124)
        //    @ lin,2 say STR(a->jid,7)
        //    @ lin,10 say CHR(124)
        //    @ LIN,11  SAY dTOC(A->JDATE)
        //    @ LIN,19 SAY CHR(124)
           sele 2
           seek a->ac_1

           @ LIN,20 SAY "BY "+SUBSTR(B->S_DESC,1,25)+CHR(124)
//           @ LIN,49 SAY CHR(124)
           @ LIN,64 SAY CHR(124)
           @ LIN,65 SAY str(A->AMOUNT,13,2)
           @ LIN,79 SAY CHR(124)
                      SELE 4
            SEEK A->JID
           @ LIN,80 SAY LEFT(NARRATION,49)
           @LIN,131 SAY CHR(124) 
         

           
           open_bal=open_bal-(a->amount)
           LIN=LIN+1

         sele 1
          skip
        enddo
    endif
 fri= fri +1

enddo
@ lin,0 SAY CHR(15)+ repli(chr(205),130)

@ lin+1,35 say CHR(18)+" CLOSING BALNCE "+str(abs(open_bal),15,2)+iif(open_bal>0," DR "," CR ")
Eject
SET DEVICE TO SCREEN
SET PRINTER TO
BROW("FOOL.TXT")
set key 27 to esc_proc
enddo
end
set key 27 to
Set key 28 to
restscreen(9,9,13,40,curr)
retu

FUNCTION A1Q()


 IF (  (MONTH(_FIELD->JDATE)==SNT ) .AND. _FIELD->JDATE <FRI)

    IF ( CODE == _FIELD->AC_1)
        FOO1 +=AMOUNT
    ELSEIF ( CODE == _FIELD->AC_2)
        FOO2 +=AMOUNT
    ENDIF
 
ENDIF



return 0



