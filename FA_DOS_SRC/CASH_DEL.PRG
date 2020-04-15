* Programme to change Bank_entries
*---------------------------------------
*------------------------------------------
* begin doc
* procedure for journal entries
* no parameter
* generic??!
* programmer praseed pai
* end doc
*-----------------------------------------------
  Param _why
    private aer[5]
    aer[1]="jdesc"
    aer[2]="jcat"
    aer[3]="amount"
      set deleted on
*-----------------------------------
private head[5]
head[1]=" ACCOUNT "
head[2]=" DR / CR "
head[3]=" AMOUNT  "
*-------------------------------------
private pict[4]
pict[1]="@!"
pict[2]="!!"
pict[3]="99999999999999.99"
Pict[4]="@!"

*-------------------------------------
public jui,mdat,sDR,mdoc,fir,foo,Ban_code
Ban_code=Space(5)
Sdr='35001'
mdoc=IIf(_why=="P","CP","CR")
Val_m=iif(_why=="P","DR","CR")
*------------------------------------------------------------
set key 27 to esc_proc
*------------------------- to be removed later
sele 1
use data\journal index data\journal,data\journal1
sele 2
  use data\ledger index  data\ledger1 ,data\ledger2,data\ledger3
*----------------------------------------------------------------
sele 3
  use data\tempor
  zap
sele 4
  use data\sgroup index data\sgroup
sele 5
  use data\bal_ledg index data\bal_ledg
Sele 6
 Use data\narr index data\narr
Sele 7
 Use data\bank_s
*----------------------------------------
* -----------------------start of loop to edit
 Public Narr_str
 Narr_str=space(75)
public whater
Whater="V"
scroll(0,0,24,79,0)
      set colo to /W
      @ 1,5 say space(65)
      If _why=="R"
        @ 1,5 say "              C A S H  R E C I E P T S    (delete)    "
      else
        @ 1,5 say "              C A S H  P A Y M E N T S    (delete)     "
     endif





     @ 24,0  SAY SPACE(79)
     @ 24,0 SAY CENTER(" F4-narration F1-CodeList  F2-save & Next  Esc-cancel Del-Delete  ")

      set colo to
      @ 2,5 to 5,70
      @ 3,10 say "JOURNAL NO "
      @ 3,45 say " DATE "
      @ 4,10 say " CASH A/C  "

       mdat=date()
    *-------------------------------------
  jui=0
Set Key -3 TO Edit_narr
    begin sequence
      do  while .t.
          @ 3,25 get jui  pict "99999999"
          read
           sele 1
             if jui<=0
                  err_msg(" negative ?? ")
                  loop
             endif
          seek jui
           if !found()
               err_msg(" No such Transaction  ")
               loop
           endif
             if J_doc <>Mdoc
                Err_msg(" Invalid Transaction ")
                loop
             endif
                sele 3
              zap

             sele 1
              Mdat=Jdate
              DO WHILE A->J_ID=Jui .AND. !EOF()
                SELE 3
               APPEN BLANK
                SELE 1
                 REPLACE c->J_ID WITH J_ID ,c->J_DOC WITH J_DOC
                 REPLACE c->JDATE WITH JDATE,c->JCODE WITH JCODE
                 REPLACE c->JDESC WITH JDESC,c->JCAT WITH JCAT
                 REPLACE c->AMOUNT WITH AMOUNT,c->chqdt with chqdt,;
                 c->chqno with chqno

                SKIP

              ENDDO
               Sele 6
               Seek Jui
               Narr_str=Narration



       @ 3,50 say mdat

       @6,1 to 22,78
           sele 3
          begin sequence
        dbedit(7,2,21,77,aer,"zoomy",pict,head)
           if lastkey()=-1
              Showbox()
                db_del1()
              Hidebox()
           endif
        end

        set cursor on
     enddo
    end
Set key 27 to
Set key 28 to
set Key -3 to
close all
return

Function Zoomy
Param sd,nf
ire=lastkey()
retu if(ire=-1,0,1)


Function db_del1
re=select()
sele 3
  GO TOP
  HIFI=MONTH(C->JDATE)
  MHIFI=MONTH(DATE())
  HIFI=IIF(HIFI>=4 ,HIFI-3,HIFI+9)
  MHIFI=IIF(MHIFI>=4 ,MHIFI-3,MHIFI+9)
   DO WHILE   !EOF()
       SELE 5
             if c->jcat=="CR"
                  Seek C->jcode
             Else
                  Seek '35001'
             Endif
               FOR  I=HIFI TO MHIFI
                    rap='month'+iif(i<=9,'0'+str(i,1),str(i,2))
                    REPLACE &RAP WITH &RAP+(C->amount)

              NEXT I
              if C->jcat=="CR"
                   Seek '35001'
              Else
                   Seek C->jcode
              Endif

               FOR  I=HIFI TO MHIFI
                 rap='month'+iif(i<=9,'0'+str(i,1),str(i,2))
                 REPLACE &RAP WITH &RAP-(C->amount)
              NEXT I
          SELE 3
            SKIP
 enddo
       SELE 1
           SEEK jui
            if found()
               do while jui=j_id  .and. !eof()
                  REPLACE JCODE WITH '00000',jcat with "  ",AMOUNT WITH 0
                  DELETE
                  skip
              enddo
                endif
                SELE 2
                 set order to 3
              SEEK jui
              do while jui==jid .and. !eof()
                REPLACE amount with 0.00
                delete
                skip
              enddo
              set order to 1
              sele 6
              delete
              select (re)
         retu 0















