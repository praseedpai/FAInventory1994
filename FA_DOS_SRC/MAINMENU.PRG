Clear
Set Score Off
Set Confirm Off
Set century on 
Set date british
Set deleted on
_curr=SETCOLOR("n/w")
@ 0,0 Say Repli(chr(205),80)
 @ 2,0 Say Repli(chr(205),80)
 @ 1,0 say space(80)
 @ 1,0 Say Center("S I M I L I A   H O M O E O   L A B O R A T O R Y")
 @ 3,0,24,79 BOX REPLI('±',9)
 @ 3,0,24,79 box repli('Û',9)
 setcolor("r+/b+")
 @ 3,0,24,79 BOX REPLI('°',9)
 setcolor("")
 @ 3,0
keyb chr(13)
Do while .t.
set century on 
rert=setcolor("\R+,/W+")
 @ 3,0  prompt " F . A . "
 @ 3,10 prompt "  INV    "
 @ 3,20 prompt " REPORTS "
 @ 3,35 prompt " REPORTS "
 @ 3,50 prompt " UTILS   "
 @ 3,65 prompt " BACKUP  "
 menu to kle
 setcolor(rert)
       if kle==0
          keyb chr(13)+repli(chr(24),15)
          loop
       endif
  sET KEY 4 TO RTPROC
  SET KEY 19 TO LTPROC
      do case
        case kle==1
          menu80()
        CASE Kle==2
          MENU90()
       case kle==3
          menu100()
       Case kle==4
          menu200()
       Case kle==5
          menu300()
     endcase

  SET KEY 4 TO
  SET KEY 19 TO
enddo

 Function Menu80
 xml=Savescreen(4,0,20,30)
 Scroll(4,0,20,30,0)

  do while .t.
    set century on 
    @ 4,0 to 20,30 double
 rert=Setcolor("/w+,w+")
  @ 5, 1 PROMPT "     EDIT GROUPS             "
  @ 6,1 PROMPT  "     EDIT SUBGROUPS          "
  @ 7,1 PROMPT  "     EDIT JOURNAL            "
  @ 8,1 PROMPT  "     BANK RECIEPTS           "
  @ 9,1 prompt  "     BANK PAYMENTS           "
  @ 10,1 prompt "     CASH RECIEPTS           "
  @ 11,1 PROMPT "     CASH PAYMENTS           "
  @ 12,1 PROMPT "     VIEW JOURNAL            "
  @ 13,1 PROMPT "     CHECK BALANCE           "
  @ 14,1 prompt "     TRIAL BALANCE           "
  @ 15,1 prompt "     SIMI                    "
  @ 16,1 PROMPT "     SIMI                    "
  @ 17,1 prompt "     SIMI                    "
  @ 18,1 prompt "     SIMI                    "
  @ 19,1 PROMPT "     QUIT                    "
  MENU TO _men80
  setcolor(rert)
       If _men80==15
          Close all
          clear all
          clear screen
          SET CURSOR ON
          Quit
       endif
         if _men80==0
              Restscreen(4,0,20,30,xml)
           retu 0
          endif
    set key 4 to
    set key 19 to
     save screen to foolish
     Do case
       Case _men80==1
          rdx=menu11()
             if rdx==0
                 exit
             endif
          Do edit_gro with if(rdx==1,"A",if(rdx==2,"C","D"))
       Case _men80 ==2
          rdx=menu11()
            if rdx=0
               exit
            endif

            Do Sgr with if(rdx==1,"A",if(rdx==2,"C","D"))

      Case _men80==3
           rdx=menu11()
            if rdx==0
             exit
            endif
               Do case
                 Case rdx==1
                   Do journ_ed
                 case rdx==2
                   Do jour_cha
                 case rdx==3
                   Do journ_de with "D"
               Endcase

       CASE _MEN80==4
            RDX=MENU11()
            if rdx==0
             exit
            endif
               Do case
                 Case rdx==1
                   Do BANK_TR WITH  "R"
                 case rdx==2
                   Do bANK_CHA WITH "R"

                 case rdx==3
                   Do BANK_DEL WITH  "R"
               Endcase

       CASE _MEN80==5
            RDX=MENU11()
            if rdx==0
             exit
            endif
               Do case
                 Case rdx==1
                   Do BANK_TR WITH  "P"
                 case rdx==2
                   Do bANK_CHA WITH "P"

                 case rdx==3
                   Do BANK_DEL WITH  "P"
               Endcase
       CASE _MEN80==6
            RDX=MENU11()
            if rdx==0
             exit
            endif
               Do case
                 Case rdx==1
                   Do Cash_TR WITH  "R"
                 case rdx==2
                   Do cash_CHA WITH "R"

                 case rdx==3
                   Do cash_DEl WITH  "R"
               Endcase

               CASE _MEN80==7
            RDX=MENU11()
            if rdx==0
             exit
            endif
               Do case
                 Case rdx==1
                   Do Cash_TR WITH  "P"
                 case rdx==2
                   Do cash_CHA WITH "P"

                 case rdx==3
                   Do cash_DEl WITH  "P"
               Endcase
       case _men80==8
         do journ_de with "V"
       Case _men80==9
         Do Trial  
       Case _men80==10
        Do actual
     endcase
          restore screen from foolish
          set century on 
     set key 4 to rtproc
     set key 19 to ltproc
 enddo
   Restscreen(4,0,20,30,xml)
  Return _men80

  function MENU90
   xml=Savescreen(4,10,20,40)
   Scroll(4,10,20,40,0)
  Do while .t.
  set century on 
  @ 4,10 to 20,40 double
  rert=setcolor("/w+,w+")
  @ 5,11 prompt   "  R. MATERIALS GROUP         "
  @ 6,11 prompt   "  C & BOTTLES  GROUP         "
  @ 7,11 prompt   "  END PROD.    GROUP         "
  @ 8,11 prompt   "  R. MATERIALS SUBGROUP      "
  @ 9,11 prompt   "  C & BOTTLES  SUBGROUP      "
  @ 10,11 prompt  "  END PROD.    SUBGROUP      "
  @ 11,11 prompt  "  R. MATERIALS STOCK         "
  @ 12,11 prompt  "  C & BOTTLES  STOCK         "
  @ 13,11 prompt  "  END PRODUCT  STOCK         "
  @ 14,11 prompt  "  DEALER                     "
  @ 15,11 prompt  "  INVOICE                    "
  @ 16,11 prompt  "  PRINT INVOICE              "
  @ 17,11 prompt  "  PaGE FIT                   "
  @ 18,11 prompt  "  SIMI                       "
  @ 19,11 prompt  "  SIMI                       "
  menu to _men80
   setcolor(rert)
     if _men80==0
       restscreen(4,10,20,40,xml)
       return 0
    endif
   Set key 4 to
   set key 19 to
   Save screen to foolish
     Do Case
       Case _men80==1
              rdx=menu11()
                 if rdx==0
                   Exit

                 endif

          Do Heads with if(Rdx=1,"A",if(Rdx=2,"C","D")) ,1
       case _men80==2
            rdx=menu11()
                rdx=menu11()
                 if rdx==0
                   Exit

                 endif

          Do Heads with if(Rdx=1,"A",if(Rdx=2,"C","D")) ,2

       case _men80==3
            rdx=menu11()
                 if rdx==0
                   Exit

                 endif

          Do Headedit with if(Rdx=1,"A",if(Rdx=2,"C","D"))
       case _men80==4
            rdx=menu11()
                 if rdx==0
                   Exit

                 endif

          Do Esubr with if(Rdx=1,"A",if(Rdx=2,"C","D")),1
        case _men80==5
            rdx=menu11()
                 if rdx==0
                   Exit

                 endif

          Do Esubr with if(Rdx=1,"A",if(Rdx=2,"C","D")),2
        case _men80==6
            rdx=menu11()
                 if rdx==0
                   Exit

                 endif

          Do Sub_edit with if(Rdx=1,"A",if(Rdx=2,"C","D"))

       Case _men80==7
            DO PURTRA WITH "1"

    Case _men80==8
            DO PURTRA WITH "2"

     Case _men80==9
           DO EPURTRA

     Case _men80==10
               Rdx=menu11()
                 if rdx==0
                    exit
                 endif
          do ckkmdlr with if(rdx==1,"A",if(rdx==2,"C","D"))
    Case _men80==11
           Rdx=menu11()
            if rdx==0
                 exit
            endif

            Do Case
               Case rdx==1
                 Do invadd
               Case rdx==2
                 Do invcha
               Case rdx==3
                 do invdel
           endcase
      Case _men80==12
        Do invnew
      cASE _MEN80==13
        DO invnew1
    Endcase

    Restore screen from foolish
   Set key 4    to rtproc
   set key 19    to ltproc

  Enddo
    restscreen(4,10,20,40,xml)
 close all
 retu  0




   Restscreen(4,10,20,40,xml)
  Return KSu

 PROC RTPROC
 KEYBOARD CHR(27)+CHR(24)+CHR(13)
 RETU

 PROC LTPROC
 KEYBOARD CHR(27)+CHR(5)+CHR(13)
 RETU



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
 *---------------------------------------------
 Function Menu100
 xml=Savescreen(4,20,20,50)
 Scroll(4,20,20,50,0)
  do while .t.
  set century on 
  @ 4,20 to 20,50 double
rert=setcolor("/w+,w+")
  @ 5, 21 PROMPT "     V/P GROUPS              "
  @ 6,21 PROMPT  "     V/P SUBGROUPS           "
  @ 7,21 PROMPT  "     V/P LEDGER              "
  @ 8,21 PROMPT  "     V/P P & L && B/S.       "
  @ 9,21  prompt "     REORGANISE FILES        "
  @ 10,21 prompt "     RECALCULATE BALANCES    "
  @ 11,21 PROMPT "     LIST  J V               "
  @ 12,21 PROMPT "     LIST  C R               "
  @ 13,21 PROMPT "     LIST  C P               "
  @ 14,21 prompt "     LIST  B R               "
  @ 15,21 prompt "     LIST  B P               "
  @ 16,21 PROMPT "     V/P   SCHEDULES (ASSET) "
  @ 17,21 prompt "     V/P   SCHEDULES (LIAB.) "
  @ 18,21 prompt "     V/P  P & L              "
  @ 19,21 PROMPT "     SIMI                    "
  MENU TO _men80
  setcolor(rert)
   if _men80==0
       restscreen(4,20,20,50,xml)
     return 0

   endif
   Set key 4 to
   set key 19 to
   Save screen to foolish
     Do case
       case _men80==1
          do gr_rep with 1
       Case _men80==2
          Do gr_rep with 2
      case _men80==3
          Do bal_pri
      Case _men80==4
          Do pro1
      case _men80==5
         Do reorg
      case _men80==6
         Do recalc
      Case _men80==7
        do journ_rp with 1
      Case _men80==8
        do journ_rp with 2
      Case _men80==9
        do journ_rp with 3
      Case _men80==10
        do journ_rp with 4
      Case _men80==11
        do journ_rp with 5
      cASE _MEN80==12
            DO SCHEDULE WITH "2"
      cASE _MEN80==13
            DO SCHEDULE WITH "1"
       Case _men80==14
            DO Proo
   endcase
  Set key 4 to  rtproc
   set key 19 to ltproc
     Restore screen from foolish
enddo
return 0

function MENU200
 xml=Savescreen(4,30,20,60)
 Scroll(4,30,20,60,0)
Do while .t.
  set century on 
  @ 4,30 to 20,60 double
  rert=setcolor("/w+,w+")
  @ 5,31 prompt   "  V/P  GROUP     (R.M)       "
  @ 6,31 prompt   "  V/P  GROUP     (C&B)       "
  @ 7,31 prompt   "  V/P  GROUP     (E.P)       "
  @ 8,31 prompt   "  V/P  SUBGROUP  (R.M)       "
  @ 9,31 prompt   "  V/P  SUBGROUP  (C&B)       "
  @ 10,31 prompt  "  V/P  SUBGROUP  (E.P)       "
  @ 11,31 prompt  "  V/P  STOCK REG (R.M)       "
  @ 12,31 prompt  "  V/P  STOCK REG (C&B)       "
  @ 13,31 prompt  "  V/P  STOCK REG (E.P)       "
  @ 14,31 prompt  "  V/P  INVOICE (dealer wise) "
  @ 15,31 prompt  "  V/P  INVOICE ( dATE WISE)  "
  @ 16,31 prompt  "  sTOCK REPORT  (R.M)        "
  @ 17,31 prompt  "  STOCK REPORT  (C&B)        "
  @ 18,31 prompt  "  STOCK REPORT  (E.P)        "
  @ 19,31 prompt  "  V/P   SEGMENTED (INVOICE)  "
menu to _men80
setcolor(rert)
     if _men80==0
       exit
    endif
   Set key 4 to
   set key 19 to
   Save screen to foolish
   do Case
     Case _men80==1
       Do rg_rep with "1"
     Case _men80==2
       do Rg_rep with "2"
     Case _men80==3
       Do Rg_rep with "3"
     Case _men80==4
       Do Sg_rep with "1"

     Case _men80==5
       Do Sg_rep with "2"

     Case _men80==6
       Do Sg_rep with "3"

   case _men80==7
        do rsto with "1"
   case _men80==8
        Do Rsto with "2"
   Case _men80==9
          Do stockrep
   cASE _MEN80==10
         DO SALES_REP WITH "1"
   cASE _MEN80==11
         dO SALES_REP WITH "2"      
    CASE _MEN80==12
         DO EREP WITH "1"
     CASE _MEN80==13
         DO EREP WITH "2"
      CASE _MEN80==14
         DO ENDR                     
       case _men80==15
         do grrep  
            endcase
   Set key 4 to ltproc
   set key 19 to rtproc
restore screen from foolish
Enddo
 restscreen(4,30,20,60,xml)
 return 0


 Function Menu300
 xml=Savescreen(4,40,20,70)
 Scroll(4,40,20,70,0)

  do while .t.
  set century on 
    @ 4,40 to 20,70 double
   rert=setcolor("/w+,w+")
  @ 5, 41 PROMPT "     Reorganise Files (F A)  "
  @ 6,41 PROMPT  "     Reorganise files (inv)  "
  @ 7,41 PROMPT  "     Backup To H D    (F A)  "
  @ 8,41 PROMPT  "     Backup to H D    (inv)  "
  @ 9,41 prompt  "     Recalculate RM          "
  @ 10,41 prompt "     Recalculate CB          "
  @ 11,41 PROMPT "     Simi                    "
  @ 12,41 PROMPT "     Simi                    "
  @ 13,41 PROMPT "     SIMI                    "
  @ 14,41 prompt "     SIMI                    "
  @ 15,41 prompt "     SIMI                    "
  @ 16,41 PROMPT "     SIMI                    "
  @ 17,41 prompt "     SIMI                    "
  @ 18,41 prompt "     SIMI                    "
  @ 19,41 PROMPT "     Simi                    "
  MENU TO _men80
        setcolor(rert)
         if _men80==0
          exit
          endif
    set key 4 to
    set key 19 to
     save screen to foolish
        do Case
           Case _men80==1
              do Reorg
           Case _men80==2
              Do Sreorg
           Case _men80==3
              backall("1")
           Case _men80==4
              backall("2")
           Case _men80 == 5

             Do Strecal with "1"

           Case _men80 == 6

             Do Strecal with "2" 

        Endcase
     Rest screen from foolish
   set key 4 to rtproc
   set key 19 to ltproc
 enddo

  Restscreen(4,40,20,70,xml)
  retu 0
