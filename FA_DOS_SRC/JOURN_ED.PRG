** begin doc
* procedure for journal entries
* no parameter
* generic??!
* programmer praseed pai
* end doc
*-----------------------------------------------
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
 pict[3]="9999999999999.99"
*-------------------------------------
 public JRNO,mdat,sDR,mdoc,fir,foo,WHATER
 WHATER="E"
 mdoc="JV"
*------------------------------------------------------------
set key 27 to esc_proc
*------------------------- to be removed later
sele 1
use data\journal index data\journal,data\journal1
go bott
JRNO=j_id+1
sele 2
  use data\ledger index  data\ledger1 ,data\ledger2,data\ledger3,data\ledger4,data\ledger5
*----------------------------------------------------------------
sele 3
  use data\tempor
sele 4
  use data\sgroup index data\sgroup,data\sgr1
sele 5
  use data\bal_ledg index data\bal_ledg
Sele 7
 Use data\narr index data\narr


*----------------------------------------
* -----------------------start of loop to edit
  Public Narr_str
  Narr_str=space(75)
   scroll(0,0,24,79,0)
   set colo to /W
   @ 1,5 say space(65)
   @ 1,5  say   "               J O U R N A L  V O U C H E R   (add) "
   SET COLO TO /W
   @ 24,0  SAY SPACE(79)
   @ 24,0 SAY CENTER(" F4-narration F1-CodeList  F2-save & Next  Esc-cancel Del-Delete  ")
   set colo to
   @ 2,5 to 4,70
   @ 3,10 say "JOURNAL NO "
   @ 3,45 say " DATE "
   mdat=date()
    *-------------------------------------
   Set Key -3 TO Edit_narr
      begin sequence
      do  while .t.
          NARR_STR=SPACE(75)          
  @ 3,25 get JRNO  pict "99999999"
            read
             sele 1
                if JRNO<=0
                   err_msg(" negative ?? ")
                   loop
                endif
            seek JRNO
              if found()
                  err_msg("  duplicate  Voucher")
                  loop
             endif
               @ 3,50 get mdat
               read
                    @5,1 to 22,78
              begin sequence
                  sele 3
                    zap

                    appen blank
                 keyb chr(32)
                     dbedit(6,2,21,77,aer,"lap",pict,head)
              if lastkey()=-1
                  showbox()
                  dbsave()
                  hidebox()
                  JRNO=JRNO+1
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
****************************  Eof Main
*----------------------------------------------
