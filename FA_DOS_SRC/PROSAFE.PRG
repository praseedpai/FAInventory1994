* program to print profit & loss a/c
* only a try if succesfull great benefit
* date written -12/01/95
*---------------------------------------------
******************* use the data file
showbox()
MHIFI=MONTH(DATE())
MHIFI=IIF(MHIFI>=4 ,MHIFI-3,MHIFI+9)
RAP='MONTH'+iif(mhifi<=9,'0'+STR(mhifi,1),str(mhifi,2))
use data\bal_ledg index data\bal_ledg
sort on Is_code to tempo for val(left(is_code,2))>=50  .and. &rap<0
sort on is_code  to tempo1 for val(substr(is_code,1,2))>=50  .and. &rap>0

Sele 1
Use data\Sgroup index data\Sgroup
Sele 2
Use tempo

Sele 3
Use tempo1


   mlin=7
   set device to printer
   set printer to fool.prn
  m_HEAD()
  sele 3
 still=.f.
 still1=.f.
 drtot=0
 crtot=0

 do while  .t.
    If  !still1
        if   val(left(is_code,2))<=59   .and. !eof()
            sele 1
              seek C->is_code
             sele 3
               @ mlin,2 say "To " +substr(a->s_desc,1,30)
               @ mlin,41 say   str(&rap,19,2)
               drtot=drtot+&rap
               skip
       elseif   val(left(is_code,2))>=85 .and.  val(left(is_code,2))>=92 .and. !eof()
             sele 1
              seek C->is_code
             sele 3
              @ mlin,2 say "To " +substr(a->s_desc,1,30)
              @ mlin,41 say   str(&rap,19,2)
              drtot=drtot+&rap
              skip
          else
           still1=.t. 
         endif
     Endif
     Sele 2
      If  !still
        if   val(left(is_code,2))>=85 .and. val(left(is_code,2))<=92 .and. !eof()
           sele 1
             seek b->is_code
           sele 2
            @ mlin,62 say "BY " +substr(a->s_desc,1,30)
             @ mlin,101 say   Str(abs(&rap),19,2)
              crtot=crtot+abs(&rap)
                 skip
          elseif   val(left(is_code,2))<=59 .and. !eof()
             sele 1
              seek b->is_code
             sele 2
              @ mlin,62 say "By " +substr(a->s_desc,1,30)
              @ mlin,101 say   str(abs(&rap),19,2)
               crtot=crtot+abs(&rap)
                 skip
           else
              still=.t.
          endif
       endif

    mlin=mlin+1
    If mlin>64
        mlin=7
        eject
        m_head()
    endif
     if still1 .and. still
      exit
    endif
sele 3
  Enddo
      if mlin>60
           mlin=7
           eject
           m_head()
      endif

 carried= drtot<crtot

   IF DRTOT <CRTOT
      @ mlin,2 say "TO balance c/d "
      @ mlin,41 say str(cRTOT-DRTOT,19,2)
   ELSE
      @ mlin,62 say "BY balance c/d "
      @ mlin,101 say str(dRTOT-cRTOT,19,2)
  ENDIF
     MLIN=MLIN+1
      @ MLIN,41  SAY REPLI(CHR(205),19)
      @ MLIN, 101 SAY REPLI(CHR(205),19)
      MLIN=MLIN+1

      @ mlin,2 SAY  "T O T A L "
      @ MLIN,41 SAY str(MAX(DRTOT,CRTOT),19,2)
      @ MLIN,62 SAY "T O T A L "
      @ MLIN,101 SAY str(MAX(DRTOT,CRTOT),19,2)
       MLIN=MLIN+1
        @ MLIN,41  SAY REPLI(CHR(205),19)
      @ MLIN, 101 SAY REPLI(CHR(205),19)
      MLIN=MLIN+2
        profit=abs(crtot-drtot)
      store 0 to drtot1,crtot1
      IF DRTOT <CRTOT
          @ MLIN,62 SAY "BY BALANCE B/D "
          @ MLIN,101 SAY  str(profit,19,2)
           crtot1=profit
      ELSE
         @ MLIN,2 SAY "TO BALANCE B/D "
         @ MLIN,41 SAY str(profit,19,2)
        drtot1=profit
     ENDIF
       still=.f.
       still1=.f.

        sele 2
          locate for val(left(is_code,2))>92
        sele 3
          locate for val(substr(is_code,1,2))>=60

   do while .t.
      If !still
        sele 3
        if   !eof() .and. val(subs(is_code,1,2))>=60 .and. val(subs(is_code,1,2))<=84
                    sele 1
                seek c->is_code
              sele 3
                 @ mlin,2 say "To " +substr(a->s_desc,1,30)
                 @ mlin,41 say   str(&rap,19,2)
                   drtot1=drtot1+&rap
                   skip

       elseif !eof()  .and. val(subs(is_code,1,2))>=92
                sele 1
                 seek b->is_code
                sele 3
                 @ mlin,2 say "To " +substr(a->s_desc,1,30)
                 @ mlin,41 say   str(&rap,19,2)
                   drtot1=drtot1+&rap
                   skip
         else
          still=.t.

      endif
  endif

   if !still1
        sele 2
      if !eof()  .and. val(left(is_code,2)) >=92
         sele 1
         seek b->is_code
         sele 2
         @ mlin,62  say "By " +substr(a->s_desc,1,30)
         @ mlin,101 say   str(abs(&rap),19,2)
         crtot1=crtot1+abs(&rap)
                     skip
      elseif !eof()  .and.  val(left(is_code,2)) >=60
         sele 1
          seek b->is_code
         sele 2
          @ mlin,62  say "By " +substr(a->s_desc,1,30)
          @ mlin,101 say   str(abs(&rap),19,2)
           crtot1=crtot1+abs(&rap)
             skip

      else
         still1=.t.
       endif
         endif

                     if still .and. still1
                        exit
                     endif
                 


                enddo
     sele 2

 IF DRTOT1 <CRTOT1
      @ mlin,2 say "TO net profit transfered "
      @ mlin,41 say str(CRTOT1-DRTOT1,19,2)
      ELSE
      @ mlin,62 say "BY netloss transfered "
      @ mlin,101 say str(DRTOT1-crtot1,19,2)
    ENDIF
     MLIN=MLIN+1
      @ MLIN,41  SAY REPLI(CHR(205),19)
      @ MLIN, 101 SAY REPLI(CHR(205),19)
      MLIN=MLIN+1

      @ mlin,2 SAY  "T O T A L "
      @ MLIN,41 SAY str(MAX(DRTOT1,CRTOT1),19,2)
      @ MLIN,62 SAY "T O T A L "
      @ MLIN,101 SAY str(MAX(DRTOT1,CRTOT1),19,2)
       MLIN=MLIN+1
        @ MLIN,41  SAY REPLI(CHR(205),19)
      @ MLIN, 101 SAY REPLI(CHR(205),19)
       Eject
    set device to screen
    set printer to
     hidebox()
    brow("fool.prn")
    close all
    balan(crtot1-drtot1)

retu


FUNCTION m_HEAD
 @ 1,5 say "       S I M I L I A   H O M O E O   L A B O R A T O R Y   "
 @ 2,20 say "       Trading,Profit & LOSS A/C       "
 @ 3,20 say "   from    " +"01/04/94"+" to "+DTOC(DATE())
 @ 4,0 SAY REPLI(chr(205),120)
 @ 6,0 SAY REPLI (chr(205),120)
 RETU 0


 * program to print balance sheet
* summary  rest in schedules
*-----------------------------------------
func balan
param sn
showbox()
sele 1
  use data\group  index data\group
 sele 2
   use data\bal_ledg index data\bal_ledg
  MHIFI=MONTH(DATE())
  MHIFI=IIF(MHIFI>=4 .AND. MHIFI<=12,MHIFI-3,MHIFI+9)
  RAP='MONTH'+iif(mhifi<=9,'0'+STR(mhifi,1),str(mhifi,2))
 SELE 3
  USE TEMPS
  ZAP
 SELE 4
  USE TEMPS1
  ZAP
 
 SELE 1
  LOCATE FOR VAL(LEFT(A_CODE,2))>2

 DO WHILE !EOF() .AND. VAL(A_CODE)<=49
       SELE 2     
       SUM &RAP TO FOO11 FOR LEFT(IS_CODE,2)=A->A_CODE
           
            IF (FOO11>0)   
                SELE 3
                  APPEND BLANK 
                  REPLACE C->IS_CODE WITH A->A_CODE
                   REPLACE BALAN WITH FOO11
             ELSEIF (FOO11<0)
                 SELE 4
                  APPEND BLANK 
                  REPLACE D->IS_CODE WITH A->A_CODE
                  REPLACE BALAN WITH FOO11  
            ENDIF
         SELE 1
        skip
     ENDDO
      
 set device to printer
 set printer to fool.prs
 t_head()
  mlin=6
  @ mlin,10 say " L I A B I L I T I E S "
  @ MLIN+1,0 SAY  repli(chr(196),60)
  MLIN=MLIN+2
   sele 4
     go top
       TOT=-sn
       Ltot=0
       
       SELE 2 
        sum  &rap to foo1 for substr(ltrim(is_code),1,2)='01'
        sum &rap to foo2 for substr(ltrim(is_code),1,2)="02"
          sele 1
        @ mlin,2 say "Capital A/c's  "+str(abs(foo1),14,2)
         Ltot=Ltot+abs(foo1)

         if tot<0
            mlin=mlin+1
          @mlin,2 Say "Add Profit     "+str(abs(tot),14,2)
        elseif tot>0
            mlin=mlin+1
         @ mlin,2 say "Less Loss      " +str(abs(tot),14,2)
        endif
         Ltot=Ltot+abs(tot)
       if foo2>0
          mlin=mlin+1
         @ mlin,2 say "Less Drawings  "+str(abs(foo2),14,2)
                Ltot=Ltot+foo2
     elseif foo2<0
         mlin=mlin+1
         @ mlin,2 say "ADD Curent a/c "+str(abs(foo2),14,2)
       Ltot=Ltot+foo2
endif
        @ mlin+1,17 say repli(chr(205),14)

        @ mlin+2,41 say Str(abs(Ltot),19,2)
            mlin=mlin+3
SELE 4
do while !eof()  
  SELE 1
     SEEK LEFT(d->Is_CODE,2)
  SELE 4
     @ mlin,2 say a->a_desc
     @ mlin,41 say Str(abs(BALAN),19,2)
     mlin=mlin+1
     LTOT=LTOT+ABS(BALAN)
     skip
 enddo
 @ mlin,41 say repli(chr(205),19)
 mlin=mlin+1
  @ MLIN,2 SAY " T O T A L "
  @ MLIN,41 SAY Str(abs(LTOT),19,2)
    MLIN=MLIN+2
         @ mlin,10 say "    A S S E T S "
         @ MLIN+1,0 SAY   repli(chr(196),60)

       TOT=0
       MLIN=MLIN+2
     
SELE 3
go top
LTOT=0

 do while !eof() 
     SELE 1
       SEEK LEFT(C->Is_CODE,2)
     SELE 3
       @ mlin,2 say a->a_desc
       @ mlin,41 say Str(abs(BALAN),19,2)
       mlin=mlin+1
       LTOT=LTOT+ABS(BALAN)
      SKIP
   ENDDO         







      @ mlin,41 say repli(chr(205),19)
       MLIN=MLIN+1
        @ MLIN,2 SAY " T O T A L "
         @ MLIN,41 SAY Str(abs(LTOT),19,2)
         MLIN=MLIN+1
        eject
   set device to screen
   set printer to
   hidebox()
   keyb chr(13)
   brow("fool.prs")
close all
 retu 0



FUNCTION t_HEAD
 @ 1,5 say "       S I M I L I A  H O M O E O  L A B O R A T O R Y   "
 @ 2,20 say "       balance  sheet       "
 @ 3,20 say "   from    " +"01/04/94"+" to "+DTOC(DATE())
 @ 4,0 SAY REPLI(chr(205),61)
 @ 6,0 SAY REPLI (chr(205),61)
 RETU 0




