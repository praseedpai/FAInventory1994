* PROGRAM TO PRINT JOURNAL
* AT PRESENT NO PARAMETER IS SPECIEFIED
* SCOPE IS WHOLE FILE
*-----------------------------------------------
Param _num
scroll(7,20,10,50,0)
@ 7,20 to 10,50 double
Fro=Ctod("")
Tom=date()
@ 8,21 say " From Date "  Get fro
@ 9,21 say " To Date   "  Get Tom
Read
if lastkey()==27
   Retu 
endif   
Public Head
Do case
  Case _num==1
    Tomy="JV"
    Head=" Jounal Vouchers "
  Case _num==2
    tomy="CR"
    head=" CASh Reciepts   "
  Case _num==3
    tomy="CP"
    head=" Cash Payments  "
  case _num==4
   tomy="BR"
   head=" Bank Reciepts  "
  case _num==5
   Tomy="BP"
   head=" Bank Payments "
 Endcase


SELE 1
USE DATA\JOURNAL INDEX DATA\JOURNAL
copy to temp for jdate>=Fro .and. jdate<=tom .and. j_doc==Tomy
Sele 1
Use temp
  If reccount()==0
    close all
    Err_msg( " No entry  ")
    retu
  endif

SELE 2
USE DATA\SGROUP INDEX DATA\SGROUP
SELE 1
  SET DEVICE TO PRINTER
  SET PRINTER TO FOOL
  TS1_HEAD()
 MLIN=8
  DO WHILE !EOF()
       KID=J_ID

        DO WHILE J_ID==KID .AND. !EOF()
            @ MLIN,1 SAY J_ID PICT "999999"
            @ MLIN,9 SAY CHR(179)
            SELE 2
            SEEK A->JCODE
             SELE 1
                IF JCAT=="DR"

                  @ MLIN,10 SAY  SUBSTR(B->S_DESC,1,22) + "Dr"
                ELSE
                  @ MLIN,10 SAY  "To "+SUBSTR(B->S_DESC,1,21)
                 ENDIF

                 @ MLIN,37 SAY CHR(179)
         IF JCAT=="DR"
             @ MLIN,38 SAY AMOUNT PICT "99999999999.99"
             @ MLIN,55 SAY CHR(179)
          ELSE
             @ MLIN,55 SAY CHR(179)
             @ MLIN,57 SAY AMOUNT PICT "99999999999.99"
         ENDIF

         MLIN=MLIN+1
          SKIP
       ENDDO

           @ MLIN,0 SAY REPLI(CHR(205),80)
           MLIN=MLIN+1

      IF MLIN>55
        EJECT
        TS1_HEAD()
        MLIN=8
      ENDIF
   ENDDO
Eject
SET DEVICE TO SCREEN
SET PRINTER TO
BROW("FOOL.PRN")
CLOSE ALL
release head
RETU




FUNCTION TS1_HEAD
 @ 1,5 say "       S I M I L I A   H O M O E O  L A B O R A T O R Y   "
 @ 2,20 say  head
  @ 3,0 say "  DATE :- " +DTOC(DATE())
 @ 4,0 SAY "  TIME :- "+TIME()
 @ 5,0 SAY REPLI(chr(205),80)
 @ 7,0 SAY REPLI (chr(205),80)
 RETU 0










