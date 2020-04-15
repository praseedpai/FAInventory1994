* procedure to change journal entries
* no param
*----------------------------------
sele 1
use data\journal index data\journal,data\journal1
sele 2
 use data\ledger index  data\ledger1 ,data\ledger2,data\ledger3,data\ledger4,data\ledger5
sele 3
  use data\tempor
sele 4
  use data\sgroup index data\sgroup,data\sgr1
sele 5
  use data\bal_ledg index data\bal_ledg
Sele 7
  Use data\Narr index data\Narr
set deleted on
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
public mdat,sDR,mdoc,fir,foo,jrno,Narr_str
mdoc="JV"
narr_str=space(75)
jrno=0
mdat=ctod("")

WHATER="E"
* -----------------------start of loop to edit
      scroll(0,0,24,79,0)
      set colo to /W
     @ 1,5 say space(65)
     @ 1,15 say "    J O U R N A L  V O U C H E R  (change) "
     @ 24,0  SAY SPACE(79)
     @ 24,0 SAY CENTER("  F1-CodeList  F2-save & Next  Esc-cancel Del-Delete  ")

       set colo to
       @ 2,5 to 4,70
      @ 3,10 say "JOURNAL NO "
             @ 3,45 say " DATE "

  Set Key -3 To eDIT_NARR


*-------------------------------------
set key 27 to esc_proc
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
           If j_DOC !=Mdoc
              err_msg(" INvalid Mode ")
              loop
           Endif
           SELE 2
           set order to 3
           SEEK JRNO
             IF !FOUND()
              ERR_MSG(" NO NOT FOUND IN LEDGER ")
            LOOP
           ENDIF

            sele 1
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
               Sele 7
               Seek Jrno
               Narr_str=Narration
              SELE 3

      @ 5,1 to 22,78
               copy to safe
              go top
              mdat=c->jdate
              @ 3,55 say jdate
              begin sequence
              keyb chr(32)
              dbedit(5,2,21,77,aer1,"lap",pict1,head1)
                if lastkey()=-1
                   dbdel()
                   dbsave()

               endif
              End
         enddo
End
close all
set key 27 to
set key 28 to
return

Function dbdel
  re=select()
  sele 6
   use safe
   GO TOP
   HIFI=MONTH(JDATE)
   MHIFI=MONTH(DATE())
   HIFI=IIF(HIFI>=4 ,HIFI-3,HIFI+9)
   MHIFI=IIF(MHIFI>=4 ,MHIFI-3,MHIFI+9)
    DO WHILE   !EOF()
        SELE 5
          SEEK F->JCODE
             FOR  I=HIFI TO MHIFI
                rap='month'+iif(i<=9,'0'+str(i,1),str(i,2))
                   REPLACE &RAP WITH &RAP+If(F->jcat=="CR",(f->amount),-(f->amount))
                 NEXT I
          SELE 6
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
              do while jrno=jid .and. !eof()
                REPLACE amount with 0.00
                delete
                skip
              enddo
              set order to 1
              sele 7
                delete
          select (re)

         retu 0


