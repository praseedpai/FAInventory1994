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
    aer[4]="Chqno"
    Aer[5]="Chqdt"
      set deleted on
*-----------------------------------
private head[5]
head[1]=" ACCOUNT "
head[2]=" DR / CR "
head[3]=" AMOUNT  "
Head[4]=" Cheque no."
head[5]=" Cheque Date"
*-------------------------------------
private pict[4]
pict[1]="@!"
pict[2]="!!"
pict[3]="99999999999999.99"
Pict[4]="@!"

*-------------------------------------
public jui,mdat,sDR,mdoc,fir,foo,Ban_code,val_m
Ban_code=Space(5)
mdoc=IIf(_why=="P","BP","BR")
Val_m=iif(_why=="P","CR","DR")
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
scroll(0,0,24,79,0)
    Set colo to /w
      @ 1,5 say space(65)
       If _why=="R"
            @ 1,5 say "              B A N K  R E C I E P T S    (change)    "
          else
            @ 1,5 say "              B A N K  P A Y M E N T S    (change)     "
         endif
     @ 24,0  SAY SPACE(79)
     @ 24,0 SAY CENTER(" F4-narration F1-CodeList  F2-save & Next  Esc-cancel Del-Delete  ")

      set colo to
      @ 2,5 to 5,70
      @ 3,10 say "JOURNAL NO "
      @ 3,45 say " DATE "
      @ 4,10 say "Bank       "

       mdat=date()
    *-------------------------------------
  jui=0
Set Key -3 TO Edit_narr1
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
       sele 2
       set order to 3
       seek Jui
     If _why=="R"
          ban_code=Ac_2
     else
          ban_code=ac_1
     endif
     SET ORDER TO 1     
 sele 7
      locate for b_code==Ban_code

       @ 4,25 Say  G->b_code
       @ 4,46 say  LEFT(G->b_desc,25)
       @6,1 to 22,78
           sele 3
          begin sequence
             keyb chr(32)
        dbedit(7,2,21,77,aer,"laps",pict,head)
           if lastkey()=-1
                  Showbox()
                      db_delete()
                      dbsaver()
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

* function laps
* aim is to edit journal
* fourside trasversal
function laps
parameter s,i
*-----------------------------------------------
* bof?? or eof??
       ker=lastkey()

 if ker=27
    keyb chr(13)
    return 0
   endif
    ed_field=field(i+4)
   if s=1
      err_msg("   no more   ")
      return 1
   endif

  if ker=24
    if s=2 .and. jdesc <> space(25) .and. amount > 0 .and. (jcat="CR" .or. jcat="DR")
       appen blank
     endif
  endif
* case lastkey is escape

    * case enter or alphanumeric
     do case
       case  isalpha(chr(ker)) .or. isdigit(chr(ker)) .or. ker=13  .or. ker=28
          *------------------- do case field =1
                SET KEY 27 TO
                      if ker <>13
                             keyboard chr(ker)
                            endif

                              if  i=1

                              set key 28 to mode_hl
                               if ker <>28
                            keyboard chr(28)
                            endif
                        wait ""
                        set key 28 to
          *----------------case field =2
                     elseif i=2 
                           KEYB VAL_M
                        set cursor on
                        @ row(),col() get &ed_field pict "!!" valid &ed_field=Val_m
                        read
                       set cursor off
                       keyboard chr(4)
                     elseif  i=3
                        set cursor on
                        @row(),col() get &ed_field pict "99999999999999.99" valid &ed_field>0
                       read
                       set cursor off
                    Elseif i==4
                       set cursor on
                       @row(),col() get &ed_field pict "@!"
                       read
                       set cursor off
                    Elseif i==5
                       set cursor on
                       @row(),col() get &ed_field
                       read
                       set cursor off

                    endif
               SET KEY 27 TO Esc_proc
 *----------------------------------- case key is del
     case ker=7
       sele 3

         delete
         pack

        if reccount()=0
           appen blank
        endif

      keyboard chr(0)
         return 2
*----------------------------------------- case key is f2
        case ker=-1
           sDR=Ban_code
         go top
          do while !eof()
           if  jdesc <> space(25) .and. amount > 0 .and. (jcat="CR" .or. jcat="DR")
                skip
                loop
             else
                err_msg("missing entry")
                return 1
             endif
           enddo
           REturn 0
endcase
return 1
*---------------------------------------------
*----------------------------------------------

   *function mode_hl
    proc mode_hl
    private fil[2],samp[2]
     sET KEY 27 TO
     fil[1]="s_code"
     fil[2]="s_desc"
     samp[1]=" code  "
     samp[2]="  description  "
      xf=savescreen(4,9,23,61)
      foo=""
       set key 28 to
         sele 4
         msav=setcolor("W+/w+,n/W+")
          @ 4,9 to 21,61 double
           dbedit(5,10,20,60,fil,"munfed","",samp)
            setcolor(msav)
        set key 28 to mode_hl
          sele 3
          SET KEY 27 TO Esc_proc
          restscreen(4,9,23,61,xf)
          release xf

   *-----------------------------------------
   *----------------------function func_r
function munfed
param dfg,klm
   kes=lastkey()
  do case

  case kes=13
    sele 3
     replace j_id with jui,j_doc with Mdoc,jdate with mdat,jcode with d->s_code,jdesc with d->s_desc
     keyb chr(4)+chr(4)
       return 0
  case kes=27
    keyb chr(32)
      return 0
  case kes>=32
       foo=foo+upper(chr(kes))
  case kes==8
       foo=substr(foo,1,len(foo)-1)
   otherwise
      retu 1
   endcase

      @ 22,9 say space(52)
      @ 22,9 say foo
          set softseek on
               seek foo
          set softseek off
         keyb chr(0)
         return 2 
*--------------------------------------------------
*---------------function to save the data to the file
function dbsaver
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
commit

Sele 1
  Commit
Sele 2
  Commit
retu  0
*-----------------------------------------
Procedure Edit_narr1
rv=savescreen(14,4,16,79)
sET KEY 27 TO
sET CURSOR ON
@ 14,4 to 16,79 double

@ 15,5 get narr_str  pict "@S70!"
read
Set cursor off
rESTSCREEN(14,4,16,79,RV)
SET KEY 27 TO eSC_PROC
keyb chr(32)
Retu


*--------------------------------------------------


Function db_delete
 re=select()
  sele 10
   use safe
   GO TOP
  HIFI=MONTH(J->JDATE)
  MHIFI=MONTH(DATE())
  HIFI=IIF(HIFI>=4 ,HIFI-3,HIFI+9)
  MHIFI=IIF(MHIFI>=4 ,MHIFI-3,MHIFI+9)
   DO WHILE   !EOF()
       SELE 5
             
             if j->jcat=="CR"
                Seek j->jcode
                Else
                Seek SDr    && Ban_code
            Endif
               FOR  I=HIFI TO MHIFI
                    rap='month'+iif(i<=9,'0'+str(i,1),str(i,2))
                    REPLACE &RAP WITH &RAP+(j->amount)

              NEXT I
             
              if j->jcat=="CR"
                   Seek  Sdr && Ban_code
              Else
                   Seek J->jcode
              Endif

               FOR  I=HIFI TO MHIFI
                 rap='month'+iif(i<=9,'0'+str(i,1),str(i,2))
                 REPLACE &RAP WITH &RAP-(j->amount)
              NEXT I
          SELE j
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