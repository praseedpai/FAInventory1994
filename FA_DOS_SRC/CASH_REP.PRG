* begin doc
* procedure for journal entries
* no parameter
* generic??!
* programmer praseed pai
* end doc
*-----------------------------------------------
Param _water
private aer[4]
aer[1]="jdesc"
aer[2]="jcat"
aer[3]="amount"
aer[4]="narr"
*-----------------------------------
private head[4]
head[1]="description"
head[2]="DR/cr  "
head[3]="amount "
head[4]=" narration"
*-------------------------------------
private pict[4]
pict[1]="@!"
pict[2]="!!"
pict[3]="99999999999999.99"
pict[4]="@!"
*-------------------------------------
public jui,mdat,sDR,mdoc,fir,foo
mdoc=iif(_water=="R","CR","CP")
*------------------------------------------------------------
set key 27 to esc_proc
*------------------------- to be removed later
sele 1
use data\journal index data\journal
go bott
jui=j_id+1
sele 2
  use data\ledger index  data\ledger1 ,data\ledger2,data\ledger3
*----------------------------------------------------------------
sele 3
  use data\tempor
sele 4
  use data\sgroup index data\sgroup
sele 5
  use data\bal_ledg index data\bal_ledg
*----------------------------------------
* -----------------------start of loop to edit
      scroll(0,0,24,79,0)
      set colo to /g+
      @ 1,12 say " S I M I L I A  H O M O E O  L A B O R A T O R I E S "
      @ 24,21 say " J O U R N A L  V O U C H E R S  "
       set colo to
       @ 2,5 to 4,70
      @ 3,10 say "JOURNAL NO "
             @ 3,45 say " DATE "
       mdat=date()
      public all_ow
      all_ow=iif(_water=="R","CR","DR")
    *-------------------------------------
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
          if found()
             err_msg(" warning duplicate ")
             loop
          endif

       @ 3,50 get mdat
       read

       @5,5 to 22,70
          begin sequence
        do while  .t.
           sele 3
           zap
           appen blank
        dbedit(6,6,21,69,aer,"lap",pict,head)
           if lastkey()=-1
              dbsave()
              jui=jui+1
              exit
           endif
         enddo
        end
        keyb chr(32)
        set cursor on
     enddo
    end
close all
return

* function lap
* aim is to edit journal
* fourside trasversal
function lap
parameter s,i
*-----------------------------------------------
* bof?? or eof??
       ker=lastkey()
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
  if ker=27
     return 0
   endif
    * case enter or alphanumeric
     do case
       case  isalpha(chr(ker)) .or. isdigit(chr(ker)) .or. ker=13  .or. ker=28
          *------------------- do case field =1
                           if ker <>13
                             keyboard chr(ker)
                            endif

                              if  i=1

                              set key 28 to mode_h
                               if ker <>28
                            keyboard chr(28)
                            endif
                        wait ""
                        set key 28 to
          *----------------case field =2
                     elseif i=2
                        set cursor on
                        @ row(),col() get &ed_field pict "!!" valid &ed_field=all_ow
                        read
                       set cursor off
                       keyboard chr(4)
                     elseif  i=3
                        set cursor on
                        @row(),col() get &ed_field pict "99999999999999.99" valid &ed_field>0
                       read
                       set cursor off
                       keyboard chr(4)
                     else
                     set cursor on
                      @ row(),col() get &ed_field pict "@!"
                      read
                      set cursor off
                    endif

 *----------------------------------- case key is del
        case ker=7
        sele 3
        if reccount()>0
          delete
         pack

        if reccount()=1
           appen blank
        endif
      endif
      keyboard chr(0)
         return 2
*----------------------------------------- case key is f2
        case ker=-1
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
     retu 0
endcase
return 1
*---------------------------------------------
*----------------------------------------------

   *function mode_h
    proc mode_h
    private fil[2],samp[2]
     fil[1]="s_code"
     fil[2]="s_desc"
     samp[1]=" code  "
     samp[2]="  description  "
      xf=savescreen(4,9,23,61)
      foo=""
       set key 28 to
         sele 4
          set colo to /w+,w+/n
          @ 4,9 to 21,61 double
           dbedit(5,10,20,60,fil,"muncr","",samp)
            set colo to w+/n,n/w+
        set key 28 to mode_h
          sele 3
          restscreen(4,9,23,61,xf)
          release xf

   *-----------------------------------------
   *----------------------function func_r
function muncr
param dfg,klm
   kes=lastkey()
  do case

  case kes=13
    sele 3
     replace j_id with jui,j_doc with mdoc,jdate with mdat,jcode with d->s_code,jdesc with d->s_desc
     keyb chr(4)+chr(4)
       return 0
  case kes=27
      keyb chr(4)
      return 0
  case isalpha(upper(chr(kes)))
       foo=foo+chr(kes)
  case kes==8
       foo=substr(foo,1,len(foo)-1)
   otherwise
      retu 1
   endcase

      @ 22,9 say space(52)
      @ 22,9 say foo
       df=recno()
    locate for upper( substr( s_desc, 1 , len(foo) ) )=upper(foo)
      if !found()
         goto df
      endif
    return 1
*--------------------------------------------------
*---------------function to save the data to the file
function dbsave
  hifi=month(mdat)
  mhifi=month(date())
  hifi=iif(hifi>=4 .and. hifi<=12,hifi-3,hifi+9)
  mhifi=iif(mhifi>=4 .and. mhifi<=12,mhifi-3,mhifi+9)
  go top
   do while !eof()
      sele a
      appen blank
      sele c
      replace a->j_id with jui,a->jdate with mdat,a->j_doc wiTH  J_DOC
      replace a->jcode with jcode,a->jdesc with jdesc
      replace a->jcat with jcat,a->amount with amount
      replace a->narr with narr

*--------------------------posting to ledger
*-----------------------------
          sele 2
           appen blank
              IF !_Water$"Rr"
                REPLACE AC_1 WITH C->JCODE
                REPLACE AC_2 WITH '35001'
              ELSE
                replace AC_1 with '35001'
                REPLACE AC_2 WITH C->JCODE
              endif
              REPLACE jdate with mdat
               replace jID with jui,amount with c->amount
               sele e
                SEEK B->AC_1
                  FOR  I=HIFI TO MHIFI
                       RAP='MONTH'+iif(i<=9,'0'+STR(I,1),str(i,2))
                        REPLACE &RAP WITH &RAP+(B->amount)
                   NEXT I
                  SEEK B->AC_2
                  FOR  I=HIFI TO MHIFI

                          RAP='MONTH'+iif(i<=9,'0'+STR(I,1),str(i,2))
                        REPLACE &RAP WITH &RAP-(B->amount)
                   NEXT I
                   SELE C
                    SKIP
                  enddo
                  retu ""