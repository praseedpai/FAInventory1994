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
*-------------------------------------
public whater
whater="E"
public jui,mdat,sDR,mdoc,fir,foo,Ban_code,val_m
Ban_code=Space(5)
mdoc=IIf(_why=="P","CP","CR")
val_m=iif(_why=="P","DR","CR")
sdr='35001'
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
  use data\sgroup index data\sgroup,data\sgr1
sele 5
  use data\bal_ledg index data\bal_ledg
Sele 6
  Use data\narr index data\narr
Sele 7
  Use data\bank_s
sele 8
  Use data\narr index data\narr
*----------------------------------------
* -----------------------start of loop to edit
 Public Narr_str

 scroll(0,0,24,79,0)
  set colo to /W
    @ 1,5 say space(65)
     If _why=="R"
        @ 1,5 say "              C A S H  R E C I E P T S    (change)    "
      else
        @ 1,5 say "              C A S H  P A Y M E N T S    (change)     "
     endif



     @ 24,0  SAY SPACE(79)
     @ 24,0 SAY CENTER(" F4-narration F1-CodeList  F2-save & Next  Esc-cancel Del-Delete  ")
   set colo to
     @ 2,5 to 5,70
     @ 3,10 say "JOURNAL NO "
     @ 3,45 say " DATE "
     @ 4,10 say " cASH A/C   "

       mdat=date()
    *-------------------------------------
  jui=0
Set Key -3 TO Edit_narr
    begin sequence
      do  while .t.
           Narr_str=space(75)
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
              sele 3
               copy to safe
               Sele 6
               Seek Jui
               Narr_str=Narration
       @ 3,50 say mdat
       @6,1 to 22,78
           sele 3
          begin sequence
          keyb chr(32)
        dbedit(7,2,21,77,aer,"rootf",pict,head)
           if lastkey()=-1
                 Showbox()
               d_bdel()
               d_bsave()
                 Hidebox()
              jui=jui+1
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

function d_bsave
 sdr='35001'
  hifi=month(mdat)
  mhifi=month(date())
  hifi=iif(hifi>=4 ,hifi-3,hifi+9)
  mhifi=iif(mhifi>=4 ,mhifi-3,mhifi+9)
  go top
   do while !eof()
      sele a
      appen blank
      sele c
      replace a->j_id with jui,a->jdate with mdat,a->j_doc wiTH  J_DOC
      replace a->jcode with jcode,a->jdesc with jdesc
      replace a->jcat with jcat,a->amount with amount,a->chqdt with chqdt,;
      a->chqno with chqno


*--------------------------posting to ledger
*-----------------------------
     sele 2
          appen blank
   if (c->jcat="CR")
        replace ac_1 with sDR,jdate with mdat
        replace jid with jui,ac_2 with c->jcode,amount with c->amount,jchqno ;
        with c->chqno,jchqdat with c->chqdt
   else
        replace ac_1 with c->jcode,jdate with mdat
        replace jid with jui,ac_2 with sDR
        replace amount with c->amount ,jchqno ;
        with c->chqno,jchqdat with c->chqdt
   endif
sele E
   if (c->jcat="CR")
          seek sDR
       else
          seek c->jcode
  endif
   for  i=hifi to mhifi
        rap='month'+iif(i<=9,'0'+str(i,1),str(i,2))
         replace &rap with &rap+(c->amount)
   next i

 if ((c->jcat="CR"))
      seek c->jcode
          else
      seek sDR
 endif
   for  i=hifi to mhifi
         rap='month'+iif(i<=9,'0'+str(i,1),str(i,2))
         replace &rap with &rap-(c->amount)
   next i
     sele c
     skip
enddo
Sele 6
append blank
Repl jour_no with Jui,Narration with Narr_str
retu  0
*-----------------------------------------


Function d_bdel
re=select()
sele 10
use safe
  GO TOP
  HIFI=MONTH(J->JDATE)
  MHIFI=MONTH(DATE())
  HIFI=IIF(HIFI>=4 ,HIFI-3,HIFI+9)
  MHIFI=IIF(MHIFI>=4 ,mHIFI-3,MHIFI+9)
   DO WHILE   !EOF()
       SELE 5
             if j->jcat=="CR"
                Seek j->jcode
                Else
                Seek '35001'
            Endif
               FOR  I=HIFI TO MHIFI
                    rap='month'+iif(i<=9,'0'+str(i,1),str(i,2))
                    REPLACE &RAP WITH &RAP+(j->amount)

              NEXT I
              if j->jcat=="CR"
                   Seek '35001'
              Else
                   Seek J->jcode
              Endif

               FOR  I=HIFI TO MHIFI
                 rap='month'+iif(i<=9,'0'+str(i,1),str(i,2))
                 REPLACE &RAP WITH &RAP-(j->amount)
              NEXT I
          SELE 10
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
              do while jui=jid .and. !eof()
                REPLACE amount with 0.00
                delete
                skip
              enddo
              set order to 1
              sele 6
              seek jui
              delete
              select (re)
         retu 0
















