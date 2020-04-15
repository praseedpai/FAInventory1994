// BEGIN DOC
// PROCEDURE FOR JOURNAL ENTRIES
// NO PARAMETER
// GENERIC??!
// PROGRAMMER PRASEED PAI
// END DOC
//-----------------------------------------------
 param _why
 #define VA_MOD(S) S$"AaCcDd"
 #define PRESENT(S) FILE(S)
 #define ISALNUM(D) upper(D)$"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"+chr(13)
 #include "inkey.ch"
 #DEFINE FO C:\NEWFA\DATA
//----------------------------------------------------------
 local aer:={"jdesc","jcat","amount","chqno","chqdt"}
 local head:={"DESCRIPTION","DR/CR","  AMOUNT ","cheque no","Cheque date"}
 local pict:={"@!","!!","99999999999999.99","@!"}
  IF !_WHY$"pPRr"
     RETU
  ENDIF
 PUBLIC JUI,MDAT,sdr,MDOC
 MDOC=iif(_why$"pP","CP","CR")

//------------------------------------------------------------
set key 27 to esc_proc
  SELE 1
  USE FO\JOURNAL INDEX FO\JOURNAL
  SELE 2
  USE FO\LEDGER INDEX FO\LEDGER1
  SELE 3
  USE FO\TEMPOR
 SELE 4
  USE FO\SGROUP INDEX FO\SGROUP
SELE 5
  USE FO\BAL_LEDG INDEX FO\BAL_LEDG

SELE 6
  USE FO\BAN
  SELE 1
  SET ORDER TO 0
  GO BOTT
  JUI=J_ID+1
 SET ORDER TO 1
   //-------------------------------------------
    // -----------------------START OF LOOP TO EDIT
       scroll(0,0,24,79,0)
       @ 1,0 to 5,70
       @ 2,5 say "JOURNAL NO "
       @ 3,5 SAY " BANKCODE  "


       MDAT=DATE()
       all_ow=iif(_WHY$"pP","DR","CR")
       d_code=SPACE(5)




    //-------------------------------------
   begin sequence
    WHILE .T.
       @ 2,20 GET JUI
       @ 2,45 SAY "DATE"
       @ 2,50 GET MDAT
       READ
       SELE 6
       @ 5,10 TO 21,61

       dbedit(6,11,20,60,"","fun1")

       IF LASTKEY()==K_F10
        SELE 1
          loop
       endif
       SELE 1
       @ 3,20 GET D_CODE
       READ
       @ 3,20 SAY SPACE(6)
       @ 3,20 say F->b_desc
       @5,5 to 22,70 double
          begin sequence
        do while  .t.

          sele 3
           zap
           dbappend()

        dbedit(6,6,21,69,aer,"lap",pict,head)
           IF LASTKEY()==27
               break
           ENDIF
       IF LASTKEY()==-1
          DBSAVE()
          JUI++
          EXIT
            ENDIF
        ENDdo
          end
     END
    end
retu

// FUNCTION LAP
// AIM IS TO EDIT JOURNAL
// FOURSIDE TRASVERSAL
function lap
parameter s,i
//-----------------------------------------------
// BOF?? OR EOF??
       ker=lastkey()
       ed_field=field(i+4)
   if s==1
      err_msg("   NO MORE   ")
      return 1
   endif

  IF KER==K_DOWN
if s==2 .and. jdesc != space(25) .and. amount > 0 .and. (jcat=="CR" .or. jcat=="DR")

   dbappend()
endif
endif

     // CASE LASTKEY IS ESCAPE
 if ker==K_ESC
   return 0
 endif
   // case enter or alphanumeric
    Do case
      case  ISALNUM(chr(ker)) .or. ker==28
         //------------------- do case field =1
                          if ker !=K_ENTER
                            keyboard chr(ker)
                           endif

                              IF  i==1

                              set key 28 to code_h
                               if ker !=K_F1
                            keyboard chr(K_F1)
                            endif
                        wait ""
                        set key K_F1 to
          //----------------case field =2
                     elseif i==2
                        keyb chr(13)+all_ow+chr(13)
                        set cursor on


                        @ row(),col() get &ed_field pict "!!" valid &ed_field==all_ow
                             read
                       set cursor off
                       keyboard chr(K_RIGHT)
                     elseif  i==3
                        set cursor on
                        @row(),col() get &ed_field pict "99999999999999.99" valid &ed_field>0
                       read
                       set cursor off
                       keyboard chr(K_RIGHT)
                     elseif i==4
                     set cursor on
                      @ row(),col() get &ed_field pict "@!"
                      read
                      set cursor off
                     elseif i==5
                        @ row(),col() get &ed_field pict "@!"
                      read
                      set cursor off
                    endif

 //----------------------------------- case key is del
        case ker==K_DEL
        SELE 3
        IF RECCOUNT()>0
     if reccount()==1
          delete
         pack
         dbappend()
     else
         delete
         pack
      endif
      ENDIF
      KEYBOARD CHR(0)
         RETURN 2
//----------------------------------------- case key is f2
        case ker==K_F2
           go top
     do while !eof()
        if  jdesc != space(25) .and. amount > 0 .and. (jcat=="CR" .or. jcat=="DR")
          skip
         loop
          else
            err_msg("MISSING ENTRY")
             return 1
            endif
       enddo
        retu 0 
endcase
return 1
//---------------------------------------------
//----------------------------------------------

   //FUNCTION CODE_H
    PROC CODE_H
    local fil :={"S_code","S_desc"}
    local samp:={" CODE  ","  DESCRIPTION  "}
      xf=savescreen(4,9,21,61)

       set key K_F1 to
         sele 4
         set order to 0
          set colo to /w+,w+/n
          @ 4,9 to 21,61 double
           dbedit(5,10,20,60,fil,"funcr","",samp)
            set colo to w+/n,n/w+
        set key K_F1 to code_h
         set order to 1
          sele 3
          restscreen(4,9,21,61,xf)
          release xf
      return ""
   //-----------------------------------------
   //----------------------function func_r
function funcr
param dfg,klm
   kes=lastkey()
   if kes==K_ENTER
    SELE 3
     replace J_ID WITH JUI,J_DOC WITH MDOC,JDATE WITH mDAT,jcode with d->s_code,jdesc with d->s_desc
     KEYB CHR(K_RIGHT)+CHR(K_RIGHT)
   RETURN 0
    ELSEIF KES==K_ESC
    KEYB CHR(K_RIGHT)
   RETURN 0
    ENDIF
    RETURN 1
//--------------------------------------------------
//---------------FUNCTION TO SAVE THE DATA TO THE FILE
FUNCTION DBSAVE
  HIFI=MONTH(MDAT)
  MHIFI=MONTH(DATE())
  HIFI=IIF(HIFI>=4 .AND. HIFI<=12,HIFI-3,HIFI+9)
  MHIFI=IIF(MHIFI>=4 .AND. MHIFI<=12,MHIFI-3,MHIFI+9)
   err_msg(" HIFI IS "+STR(HIFI,2)+" MIHIFI IS "+STR(MHIFI,2))

    GO TOP
 DO WHILE !EOF()
     SELE A
       APPEN BLANK
     SELE C
     REPLACE A->J_ID WITH JUI,A->JDATE WITH MDAT,A->J_DOC WITH  J_DOC
     REPLACE A->JCODE WITH JCODE,A->JDESC WITH JDESC
     REPLACE A->JCAT WITH JCAT,A->AMOUNT WITH AMOUNT
     REPLACE A->NARR WITH NARR

//--------------------------POSTING TO LEDGER
//-----------------------------


     sele 2
      appen blank
         IF _WHY$"PP"
           REPLACE AC_1 WITH C->J_CODE
           REPLACE AC_2 WITH d_code
         ELSE
           replace AC_1 with d_code
           REPLACE AC_2 WITH C->JCODE
         ENDIF

       REPLACE jdate with mdat
       replace jID with jui,amount with c->amount

          SELE E
   SEEK B->AC_1
   FOR  I=HIFI TO MHIFI
       IF I<=9
        RAP='MONTH'+'0'+STR(I,1)
        ELSE
        RAP='MONTH'+STR(I,2)

      ENDIF
             ERR_MSG(B->AC_1+ " BALANCE OF  "+STR(&RAP))
         REPLACE &RAP WITH &RAP+(B->amount)
       ERR_MSG(B->AC_1+ " BALANCE OF  "+STR(&RAP))
NEXT I
   SEEK B->AC_2
   FOR  I=HIFI TO MHIFI
       IF I<=9
        RAP='MONTH'+'0'+STR(I,1)
        ELSE
        RAP='MONTH'+STR(I,2)
      ENDIF
       ERR_MSG(B->AC_2+ " BALANCE OF  "+STR(&RAP))
         REPLACE &RAP WITH &RAP-(B->amount)
       ERR_MSG(B->AC_2+ " BALANCE OF  "+STR(&RAP))
    NEXT I

      sele c

     SKIP
ENDDO

RETU  ""
//--------------------------------------------------------
FUNCTION FUN1
PARAM TY,TY1
KES=LASTKEY()
 IF KES==K_F1
    @ 3,20 SAY B_DESC

    KEYB B_CODE
    RETU 0
 ELSEIF KES==K_F10
    RETU 0
 ENDIF
 RETU 1

