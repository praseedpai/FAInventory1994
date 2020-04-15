*------------------------------------------------------------------------
* Program to print ledger balance for
* Date Last modified :-    27/03/1997
*
*
*****************************************************************************

*-------------- Set the date format to British

Set date brit
set key 27 to esc_proc

*-------------------- Open The Necessary tables

SELE 1
USE DATA\LEDGER INDEX DATA\LEDGER1,DATA\LEDGER2,DATA\LEDGER3
SELE 2
USE DATA\SGROUP INDEX DATA\SGROUP,data\sgr1
SELE 3
USE DATA\BAL_LEDG INDEX DATA\BAL_LEDG
Sele 4
Use data\narr index data\narr

*-------------- Declare Variables

Public Descrt    &&--- Account name ( description )
code=space(5)
fri=ctod("")
to=date()

*------------------- Save the Screen

curr=savescreen(9,9,13,40)
scroll(9,9,13,40,0)
@ 9,9 to 13,40 double

*-------------------- Begin a block

begin sequence

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

   *---------------- Look in the Subledger file
   sele 2
   seek code
   if !found()
     err_msg(" code not found ")
     loop
  endif

  *---------------- Save the Description 
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

  if to<fri .or. fri>date() .or. to == ctod("")
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


*------- store 0 to foo1,foo2
*-------sum amount for ac_1==code .and. month(jdate)=month(fri) .and. jdate<fri to foo1
*-------sum amount for ac_2 ==code  .and. month(jdate)=month(fri) .and. jdate<fri to foo2

*----- speed THE THING WHCIH COMPUTES OPENING BALANCE

*--
*--
   
   SELE  1   
    EXTRACT_BACK = SUBSTR( DTOC(fri) , 4 )
    START_DATE  =  CTOD("01/"+EXTRACT_BACK )

   
   STORE 0 to FOO1 , FOO2

 *   SET ORDER TO 1
 *  SET SOFTSEEK ON
 *  SEEK  DTOS( START_DATE )+code 
 *  SET SOFTSEEK OFF

  * Do While jdate<fri  .and. !eof()
  *    IF AC_1 == code
  *      foo1 = foo1 + amount
   *   endif
    *  skip
   *enddo
   *Err_msg( str(foo1 ) )

   *--- SUM  AMOUNT to foo1 WHILE  ( jdate < fri  .AND. AC_1 == code )

   SET ORDer to 1
   SET SOFTSEEK ON
   seek  DTOS( START_DATE )
   SET SOFTSEEK OFF

   Do While jdate<fri  .and. !eof()
     if (AC_1 == code )
        foo1 = foo1 + amount
     endif
     if ( AC_2 == code )
        foo2 = foo2 +amount
     endif 

     skip
   enddo
   *--   err_msg( str(foo1) + "  " + str(open_bal + foo1 - foo2 ) )
   *---SUM  AMOUNT to foo2  WHILE  ( jdate < fri  .AND. AC_2 == code ) 
   Open_bal = open_bal +foo1 -foo2  
   
            
   *--------------- Redirect the output to file
    
  
   SET DEVICE TO PRINTER
   SET PRINTER TO REPORT.TXT

   *--------------- Set Page length to 72
 
   ??CHR(27)+"C"+CHR(72)

   *----------------- Print heading 

   L_HEAD()

   
   @ lin,0 say CHR(15)+CHR(124)
   @ lin,10 say CHR(124)
   @ lin,19 say CHR(124)
   @ lin,20 say iif(opEN_bal<0,"By ","To ")+"OPENING BALANCE "
   @ lin,49 say CHR(124)

   if open_bal>0
       @ lin,50 say Str(abs(open_bal),13,2)
   endif

    @ lin,63 say CHR(124)
      if open_bal<0
        @ lin,64 say str(abs(open_bal),13,2)
       endif
    @ lin,79 say CHR(124)
    @ lin , 131 say chr(124)
    lin=lin+1


    has_iter1 = .T.
    has_iter2 = .T.
    finished1 = .F.
    finished2 = .F.
    ne_dy1_tos = fri
    ne_dy2_tos = fri


    

    

 *--------------- Loop Till End date 
 *--------------- I Have used a complicated alogrithm to 
 *--------------  Print Ledger 
 
  DO WHILE  FRI <= TO

      *---- Hasiter1 is a flag which determines whether 
      *---- We have got an entry for that particular date
      *---- we have to check for both flags to determine
      *---- parsing the file is well worth the effort 
      *---- taken

            
           HAS_ITER1 =  ( fri >= ne_dy1_tos)
           HAS_ITER2 =  ( fri >= ne_dy2_tos) 
           
  

          
      IF  ( HAS_ITER1   .and.  !FINISHED1 )  

           *--------- Select Ledger File and set the key to 1
           *--------- Soft Seek is performed to check when the
           *--------- Next Seek should be performed
           
            SELECT 1
            SET ORDER TO 1
            SET SOFTSEEK ON
            SEEK DTOS(FRI)+CODE
            nVal = Found()
            SET SOFTSEEK OFF 
            *------------------ Case Data is not found 

             IF !nVal
                  IF EOF()
                      FINISHED1 = .T.
                  ELSEIF ( jdate >  to )
                         finished1 = .t.
                  ELSE    
                        ne_dy1_tos = JDATE
                  ENDIF           

            ELSE    &&------------ Data found

                 DO WHILE JDATE == FRI .AND. AC_1==CODE .AND. !EOF()
                
                       IF LIN>65
                         @ lin,0 say repli(chr(205),131)
                         LIN=7
                         L_HEAD()
                       ENDIF

                     @LIN,0  SAY CHR(15)+ CHR(124)+STR(a->jid , 8 ) +;
                              "|"+DTOC(A->JDATE)+"|"

               *---  @ lin,2 say STR(a->jid,7)
               *---  @ lin,10 say CHR(124)
               *---  @ LIN,11  SAY DTOC(A->JDATE)
               *---  @ LIN,19 SAY CHR(124)

                   SELE 2
                   SEEK A->AC_2
                   @ LIN,20 SAY "TO "+SUBSTR(B->S_DESC,1,26) + ;
                              "|"+ Str( A->AMOUNT , 13,2 )+ ;
                               "|"+space(15)+"|"
                                
                  SELE 4
                  SEEK a->jid

                  @ LIN , 80  Say LEFT(d->NARRATION,49) + "  |"
                  open_bal=open_bal+(a->amount)
                  LIN=LIN+1
                  sele 1
                  skip
              ENDDO                            &&---  end of Do while Jdate == fri
              NE_DY1_TOS = FRI+1               &&---- fri = NE_DY2_TOS   
       ENDIF                                   &&---  end of if ( Found() )
   ENDIF                                       &&---  end of if ( has_iter1 .and.  



   IF  (  HAS_ITER2    .and. !FINISHED2 )

         SELE 1
         SET ORDER TO 2
         SET SOFTSEEK ON
         SEEK DTOS(FRI)+CODE
         nVal =Found()
         SET SOFTSEEK OFF
 
         IF !nVal 
              IF  EOF()
                 FINISHED2  = .T.
              ELSEIF ( jdate > to )
                 FINISHED2 = .t.
              ELSE 
                 ne_dy2_tos = JDATE
              ENDIF                                  
         ENDIF
             
  
         IF NVal
               
            Do while jdate == fri .and. ac_2==code .and. !eof()
                IF LIN>65
                @ lin,0 say repli(chr(205),131)
                  LIN=7
                  L_HEAD()
                ENDIF

            @ LIN,0  SAY  CHR(15)+"|"+ str(A->JID , 8 )+"|"+;
                          DTOC(a->JDATE) +"|"

          *--  @ lin,2 say STR(a->jid,7)
          *--  @ lin,10 say CHR(124)
          *--  @ LIN,11  SAY dTOC(A->JDATE)
          *--- @ LIN,19 SAY CHR(124)
           sele 2
           seek a->ac_1

           @ LIN,20 SAY "BY "+SUBSTR(B->S_DESC,1,26)+"|"+;
                         SPACE(13)+"|"+STR(A->AMOUNT,15,2)+"|"
                         
 
            SELE 4
            SEEK a->jid
            @ LIN , 80  SAY left( d->narration , 49 ) + " |"  

           
           open_bal=open_bal-(a->amount)
           LIN=LIN+1

          sele 1
          skip
        ENDDO             &&----- 

         
       NE_DY2_TOS  = FRI+1
    ENDIF
  ENDIF

   *------------- if has finished all dont try to iterate

   if ( finished1 .and. finished2 )
           EXIT
   Endif

    fri= fri +1

enddo      && enddo fri <= to

@ lin,0 SAY CHR(15)+ repli(chr(205),130)
@ lin+1,35 say CHR(18)+" CLOSING BALNCE "+str(abs(open_bal),15,2)+iif(open_bal>0," DR "," CR ")
Eject
SET DEVICE TO SCREEN
SET PRINTER TO
BROW("REPORT.TXT")
set key 27 to esc_proc
enddo
end
SELE 1
SET RELATION TO
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