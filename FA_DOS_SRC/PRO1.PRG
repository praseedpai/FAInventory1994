* program to print profit & loss a/c
* only a try if succesfull great benefit
* date written -12/01/95
*---------------------------------------------
******************* use the data file
showbox()
MHIFI=MONTH(DATE())
MHIFI=IIF(MHIFI>=4 ,MHIFI-3,MHIFI+9)
RAP='MONTH'+iif(mhifi<=9,'0'+STR(mhifi,1),str(mhifi,2))
Sele 1
  Use data\Sgroup index data\Sgroup
Sele 2
   use data\bal_ledg index data\bal_ledg
  
   locate for val(left(is_code,2))>=50

sele 3
   use scratch\remp0
zap
sele 4
    use scratch\remp1
zap
sele 5  
     use scratch\remp2  
zap
sele 6
 use scratch\remp3  
zap
   
sele 2 
  
 Do while !eof()
   Do Case
     Case &rap>0
       if  (val(left(is_code,2))>=50 .and. val(left(is_code,2))<=59) .or.;
             (val(left(is_code,2))>=85 .and. val(left(is_code,2))<=92) 
                sele 3
                appen blank
                replace is_code with B->is_code
                replace balan with abs(B->&rap)
                   
              else
            
                sele 5
                appen blank
                replace is_code with B->is_code
                replace balan with abs(B->&rap)
         endif
    Case &rap<0
       if  (val(left(is_code,2))>=50 .and. val(left(is_code,2))<=59) .or.;
         (val(left(is_code,2))>=85 .and. val(left(is_code,2))<=92) 
              sele 4
              appen blank
              replace is_code with B->is_code
              replace balan with abs(B->&rap)
                   
        else  
                
              sele 6
              appen blank
              replace is_code with B->is_code
              replace balan with abs(B->&rap)
         endif
      Endcase      

      sele 2
       skip
enddo

   mlin=7
   set device to printer
   set printer to fool.prn
  m_HEAD()
  sele 3
  go top
  sele 4
   go top 
still1=.f.
 still=.f.
 drtot=0
 crtot=0

do while  .t.
    sele 3
    if eof() 
       still1=.t.
    endif
 If  !still1
   sele 1
     seek C->is_code
   sele 3
      @ mlin,2 say chr(15)+ "To " +substr(a->s_desc,1,30)
      @ mlin,41 say chr(15)+   str(balan,19,2)
      drtot=drtot+balan
      skip
   endif
   Sele 4
      if eof()
        still=.t.  
      endif

    If  !still
        sele 1
            seek D->is_code
         sele 4
            @ mlin,62 say chr(15)+ "BY " +substr(a->s_desc,1,30)
             @ mlin,101 say chr(15)+   Str(abs(Balan),19,2)
              crtot=crtot+abs(Balan)
                 skip
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
  Enddo
      if mlin>60
           mlin=7
           eject
           m_head()
      endif

 carried= drtot<crtot

   IF DRTOT <CRTOT
      @ mlin,2 say chr(15)+ "TO balance c/d "
      @ mlin,41 say chr(15)+ str(cRTOT-DRTOT,19,2)
   ELSE
      @ mlin,62 say chr(15)+ "BY balance c/d "
      @ mlin,101 say chr(15)+ str(dRTOT-cRTOT,19,2)
  ENDIF
     MLIN=MLIN+1
      @ MLIN,41  say chr(15)+ REPLI(CHR(205),19)
      @ MLIN, 101 say chr(15)+ REPLI(CHR(205),19)
      MLIN=MLIN+1

      @ mlin,2 say chr(15)+  "T O T A L "
      @ MLIN,41 say chr(15)+ str(MAX(DRTOT,CRTOT),19,2)
      @ MLIN,62 say chr(15)+ "T O T A L "
      @ MLIN,101 say chr(15)+ str(MAX(DRTOT,CRTOT),19,2)
       MLIN=MLIN+1
        @ MLIN,41  say chr(15)+ REPLI(CHR(205),19)
      @ MLIN, 101 say chr(15)+ REPLI(CHR(205),19)
      MLIN=MLIN+2
        profit=abs(crtot-drtot)
      store 0 to drtot1,crtot1
      IF DRTOT <CRTOT
          @ MLIN,62 say chr(15)+ "BY BALANCE B/D "
          @ MLIN,101 say chr(15)+  str(profit,19,2)
           crtot1=profit
      ELSE
         @ MLIN,2 say chr(15)+ "TO BALANCE B/D "
         @ MLIN,41 say chr(15)+ str(profit,19,2)
        drtot1=profit
     ENDIF
        mlin=mlin+2 
       still=.f.
       still1=.f.
     sele 5
           if reccount()==0
               still=.t.
            endif
          go top
        sele 6
         if reccount()==0
           still1=.t.
         endif
         go top


  do while .t.
    sele 5

     if eof()
        still=.t.

      endif 

      If !still

         sele 1

            seek E->is_code

          sele 5
             @ mlin,2 say chr(15)+ "To " +substr(a->s_desc,1,30)
                @ mlin,41 say chr(15)+   str(Balan,19,2)
                  mlin=mlin+1
                   drtot1=drtot1+Balan
                   skip
       endif

        sele 6
       if eof() 
           still1=.t.
       endif
       if !still1
          sele 1
         seek F->is_code
         sele 6
         @ mlin,62  say chr(15)+ "By " +substr(a->s_desc,1,30)
         @ mlin,101 say chr(15)+   str(abs(Balan),19,2)
         mlin=mlin+1
          crtot1=crtot1+abs(Balan)
            skip
        endif
        if still .and. still1
                exit
         endif
       enddo

 IF DRTOT1 <CRTOT1
      @ mlin,2 say chr(15)+ "TO net profit transfered "
      @ mlin,41 say chr(15)+ str(CRTOT1-DRTOT1,19,2)
      ELSE
      @ mlin,62 say chr(15)+ "BY netloss transfered "
      @ mlin,101 say chr(15)+ str(DRTOT1-crtot1,19,2)
    ENDIF
     MLIN=MLIN+1
      @ MLIN,41  say chr(15)+ REPLI(CHR(205),19)
      @ MLIN, 101 say chr(15)+ REPLI(CHR(205),19)
      MLIN=MLIN+1

      @ mlin,2 say chr(15)+  "T O T A L "
      @ MLIN,41 say chr(15)+ str(MAX(DRTOT1,CRTOT1),19,2)
      @ MLIN,62 say chr(15)+ "T O T A L "
      @ MLIN,101 say chr(15)+ str(MAX(DRTOT1,CRTOT1),19,2)
       MLIN=MLIN+1
        @ MLIN,41  say chr(15)+ REPLI(CHR(205),19)
      @ MLIN, 101 say chr(15)+ REPLI(CHR(205),19)
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
 @ 3,20 say "   from    " +dtoc(is_fin())+" to "+DTOC(DATE())
 @ 4,0 SAY chr(15)+REPLI(chr(205),120)
 @ 6,0 SAY chr(15)+REPLI (chr(205),120)
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
  mlin=7
  @ mlin,10 say chr(15)+ " L I A B I L I T I E S "
  @ MLIN+1,0 say chr(15)+  repli(chr(196),60)
  MLIN=MLIN+2
   sele 4
     go top
       TOT=-sn
       Ltot=0
       
       SELE 2 
        sum  &rap to foo1 for substr(ltrim(is_code),1,2)='01'
        sum &rap to foo2 for substr(ltrim(is_code),1,2)="02"
          sele 1
        @ mlin,2 say chr(15)+ "Capital A/c's  "+str(abs(foo1),14,2)
         Ltot=Ltot+abs(foo1)

         if tot<0
            mlin=mlin+1
          @mlin,2 say chr(15)+ "Add Profit     "+str(abs(tot),14,2)
        elseif tot>0
            mlin=mlin+1
         @ mlin,2 say chr(15)+ "Less Loss      " +str(abs(tot),14,2)
        endif
         Ltot=Ltot+abs(tot)
       if foo2>0
          mlin=mlin+1
         @ mlin,2 say chr(15)+ "Less Drawings  "+str(abs(foo2),14,2)
                Ltot=Ltot+foo2
     elseif foo2<0
         mlin=mlin+1
         @ mlin,2 say chr(15)+ "ADD Curent a/c "+str(abs(foo2),14,2)
       Ltot=Ltot+foo2
endif
        @ mlin+1,17 say chr(15)+ repli(chr(205),14)

        @ mlin+2,41 say chr(15)+ Str(abs(Ltot),19,2)
            mlin=mlin+3
SELE 4
do while !eof()  
  SELE 1
     SEEK LEFT(d->Is_CODE,2)
  SELE 4
     @ mlin,2 say chr(15)+ a->a_desc
     @ mlin,41 say chr(15)+ Str(abs(BALAN),19,2)
     mlin=mlin+1
     LTOT=LTOT+ABS(BALAN)
     skip
 enddo
 @ mlin,41 say chr(15)+ repli(chr(205),19)
 mlin=mlin+1
  @ MLIN,2 say chr(15)+ " T O T A L "
  @ MLIN,41 say chr(15)+ Str(abs(LTOT),19,2)
    MLIN=MLIN+2
         @ mlin,10 say chr(15)+ "    A S S E T S "
         @ MLIN+1,0 say chr(15)+   repli(chr(196),60)

       TOT=0
       MLIN=MLIN+2
     
SELE 3
go top
LTOT=0

 do while !eof() 
     SELE 1
       SEEK LEFT(C->Is_CODE,2)
     SELE 3
       @ mlin,2 say chr(15)+ a->a_desc
       @ mlin,41 say chr(15)+ Str(abs(BALAN),19,2)
       mlin=mlin+1
       LTOT=LTOT+ABS(BALAN)
      SKIP
   ENDDO         







      @ mlin,41 say chr(15)+ repli(chr(205),19)
       MLIN=MLIN+1
        @ MLIN,2 say chr(15)+ " T O T A L "
         @ MLIN,41 say chr(15)+ Str(abs(LTOT),19,2)
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
 @ 1,5 say  "       S I M I L I A  H O M O E O  L A B O R A T O R Y   "
 @ 2,20 say "       balance  sheet       "
 @ 3,20 say "   from    " +dtoc(is_fin())+" to "+DTOC(DATE())
 @ 4,0 SAY REPLI(chr(205),61)
 @ 6,0 SAY REPLI (chr(205),61)
 RETU 0



