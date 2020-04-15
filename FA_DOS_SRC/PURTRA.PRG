* program to add data to stock to file
* Raw materials and end product
* products



param md
set score off
set deleted on
set century on 
  set date brit
    Do case
   case md="1"
     sele 1
       Use stock\rstock index stock\RstocK
     Sele 2
       Use stock\rsub index stock\Rsub
     Sele 3
       Use stock\rstocktr index stock\rstocktr,stock\rst1
 other
     Sele 1
       Use stock\Cstock index stock\Cstock
     Sele 2
       Use stock\Csub Index stock\Csub
     Sele 3
       Use stock\cstocktr index stock\cstocktr,stock\cst1
 Endcase
*-------------------------aRRAY FOR DBEDIT

scroll(0,0,24,79,0)
setcolor("/w")
@ 0,5 say Center("STOCK TRANSACTIONS (RECIEPTS/ISSUE)--"+IF(MD=="1","           raw materials","              containers"))
setcolor("w/n")
@ 1,5 to 3,70 double
todate=Date()
set key 27 to Esc_proc
begin sequence
DO WHILE .T.
Sele 4
Use stock\dbtem
zap

@ 2,6 Say "Enter date :-" Get todate
READ
IF TODATE==CTOD("") .OR. TODATE>DATE()
 eRR_MSG("INVALID DATE")
 LOOP
ENDIF
DFGM=MONTH(todate)
MY=IF(DFGM<=3,YEAR(todate)-1,YEAR(todate))
STDAT=CTOD("01/04/"+STR(MY%100,2))
public mtno
MTNO=todate-STDAT+1

 SELE 5
 USE TEMP_01
 ZAP
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
       REPLACE d->RDESC WITH DESC
       REPLACE E->RDESC WITH DESC
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
END IF
CLOSE
sele 4
IF RECCOUNT()==0
APPEND BLANK

ENDIF

go top

 begin sequence
  @4,5 to 21,70 double
keyb chr(32)
 DBEDIT(5,6,20,69,"","fool")

    if lastkey()==-1
       dbase()
    endif
end
clear gets
enddo
end
close all
set key 27 to
set key 28 to




function fool
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
                       set key 28 to mun_12
                           set cursor on
                          @ row(),col()  get &ed_field  Pict "@!" valid goor_code(&ed_field)
                       read
                        set cursor off
                        set key 28 to
                        Replace Rdesc with B->desc
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
                      KEYB CHR(24)+CHR(19)+CHR(19)+CHR(19)+CHR(19)

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






















    proc mun_12
    private fil[2],samp[2]
    set key 27 to
    fil[1]="code"
    fil[2]="desc"
    samp[1]=" code  "
    samp[2]="  description  "
    xf=savescreen(4,9,23,61)
    foo=""
    set key 28 to
    mas=select()
    sele 2
    msav=setcolor("/w+,w+/n")
        @ 4,9 to 21,61 double
         dbedit(5,10,20,60,fil,"mucr","",samp)
            setcolor(msav)
            select(mas)
        set key 27 to ESc_proc
        set key 28 to mun_12
          restscreen(4,9,23,61,xf)
          release xf

   *-----------------------------------------
   *----------------------function func_r
function mucr
param dfg,klm
   kes=lastkey()
  do case
    case kes=13
       keyb B->Code
       Replace D->rdesc with B->desc
       return 0
  case kes=27
      return 0
  case kes>=32 .and. kes<=128
       foo=foo+upper(chr(kes))
  case kes==8
       foo=Left(foo,len(foo)-1)
   otherwise
      retu 1
   endcase

      @ 22,9 say space(52)
      @ 22,9 say foo
       df=recno()
    locate for upper( Left( code, len(foo) ) )=foo
      if !found()
         goto df
      endif
    return 1


* function to save data to the file
*
Function Dbase
  Rde=Select()
   Sele 3
      seek mtno
      do while tno==mtno
         delete
         skip
       enddo
* next psuedo function is to give back data 
        Sele 5
          Use temp_01
            Do while !eof()
              sele  1
               seek E->rcode
                 replace rqty with  Rqty+ iif(E->rind=="R",-(E->rqty),E->rqty)
               sele 5
                 skip
             enddo
           sele 4
            go top
         do while !eof()
            sele 3
          append blank
             **
            replace tcode with D->rcode
            **
            REPLACE tqty with d->rqty
            REPLACE tind with d->rind
            REPLACE tno with mtno
            replace treason with d->reason
        sele 1
          seek D->rcode
           replace rqty with rqty+iif(D->rind=="R",D->rqty,-(D->rqty))

         sele 4
           skip
       enddo
       retu 0


function goor_code
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
 return ret_val
