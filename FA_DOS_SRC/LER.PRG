*------------ Program to print Ledger balance in a faster way
*------------
*-------------
*
**************************************************************

Set date brit
set key 27 to Esc_proc

*------------- use journal file

Sele 1
   Use data\journal index data\journal1

*------------- use subgroup file
  
Sele 2
   Use data\sgroup index data\sgroup,data\sgr1

*--------------- use balance file 

sele 3
   Use data\bal_ledg index data\bal_ledg

*------------------ use narration

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
tap =month(fri)
seek_expr = ctod("01/"+IF( tap>=9,str(tap,2),'0'+str(tap,1) )+str(year(fri)%100,2) )
sele 1

   
   set softseek on

   seek  code + Dtos(seek_expr)

   set softseek off
           
  
             
      do while jcode == code .and. jdate <fri    
          
   
         open_bal = open_bal + IF (jcat == "DR" ,amount, -1*amount)
         skip
       enddo
        
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

                
   set softseek on
      
      seek code+dtos(fri)

    set softseek off
  
        do while jcode == code .and. jdate<=to  .and. !eof()   
                  
               IF LIN>65
                  @ lin,0 say repli(chr(205),78)
                  LIN=7
                  L_HEAD()
                 ENDIF
                   
          IF jcat == "DR"   
                 @ LIN,0  SAY CHR(15)+ CHR(124)
                 @ lin,2 say STR(a->j_id,7)
                 @ lin,10 say CHR(124)
                 @ LIN,11  SAY DTOC(A->JDATE)
                 @ LIN,19 SAY CHR(124)
                 @ LIN,20 SAY "TO "+SUBSTR(Jdesc,1,25)
                 @ LIN,49 SAY CHR(124)
                 @ LIN,50 SAY str(AMOUNT,13,2)
                 @ LIN,64 SAY CHR(124)
                 @ LIN,79 SAY CHR(124)
                 SELE 4
                   SEEK A->J_ID
                 @LIN,80 SAY LEFT(NARRATION,49)
                 @LIN,131 SAY CHR(124)
                 open_bal=open_bal+(a->amount)
                 LIN=LIN+1
          ELSE  

                 @ LIN,0  SAY  CHR(15)+CHR(124)
                 @ lin,2 say STR(a->j_id,7)
                 @ lin,10 say CHR(124)
                 @ LIN,11  SAY dTOC(A->JDATE)
                 @ LIN,19 SAY CHR(124)
                 @ LIN,20 SAY "BY "+SUBSTR(jdesc,1,25)
                 @ LIN,49 SAY CHR(124)
                 @ LIN,64 SAY CHR(124)
                 @ LIN,65 SAY str(A->AMOUNT,13,2)
                 @ LIN,79 SAY CHR(124)
                      SELE 4
                     SEEK A->J_ID
                    @ LIN,80 SAY LEFT(NARRATION,49)
                     @LIN,131 SAY CHR(124) 
         
              open_bal=open_bal-(a->amount)
                LIN=LIN+1

          Endif  
         sele 1
          skip
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
