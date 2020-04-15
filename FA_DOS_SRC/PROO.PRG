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
  im_head()
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
      @ mlin,2 say "To " +substr(a->s_desc,1,30)
      @ mlin,41 say   str(balan,19,2)
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
            @ mlin,62 say "BY " +substr(a->s_desc,1,30)
             @ mlin,101 say   Str(abs(Balan),19,2)
              crtot=crtot+abs(Balan)
                 skip
     endif

    mlin=mlin+1
    If mlin>64
        mlin=7
        eject
        im_head()
    endif
     if still1 .and. still
      exit
    endif
  Enddo
      if mlin>60
           mlin=7
           eject
           im_head()
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
             @ mlin,2 say "To " +substr(a->s_desc,1,30)
                @ mlin,41 say   str(Balan,19,2)
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
         @ mlin,62  say "By " +substr(a->s_desc,1,30)
         @ mlin,101 say   str(abs(Balan),19,2)
         crtot1=crtot1+abs(Balan)
            skip
        endif
        if still .and. still1
                exit
         endif
       enddo

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

retu


FUNCTION im_HEAD
 @ 1,5 say "       S I M I L I A   H O M O E O   L A B O R A T O R Y   "
 @ 2,20 say "       Trading,Profit & LOSS A/C       "
 @ 3,20 say "   from    " +dtoc(is_fin())+" to "+DTOC(DATE())
 @ 4,0 SAY REPLI(chr(205),120)
 @ 6,0 SAY REPLI (chr(205),120)
 RETU 0





