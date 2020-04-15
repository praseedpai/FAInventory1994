ms=exename()
SET EXACT ON
SEt Score Off
 if substr( ms,  rat("\",ms)+1 ) <> "MAIN.EXE"
   err_msg(" name of file changed ")
   retu
 endif
SET DELETED ON
set date brit
@ 0,0,24,79 BOX REPLI(CHR(219),9)
SCROLL(3,20,23,56,0)
@ 4,21 TO 22,55
   PCO=0
*  DO WHILE PCO<=2
*        IF !_CCEK()
*            ERR_MSG(" INCORRECT PASSWORD ")
*            PCO=PCO+1
*            LOOP
*       ENDIF
*      EXIT
*  ENDDO
     SET COLO TO
      SET INTEN ON
        IF PCO==3
          RETU
        ENDIF

DO WHILE .T.

  @ 5, 25 PROMPT "    EDIT GROUPS           "
  @ 6,25 PROMPT  "    EDIT SUBGROUPS        "
  @ 7,25 PROMPT  "    EDIT JOURNAL          "
  @ 8,25 PROMPT  "    V/P  LEDGER           "
  @ 9,25 prompt  "    V/P  P & L A/C        "
  @ 10,25 prompt "    V/P  BALANCE SHEET    "
  @ 11,25 prompt "    REORGANISE FILES      "
  @ 12,25 PROMPT "    START AGAIN ???       "
  @ 13,25 PROMPT "    LIST JOURNAL          "
  @ 14,25 PROMPT "    LIST GROUPS           "
  @ 15,25 prompt "    Recalculate           "
  @ 16,25 prompt "    Backup to Hard Disk   "
  @ 17,25 prompt "    Bank Reciepts         "
  @ 18,25 prompt "    Bank Payments         "
   
  @ 21,25 prompt "    EXIT                  "
  MENU TO I
     IF I==0
        LOOP
      ENDIF
      IF I==15
        EXIT
      ENDIF
   SAVE SCREEN TO FB
     dO CASE
         CASE I==1
            RS= MENU11()
             IF RS==0
              LOOP
             ENDIF
     DO Edit_gro WITH IIF(RS==1,"A",IIF(RS==2,"C","D"))
         case i==2
             rs=menu11()
             IF RS==0
                LOOP
              ENDIF
          do sgr with   IIF(RS=1,"A",IIF(RS==2,"C","D"))
    CASE I==3
             RS=MENU11()
             IF RS==0
                LOOP
              ENDIF
                if rs==1
                   DO journ_ed
                elseif rs==2
                   do jour_cha
                else
                   do journ_de with "D"
                endif
     case i==4
         do bal_pri
     case i==5
        do pro1
     case i==6
        do balan
     CASE I==7
        DO REORG
     CASE I==8
        DO DELR
     CASE I==9
        DO JOURN_RP
     CASE I==10
        DO GR_REP
     Case i==11
        Do Recalc
     case i==12
        Do back
     Case i==13
        rs=menu11()
          if rs==0
            loop
          endif
          if rs==1
             do bank_tr with "R"
           elseif rs==2
             Do bank_cha with "R"
          else
             Do bank_del with "R"
          endif         
    case i==14
           rs=menu11()
          if rs==0
            loop
          endif
          if rs==1
             do bank_tr with "P"
           elseif rs==2
             Do bank_cha with "P"
          else
             Do bank_del with "P"
          endif              
     ENDCase
         REST SCREEN FROM FB
     ENDDO
close data
rele all
*-----------------
FUNCTION MENU11
RT=SAVESCREEN(7,40,15,60)
 SCROLL(7,40,15,60,0)
        @ 8,41 TO 14,59
        @ 9,43 PROMPT " ADD   "
        @ 11,43 PROMPT " CHANGE "
        @ 13,43 PROMPT " DELETE  "
        MENU TO K
        REStscREEN(7,40,15,60,rt)
             RETU K

FUNCTION _CCEK
rs=savescreen(10,10,16,50)
set colo to b/g
@ 11,11 clea to 15,49
set colo to n/w*
@ 13,15 say " Password:-"
set colo to n/n
set intensity off
cstring=space(6)
@ 13,28 get cstring
read
RESTSCREEN(10,10,16,50,RS)
RETURN charnot(cstring)=="ß¹°°³ß"
