
* BEGIN DOC
* PROCEDURE FOR JOURNAL deletion
* NO PARAMETER
* GENERIC??!
* PROGRAMMER PRASEED PAI
* END DOC
*-----------------------------------------------
Param _what
Set deleted on
PRIVATE AER1[4]
AER1[1]="jdesc"
AER1[2]="jcat"
AER1[3]="amount"
*-----------------------------------
PRIVATE HEAD1[4]
HEAD1[1]="DESCRIPTION"
HEAD1[2]="DR/CR  "
HEAD1[3]="AMOUNT "
*-------------------------------------
PRIVATE PICT1[4]
PICT1[1]="@!"
PICT1[2]="!!"
PICT1[3]="99999999999999.99"
*-------------------------------------
 SELE 1
 use data\journal index data\journal,data\journal1
  GO BOTT
  JUI=J_ID+1
SELE 2
   use data\ledger index  data\ledger1 ,data\ledger2,data\ledger3,data\ledger4,data\ledger5
Sele 3
  use data\tempor
sele 4
  use data\BAL_LEDG INDEX data\BAL_LEDG

Sele 8
  Use data\narr index Data\narr
public whater
whater="V"
    * -----------------------START OF LOOP TO EDIT
    scroll(0,0,24,79,0)
    set colo to /W
    @ 1,5 say space(65)
    @ 1,15 say "    J O U R N A L  V O U C H E R  "+if(_what =="D"," (deletion) "," (view) ")
        @ 24,0 SAY SPACE(79)
    @ 24,0 SAY CENTER(" F2-DELETE & NEXT  ESC-CANCEL  ")
     SET COLO TO
     @ 2,5 to 4,70
     @ 3,10 say "JOURNAL NO "
     @ 3,45 SAY "DATE "
set key 27 to esc_proc
 JRNO=0
Public NARR_str,Mdoc
Mdoc="JV"
Set key -3 To Edit_narr
  begin sequence
    DO  WHILE .T.
      SELE 3
       ZAP
     @ 3,25 GET JRNO PICT "99999999"
      READ
         IF JRNO<=0
           ERR_MSG(" INVALID NUMBER ")
         LOOP
         ENDIF
          SELE 1
          SEEK JRNO
            IF !FOUND()
              ERR_MSG(" NO NOT FOUND ")
            LOOP
           ENDIF
           if J_DOC <>"JV"
              Err_msg(" Invalid Mode ")
              loop
           endif
           SELE 2
           set order to 3
           SEEK JRNO
             IF !FOUND()
              ERR_MSG(" NO NOT FOUND IN LEDGER ")
            LOOP
           ENDIF

           DO WHILE A->J_ID=JRNO .AND. !EOF()
              SELE 3
               APPEN BLANK
                SELE 1
                 REPLACE c->J_ID WITH J_ID ,c->J_DOC WITH J_DOC
                 REPLACE c->JDATE WITH JDATE,c->JCODE WITH JCODE
                 REPLACE c->JDESC WITH JDESC,c->JCAT WITH JCAT
                 REPLACE c->AMOUNT WITH AMOUNT
                SKIP

              ENDDO
             Sele 8
             Seek Jrno
             Narr_str=Narration
             SELE 3


            @ 5,1 to 22,78
              go top

              @ 3,55 say jdate
               begin sequence
           DBEDIT(6,2,21,77,aer1,"lap1",pict1,head1)
               end
                If _what=="V"
                  loop
                endif
IF LASTKEY()=-1
   SELE 3
     GO TOP
   HIFI=MONTH(JDATE)
   MHIFI=MONTH(DATE())
   HIFI=IIF(HIFI>=4 ,HIFI-3,HIFI+9)
   MHIFI=IIF(MHIFI>=4 ,MHIFI-3,MHIFI+9)
        DO WHILE   !EOF()
          SELE 4
          SEEK c->JCODE
          FOR  I=HIFI TO MHIFI
             rap='month'+iif(i<=9,'0'+str(i,1),str(i,2))
             REPLACE &RAP WITH &RAP+IF(C->JCAT="CR",C->amount,-(C->amount))       
           NEXT I
           SELE 3
           SKIP
       enddo
                    SELE 1
                     SEEK jrno
                       if found()
                           do while jrno=j_id  .and. !eof()
                             REPLACE JCODE WITH '00000',jcat with "  ",AMOUNT WITH 0
                             DELETE
                           skip
                         enddo
                      endif
                SELE 2
               set order to 3
              SEEK jrno
              do while jid==jrno .and. !eof()
               REPLACE AC_1 WITH '0000',AC_2 WITH '0000',amount with 0.00,jdate with ctod("")
               DELETE
              skip
             enddo
             Sele 8
             Delete
             Narr_str=space(75)
         ENDIF
ENDDO
       END
set key 27 to
set key 28 to
close all
return

 function lap1
 param _so,_ko
 ker=lastkey()
 if (ker=-1)
       RETURN 0
 ELSEIF (KER=27)
       RETURN 0
 ENDIF
  RETURN 1

