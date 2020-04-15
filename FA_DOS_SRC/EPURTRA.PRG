Set century on 
Sele 1
      Use stock\stock index stock\stocK
Sele 2
      Use stock\E_subhea index stock\E_subhea,stock\e_sub1,stock\E_sub2,stock\e_sub3
Sele 3
       Use stock\estocktr index stock\estocktr,stock\est1


scroll(0,0,24,79,0)
setcolor("/w")
@ 0,5 say Center("STOCK TRANSACTIONS (RECIEPTS/ISSUE)--"+"            end products")
setcolor("w/n")
@ 1,5 to 3,70 double

todate=Date()
set key 27 to Esc_proc
begin sequence
DO WHILE .T.



@ 2,6 Say "ENTER DATE :-" gET TODATE
READ
IF TODATE==CTOD("") .OR. TODATE>DATE()
 eRR_MSG("INVALID DATE")
 LOOP
ENDIF
Sele 1
      Use stock\stock index stock\stocK
Sele 2
      Use stock\E_subhea index stock\E_subhea,stock\e_sub1,stock\E_sub2,stock\e_sub3
Sele 3
       Use stock\estocktr index stock\estocktr,stock\est1

Sele 4
Use stock\dbtem1
zap

SELE 5
USE TEMP_02
ZAP
 
 MY=IF(month(todate)<=3,YEAR(todate)-1,YEAR(todate))
 STDAT=CTOD("01/04/"+STR(MY%100,2))
 public mtno
 MTNO=todate-STDAT+1
 SELE 3
 SEEK MTNO
   DO WHILE TNO==MTNO
      SELE 4
        APPEND BLANK
        REPLACE RCODE WITH c->TCODE
      SELE 5
        APPEND BLANK
        REPLACE RCODE WITH C->TCODE

       SELE 2
        SEEK  C->TCODE
        REPLACE d->RDESC WITH s_DESC
        REPLACE E->RDESC WITH S_DESC
       SELE 3
         REPLACE D->RQTY WITH tQTY
         Replace d->rind with tind
         replace d->reason with treason
         REPLACE e->RQTY WITH tQTY
         Replace E->rind with tind
         replace E->reason with treason

        SKIP
    ENDDO

SELECT 5

IF RECCOUNT()==0
APPEND BLANK
ENDIF

CLOSE 
sele 4
USE STOCK\DBTEM1
go top
IF RECCOUNT()==0
APPEND BLANK
ENDIF

go top

 begin sequence
@ 4,5 to 21,70 double
keyb chr(32)
 DBEDIT(5,6,20,69,"","fool23")

    if lastkey()==-1
       dbase1()
    endif
end
clear gets
enddo
end
close all
set key 27 to
set key 28 to




function fool23
 param s,i
    ker=lastkey()
       ed_field=field(i)
    if s=1
        err_msg("   NO MORE   ")
        return 1
    endif

  IF KER=24
   if s=2 .and. rcode <>space(5) .and. rqty > 0  .and. rind$"RI"
      append blank
   endif
  endif

     * CASE LASTKEY IS ESCAPE
 if ker==27
   return 0
 endif
   * case enter or alphanumeric
    Do case
      case  ISdigit(chr(ker)) .or. isalpha(chr(ker)) .or. ker==28 .OR. KER==13
         *------------------- do case field =1
                            if  ker<>13
                                keyb chr(ker)
                            endif
                      if i==1
                       set key 28 to mun_145
                           set cursor on
                          @ row(),col()  get &ed_field pict "@!"  valid goor(&ed_field)
                       read
                        set cursor off
                        set key 28 to
                         Replace Rdesc with B->s_desc
                       KEYB CHR( 4)+chr(4)

                     elseif i==2
                        set cursor on
                       @ row(),col()  get &ed_field
                       read
                       set cursor off
                       KEYB CHR( 4)
                     ELSEif i==2
                       set cursor on
                        @ row(),col() get &ed_field
                                              read
                       set cursor off
                       keyboard chr(4)
                    ELSEIF I==3
                      set cursor on
                        @ row(),col() get &ed_field valid &ed_field>0
                        read
                       set cursor off
                       keyboard chr(4)
                    ELSEIF I==4
                      set cursor on
                         @ row(),col() get &ed_field pict "!" valid &ed_field$"IR"
                                                    read
                       set cursor off
                   elseif i==5
                       set cursor on
                        @ row(),col() get &ed_field
                        read
                       set cursor off
                        KEYB CHR(24)+REPLI(CHR(19),4)

                   ENDIF
             set key 27 to Esc_proc
    case  ker=7
             as=recno()
            if reccount()>0
              if reccount()=1
                  delete
                  pack
                  appen blank
               else
                delete
                pack
              endif
           endif

             goto as
             keyb chr(0)
             retu 2


   Case ker=-1
      Go top
       Do while !eof()
          if rqty>0  .and. rind$"RI"
                       skip
           Else
             err_msg(" Error Found in CUrrent ENTRY ")
             Retu 1
          endif
      Enddo
        Retu 0
       ENDCASE
   RETU 1


    proc mun_145
    private fil[2],samp[2]
     Set key 27 to
     fil[1]="S_code"
     fil[2]="S_desc"
     samp[1]=" code  "
     samp[2]="  description  "
      xf=savescreen(4,9,23,61)
      foo=""
       set key 28 to
       mas=select()
         sele 2
        msav=setcolor("/w+,w+/n")
          @ 4,9 to 21,61 double
           dbedit(5,10,20,60,fil,"mucr1","",samp)
            setcolor(msav)
            select(mas)
        set key 27 to ESc_proc
        set key 28 to mun_145
          restscreen(4,9,23,61,xf)
          release xf

   *-----------------------------------------
   *----------------------function func_r
function mucr1
param dfg,klm
   kes=lastkey()
  do case
     case kes=13
       keyb B->s_Code
       Replace D->rdesc with B->s_desc
       return 0
  case kes=27
      return 0
  case kes>=32 
       foo=foo+upper(chr(kes))
  case kes==8
       foo=Left(foo,len(foo)-1)
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


* function to save data to the file
*

Function Dbase1
Rde=Select()
 sele 3
   seek mtno
 do while  tno=mtno
     delete
     skip
 enddo
* next psuedo function is to give back data
  Sele 5
  Use temp_02

    Do while !eof()
      sele  1
      seek E->rcode
          IF Found()
           replace it_qty with  it_qty+ iif(E->rind=="R",-(E->rqty),E->rqty)
          Endif
      sele 5
      skip
    enddo


   Sele 1
      Commit


  sele 4
    go top
     do while !eof()
        sele 3
          append blank
            replace tcode with D->rcode,tqty with d->rqty,tind with d->rind,tno with mtno
            replace treason with d->reason
        sele 1
          seek D->rcode

            IF Found()
           replace it_qty with it_qty+iif(D->rind=="R",D->rqty,-(D->rqty))
            endif
         sele 4
           skip
       enddo
         Sele 3
           Commit
         Sele 1
           Commit  
       retu 0


function goor
param _oop

rd=select()
 sele 2
 seek _oop
   if found()
   ret_val=.t.
    else
     err_msg(" No such code exists ")
   ret_val=.f.
 endif
select(rd)
 return ret_val
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
