*-----------FUNCTION ERROR MESSAGE TO DISPLAY ERROR MESSAGE
*-----------CALL WITH ONE PARAMETER
*--------------USAGE  err_msg( <message>)
function err_msg
param st
PRIVATE kq,kek,wid
kq=len(st)
wid= kq+6
mn=SEtcolor()
kek=savescreen(19,39-int(wid/2),21,39+int(wid/2))
setcolor("/w")
set cursor off
@ 19,39-int(wid/2)  clea to  21,39+int(wid/2)
@ 19,39-int(wid/2) to  21,39+int(wid/2) double
@ 20,39-int(kq/2) say st
tone(800,2)
tone(400,2)
ret_val=inkey(0)
SETCOLOr(mn)
restscreen(19,39-int(wid/2),21,39+int(wid/2),kek)
set cursor on
RETURN (ret_val)
* EOF err_msg
*--------------------------------------------------------------------
*PROCEDURE TO BE CALLED WHENEVER ESCAPE IS PRESSED
*RELYS HEAVILY ON BEGIN SEQUENCE..END STRUCTURE
*USE WITH CAUTION!
proc esc_proc
 private xd
 xd=savescreen(10,44,12,64)
 @ 10,44 to 12,64 double
rs=setcolor("n/w")
 @ 10,44 clea to 12,64
 set cursor off
 @ 11,45 say "   CANCEL /RESUME   "
     inkey(0)
 restscreen(10,44,12,64,xd)
   set cursor on
 if chr(lastkey())$"cC"
    setcolor("")
    keyb chr(32)
    break
 Endif
 keyb chr(32)
 setcolor(rs)
 retu
*---------------------
FUNCTION ISDIGIT
PARAM _N
RETURN (_N>='0' .AND. _N<='9')
*----------------------------------
* function to browse text file

FUNCTION BROW
param foo
Set key 27 to
public filnam
filnam=foo
SELE 0
use data\text
ZAP
KS=SAVESCREEN(0,0,24,78)
append from &foo sdf
go top
set colo to /w
@ 0,0 say space(79)
@ 0,0 say  Center( "  F5-print   F10-Exit     ")
set  colo to
@ 1,0 to 24,78 double

SET COLO TO G/W
@ 2,12 say " S I M I L I A  H O M O E O   L A B O R A T O R Y "
setcolor("w/n,n/W")

dbedit(3,1,23,77,"","RAPPY","","","_","","","")
USE
set color to
RESTSCREEN(0,0,24,78,KS)
RETU 0
*--------------------------------------------------
  FUNC RAPPY
  PARAM SN,FO
    if sn==1
        err_msg(" No more data ")
        set cursor off
        return 1
    endif
   kes=lastkey()
    Do case
      Case kes=-9
        Retu 0
      case kes=-4
        if !isprinter()
          ERR_msg(" Printer not Ready ")
         set cursor off
     Else
         Printfile( filnam)
       endif
      ENDCase
     retu 1

*---------------------------------
Function Ispchar
param _n
return (_n>=' ' .and. _n<=chr(127))
*-------------------------------------------------
* next function is used extensievely in
* edit_gro and Group file
* look with care
*---------------------------------------------------
function funcr
param dfg,klm
   kes=lastkey()
  do case
  case kes=27
   Retu 0
  case kes=13
      keyboard A_code
      return 0
  case kes>=32
       foo=foo+upper(chr(kes))
  case kes==8
       foo=substr(foo,1,len(foo)-1)
   otherwise
      retu 1
   endcase

      @ 22,35 say space(34)
      @ 22,35 say foo
      set softseek on
            seek foo
      set softseek off
          keyb chr(0)
       return 2
*--------------------------------------------------------------
* next function is common for edit_gro & sgr.prg

*----------------procedure for COdehelp
 PROC CODE_H
 private fil[2]
 set key 27 to
 fil[1]="A_code"
 fil[2]= "A_DESC"
 private samp[2]
 samp[1]=" CODE "
 samp[2]= "          DESCRIPTION         "
 xf=savescreen(4,25,23,71)
 set key 28 to
    rer=select()
    sele 1
   msav=setcolor("/w+,w+/n")
    @ 4,25 to 21,71 double
    go top
    public foo
    foo=""
    dbedit(5,26,20,70,fil,"Funcr","",samp)
     setcolor(msav)
     select(rer)
      set key 27 to Esc_proc
      set key 28 to code_h
      restscreen(4,25,23,71,xf)
      release xf
      retu
*----------------------------------------------------
*---------------------------------------------------
*--------------------------------------------------------
* Next function is the most important one
* which edits journal entries
* begin doc

function lap
parameter s,i
*-----------------------------------------------
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
                       Endif

                          if  i=1
                              set key 28 to modeS_h
                               if ker <>28
                                keyboard chr(28)
                            endif
                         wait ""                      
                        set key 28 to
          *----------------case field =2
                     elseif i=2
                        set cursor on
                        @ row(),col() get &ed_field pict "!!" valid &ed_field="CR" .or. &ed_field="DR"
                        read
                       set cursor off
                       keyboard chr(4)
            *------------------------------case field==3
                  elseif  i=3
                        set cursor on
                        @row(),col() get &ed_field pict "9999999999999.99" valid &ed_field>0
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
         count for jcat="CR" to asd
         count for jcat="DR" to asd1
      if !((asd=1 .and. asd1>=1) .or. (asd>=1 .and. asd1=1))
              err_msg("error")
              return 1
     endif
           if (asd=1 .and. asd1>=1)
               locate for jcat="CR"
               sDR=jcode
           else
              locate for jcat="DR"
              sDR=jcode
          endif
           go top

jc1=0.00
jc2=0.00   
do while !eof()
    if  jdesc <> space(25) .and. amount > 0 .and. (jcat="CR" .or. jcat="DR")
       If jcat="DR"
            jc1=jc1+amount
        elseif jcat="CR"
            jc2=jc2+amount
        endif  
       skip
       loop
     else
      err_msg("missing entry")
       return 1
    endif
       enddo
      jc1=round(jc1,2)
      jc2=round(jc2,2)
     if (jc1=jc2)
        return 0
      else
         err_msg("Dr total "+str(jc1,10,2)+" Cr total "+str(jc2,10,2)+iif(jc1=jc2,"T","F"))
         err_msg("total disparity")
         return 1
      endif

endcase
return 1
*---------------------------------------------
*----------------------------------------------
* fUNCTION TO EDIT_NARRATION
* ------------------------------------------
*-------------------------------already checked
pROCEDURE Edit_Narr
  IF wHATER=="E"
     rv=savescreen(14,4,16,79)
     sET KEY 27 TO
SET CURSOR ON
   @ 14,4 to 16,79 double
   @ 15,5 get narr_str  pict "@S70!"
  read
Set cursor off
rESTSCREEN(14,4,16,79,RV)
SET KEY 27 TO eSC_PROC
keyb chr(32)
eLSE
 eRR_MSG(ALLTRIM(NARR_STR))
ENDIF
Retu


*----------------------------------------------------------
* FUNCTION FOR DOING
    proc modes_h
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
                Set softSeek on 
          set order to 2
             
        msav=setcolor("/w+,w+/n")
          @ 4,9 to 21,61 double
           dbedit(5,10,20,60,fil,"mu","",samp)
            setcolor(msav)
            set order to 1
            Set softSeek off  
        set key 28 to modes_h
          sele 3
          SET KEY 27 TO Esc_proc
          restscreen(4,9,23,61,xf)
          release xf

   *-----------------------------------------
   *----------------------function func_r
function mu
param dfg,klm
 kes=lastkey()
 do case
  case kes=13
   sele 3
   replace j_id with jrno,j_doc with "JV",jdate with mdat,jcode with d->s_code,jdesc with d->s_desc
     keyb chr(4)+chr(4)
       return 0
  case kes=27
      return 0
  case kes >=32 
       foo=foo+upper(chr(kes))
  case kes==8
       foo=substr(foo,1,len(foo)-1)
   otherwise
      retu 1
   endcase

      @ 22,9 say space(52)
      @ 22,9 say foo
    set softseek on
       Seek foo
    set softseek off
       keyb chr(0)       
     return 2

*-------------------------------
* function to save data in a file
* journal entries are saved
*----------------------------------

function dbsave
sele 3
go top
 hifi=month(jdate)
 mhifi=month(date())
 hifi=iif(hifi>=4 ,hifi-3,hifi+9)
 mhifi=iif(mhifi>=4 ,mhifi-3,mhifi+9)
 do while !eof()
    sele a
     appen blank
    sele c
      replace a->j_id with jrno,a->jdate with mdat,a->j_doc wiTH  J_DOC
      replace a->jcode with jcode,a->jdesc with jdesc
      replace a->jcat with jcat,a->amount with amount
*--------------------------posting to ledger
       sele 2
*    -----------------------------
       if (c->jcat="CR") .and. c->jcode <>sDR
      appen blank

         
        replace ac_1 with sDR,jdate with mdat
        replace jid with jRNO,ac_2 with c->jcode,amount with c->amount
    elseif c->jcode <>sDR
     appen blank
 
    replace ac_1 with c->jcode,jdate with mdat
     replace jid with jrno,ac_2 with sDR
     replace amount with c->amount
   endif

   sele e
    seek c->jcode
      for  i=hifi to mhifi
         rap='month'+iif(i<=9,'0'+str(i,1),str(i,2))
         replace &rap with &rap+If(c->jcat=="DR",c->amount,-(c->amount))
        next i
      COMMIT 
     sele c
     skip
enddo

sele 7
appen blank
Replace jour_no with jrno,narration with narr_str
COMMIT
       SELE C
         COMMIT
       SELE A
         COMMIT
SELE E
   COMMIT
retu  0
*----------------------------------------
* function to dbedit
* invoices view with caution
*---------------------------------------
Function rap
param s,i
  ker=lastkey()
      ed_field=field(i)
   if s=1
      err_msg("   NO MORE   ")
      return 1
   endif

 IF KER=24
     if s=2
        if  packing>0 .and. quant>0
                append blank
                replace disc with sdis,taxable with "Y", Packing with mpas                     
        Endif  

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
                       set key 27 to
                          if ker <>13
                            keyboard chr(ker)
                           endif

                IF  i=1
                  set key 28 to _code_h
                  set cursor on
                  @ row(),col()  get &ed_field  PICT "@!" VALID SCALF(&ED_FIELD)
                  read
                  set key 28 to 
                  REPLACE DESC WITH c->S_DESC
                  set cursor off
                        KEYBOARD CHR(4)+chr(4)+CHR(13)
                  elseif i==2
                           set cursor on
                       @ row(),col()  get &ed_field  PICT "@!"
                       read
                       set cursor off
                       KEYB CHR( 4)
                       ELSEif i==3
                       set cursor on
                        @ row(),col() get &ed_field  VALID va_code(D->code,&ed_field)
                        read
                       set cursor off
                         mpas=&ed_field
                       keyboard chr(4)+chr(4)
                    ELSEIF I==4
                      set cursor on
                        @ row(),col() get &ed_field  VALID FOOR(&ED_FIELD)
                        read
                       set cursor off
                       keyboard chr(4)
                    ELSEIF I==5
                      set cursor on
                         @ row(),col() get &ed_field  VALID Sammy(&ED_FIELD,Packing)
                         read
                       set cursor off
                       keyboard chr(4)+CHR(13)
                ELSEIF I==6
                      REPLACE &ED_FIELD WITH RATE*QUANT
                      KEYB CHR(4)
                ELSEIF I==7
                       if &ed_field==space(1)
                        KEYB "Y"
                       endif
                        @ ROW(),COL() GET &ED_FIELD pict "@!" valid &ed_field$"YN"
                        READ
                      KEYB CHR(4)
                 elseif i==8
                      keyb  str(SDIs)
                       set cursor on
                       @ row(),COL() get &ed_field valid &Ed_field >=0
                      read
                      sdis=&ed_field
                      KEYB REPLI(CHR(19),7)+CHR(24)
                       set cursor off



                   ENDIF
             set key 27 to Esc_proc
    case  ker=7
             as=recno()
            if reccount()>0
              if reccount()=1
                  delete
                  pack
                  appen blank
                  REPLACE TAXABLE WITH "Y" 
               else
                delete
                pack
              endif
           endif

             goto as
             keyb chr(0)
             retu 2

   case ker=-6
     getdisc()

   Case ker=-1
           Go top
             Do while !eof()
                 if quant>0
                    skip
                  else
                     Err_msg("Current entry contains Error")
                     Return 1
                  endif
              Enddo
 
                       
         Return 0
       ENDCASE
   RETU 1
*----------------------------------------------
* function to dump data to screen
*---------------------- invoice file
function _funcr
param dfg,klm
 kes=lastkey()
 Do case
    Case kes==13
      REPLACE D->CODE WITH S_CODE,D->DESC WITH S_DESC
      keyb chr(0)
      RETURN 0
 case KES==27
    KEYB CHR(4)
    RETURN 0
  CASE KES >=32  
     FOO=FOO+upper(CHR(KES))
 CASE KES==8
      FOO=SUBSTR(FOO,1,LEN(FOO)-1)
 OTHERWISE
      RETU 1
 ENDCASE
      @ 22,9 SAY SPACE(52)
      @ 22,9 SAY FOO
        set softseek on
             seek foo
        set softseek off
             keyb chr(0)
           return 2 
*--------------------------------------------------









    RETURN 1
*----------------------------------------
*------------ function to validate code
function va_code
param cd_e,rd_e
IF RD_E<=0
 ERR_MSG(" INVALID PACKING ")
 RETU .F.
ENDIF
FS=select()
 sele 3
 for i=2 to 4
       rs=LTRIM(str(i))
       set order to &rs
        seek STR(rd_e)+cd_e
         if found()
            CM=LTRIM(STR(I-1))
             REPLACE D->RATE WITH S_RATE&CM
             seleCT(FS)
             retu .t.
         endif
      next i
      SELECT(FS)
      err_msg(" NO SUCH PACKING ")
      RETU .T.
*--------------------------
    PROC _CODE_H
      PRIVATE FIL[2],SAMP[2]
       FIL[1]="S_CODE"
       FIL[2]="s_DESC"
       SAMP[1]=" CODE "
       SAMP[2]=" DESCREPTION "
      xf=savescreen(4,9,22,61)
      public foo
       foo=""
       set key 28 to
       rms=select()
        sele 3
         sET ORDER TO 1
          set colo to /w+,w+/n
          @ 4,9 to 21,61 double
           keyb chr(0)
         dbedit(5,10,20,60,fil,"_funcr","",samp)
            set colo to w+/n,n/w+
          sele(rms)
          restscreen(4,9,22,61,xf)
          release xf
            set key 28 to _code_h
      return



*---------------------------------------------------
FUNCTION SAMMY
param munked,Mp
Sele 2
 seek  D->CODe
  Sele 4
   if munked==0
         err_msg(" invalid quantity  ")
         Retu .f.
    ELSEif B->it_qty<munked*mp
         Err_msg(" insufficient Stock  ")
         Retu .t.
    endif
 Return .t.


*---------------------- function to print invoices
*-----------------------------------



function getdisc
set key 27 to
rs=savescreen(20,10,22,30)
@ 20,10 clea to 22,30
@ 20,10 to 22,30  double
sr=sdis
@ 21,17 get sdis pict "99.99"
read

if lastkey()=27
 sdis=sr
endif
restscreen(20,10,22,30,rs)
set key 27 to Esc_proc
retu 0

*--------------------------------------------------------
* Cash_transaction dbedit
*
*---------------------------------------------------------------

function rootf
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

                              set key 28 to fool_h
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
            SDR=Ban_code
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

   *function fool_h
    proc fool_h
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
             Set SoftSeek on
          set order to 2   

         msav=setcolor("W+/w+,n/W+")
          @ 4,9 to 21,61 double
           dbedit(5,10,20,60,fil,"munny","",samp)
            setcolor(msav)
             set order to 1
              Set softSeek off
        set key 28 to fool_h
          sele 3
          SET KEY 27 TO Esc_proc
          restscreen(4,9,23,61,xf)
          release xf

   *-----------------------------------------
   *----------------------function func_r
function munny
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
  case kes>=32 .and. kes<=127
       foo=foo+upper(chr(kes))
  case kes==8
       foo=substr(foo,1,len(foo)-1)
   otherwise
      retu 1
   endcase

      @ 22,9 say space(52)
      @ 22,9 say foo
          set softseek on

           Seek foo
           set softseek off
            keyb chr(0)
    return 2
*--------------------------------------------------
*---------------------Function to Backup Data to Hard DISK
function backall
Param _wool
set key 27 to
VMA=SAVESCREEN(10,10,16,40)
@ 10,10 TO 16,40
SET COLO TO G/B
@ 11,11 CLEA TO 15,39
SET COLO TO N/W
@ 13,16 SAY "  DON'T INTERRUPT  "


Do Case
   Case _wool=="1"
 num=adir("data\*.DBF")
 declare  x[num]
 adir("data\*.dbf",x)
 tg="data\"
   Case _wool=="2"
 num=adir("stock\*.DBf")
 declare  x[num]
 adir("stock\*.Dbf",x)
  tg="stock\"
Endcase

 for i= 1 to  num
   copy file ( tg+x[i]) to ("back\"+x[i])
 next i


CLOSE ALL
*-----------------------------------
SET COLO TO
RESTSCREEN(10,10,15,40,VMA)




retu 0
*---------------------------------------------


function rootf1
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

                              set key 28 to fool_h
                               if ker <>28
                            keyboard chr(28)
                            endif
                        wait ""
                        set key 28 to
          *----------------case field =2
                     elseif i=2
                               
                        set cursor on
                             KEYB VAL_M
                        @ row(),col() get &ed_field pict "!!" valid &ed_field=Val_m
                        read
                       set cursor off
                       keyboard chr(4)
                     elseif  i=3
                        set cursor on
                        @row(),col() get &ed_field pict "99999999999999.99" valid &ed_field>0
                       read
                        set cursor off

                      elseif i=4
                        set cursor on
                         @row(),col() get &ed_field  
                       read
                        set cursor off
                       elseif i=5
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
            SDR=Ban_code
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

Function Foor
Param drt
if drt==0
   Err_msg("Foc is assumed")
  return .t. 
elseif drt>0
     Return .t.
  else 
     Return .f.
 endif  

FUNCTION SCALF
PARAM _MART
RES=SELECT()

 SELE C
 SET ORDER TO 1
 SEEK _MART
  IF !FOUND()
     ERR_MSG("NO SUCH ITEM EXISTS ")
     SELECT(RES) 
     SET ORDER TO 2       
RETU .F.
 ELSE
   SELECT(RES)
   SET ORDER TO 2
   RETU .T.
 ENDIF
 

Function Is_Fin
goo_dat=Ctod("01/04/"+if(month(date())<=3,str((year(date())-1 )%100,2),str(year(date())%100,2)))
return goo_dat


