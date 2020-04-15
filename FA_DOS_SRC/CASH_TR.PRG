* begin doc
* procedure for journal entries
* no parameter
* generic??!
* programmer praseed pai
* end doc
*-----------------------------------------------
Param _why
private aer[3]
aer[1]="jdesc"
aer[2]="jcat"
aer[3]="amount"
*-----------------------------------
private head[3]
head[1]=" ACCOUNT "
head[2]=" DR / CR "
head[3]=" AMOUNT  "
*-------------------------------------
private pict[3]
pict[1]="@!"
pict[2]="!!"
pict[3]="99999999999999.99"
*-------------------------------------
public jui,mdat,sDR,mdoc,fir,foo,Ban_code,val_m
Ban_code=Space(5)
mdoc=IIf(_why=="P","CP","CR")
Val_m=iif(_why=="P","DR","CR")
*------------------------------------------------------------
set key 27 to esc_proc
*------------------------- to be removed later
sele 1
use data\journal index data\journal,data\journal1
go bott
jui=j_id+1
sele 2
use data\ledger index  data\ledger1 ,data\ledger2,data\ledger3
*----------------------------------------------------------------
sele 3
 use data\tempor
sele 4
 use data\sgroup index data\sgroup,data\sgr1
sele 5
  use data\bal_ledg index data\bal_ledg
Sele 6
 Use data\narr index data\narr
Sele 7
 Use data\bank_s

 Public Narr_str,whater
 whater="E"
 sdr='35001'
 scroll(0,0,24,79,0)
     set colo to /w
        @ 1,5 say space(65)
       If _why=="R"
          @ 1,5 say "              C A S H  R E C I E P T S    (add)    "
      else
        @ 1,5 say "              C A S H  P A Y M E N T S    (add)     "
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
           if found()
               err_msg(" warning duplicate ")
               loop
           endif

       @ 3,50 get mdat
       read
       @6,1 to 22,78
          begin sequence
           sele 3
           zap
           appen blank
            keyb chr(32)
        dbedit(7,2,21,77,aer,"rootf",pict,head)
           if lastkey()=-1
               Showbox()
              save_db()
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

function save_db
Sdr='35001'
 hifi=month(mdat)
 mhifi=month(date())
 hifi=iif(hifi>=4 ,hifi-3,hifi+9)
 mhifi=iif(mhifi>=4 ,mhifi-3,mhifi+9)
   Sele 3
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
Commit
Sele a
Commit
Sele b
Commit

retu  0
*-----------------------------------------















