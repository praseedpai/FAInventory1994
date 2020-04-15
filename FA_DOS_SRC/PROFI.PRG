* program to print profit & loss a/c
* only a try if succesfull great benefit
* date written -12/01/95
*---------------------------------------------
******************* use the data file
sele 1
use data\sgroup index data\sgroup
sele 2
use data\bal_ledg index data\bal_ledg
 copy to tempo for val(substr(is_code,1,2)) >84
   sele 3
    use tempo
     go top
   sele 2
   BEGIN SEQUENCE
       MHIFI=MONTH(DATE())
       MHIFI=IIF(MHIFI>=4 .AND. MHIFI<=12,MHIFI-3,MHIFI+9)
       RAP='MONTH'+iif(mhifi<=9,'0'+STR(mhifi,1),str(mhifi,2))
    mlin=7
    set device to printer
    set printer to fool.prn
    m_HEAD()
  sele 2
  LOCATE FOR VAL(IS_CODE)>50000
 still=.f.
 drtot=0
 crtot=0

   do while  .t.
     if  (val(substr(is_code,1,2))<=59) .and. !eof()
            sele 1
             seek b->is_code
            sele 2
          if &rap>=0
             @ mlin,2 say "To " +substr(a->s_desc,1,30)
             @ mlin,40 say   chr(179)
             @ mlin,41 say   &rap  pict "@z99999999999999.99"
             @ mlin,60 say   chr(179)
             drtot=drtot+&rap
         else
            @ mlin,40 say   chr(179)
            @ mlin,60 say   chr(179)
            @ mlin,61 say "By "+substr(a->s_desc,1,30)
            @ MLIN,99 SAY CHR(179)
             @ mlin,100 say   abs(&rap)  pict "@z99999999999999.99"
            @ mlin,120 say  chr(179)
            crtot=crtot+abs(&rap)
           sele 2
           skip
           MLIN=MLIN+1
           loop
      endif
   endif
         cf=recno()
            if .not.still
                 sele 1
                   seek c->is_code
                 sele 2
                   seek c->is_code
               if &rap<=0
                   @ mlin,61 say " By " +substr(a->s_desc,1,30)
                   @ mlin,99 say   chr(179)
                   @ mlin,100 say   abs(&rap)  pict "@Z99999999999999.99"
                   @ mlin,120 say  chr(179)
                   crtot=crtot+ abs(&rap)
                   sele 3
                    skip
                else
                   @ mlin,2 say "To " +substr(a->s_desc,1,30)
                   @ mlin,40 say   chr(179)
                   @ mlin,41 say   &rap  pict "@z99999999999999.99"
                   @ mlin,60 say  chr(179)
                   drtot=drtot+&rap
                    sele 3
                    skip
                endif
                    if eof() .or. val(substr(is_code,1,2))>92
                      still=.t.
                     endif
           else
                       @ mlin,99 say   chr(179)
                       @ mlin,120 say  chr(179)
          endif
              sele 2
              goto cf
            mlin=mlin+1
            skip
            if still .and. (eof())
              exit
            endif
  enddo
   sele 3
     savcr=recno()
   sele 2
   saverec=recno()

 carried= drtot<crtot

   IF DRTOT <CRTOT
      @ mlin,2 say " TO balance c/d "
      @ mlin,41 say cRTOT-DRTOT PICT "99999999999999.99"
   ELSE
      @ mlin,62 say " BY balance c/d "
      @ mlin,101 say dRTOT-cRTOT PICT "99999999999999.99"
  ENDIF
     MLIN=MLIN+1
      @ MLIN,42  SAY REPLI(CHR(205),20)
      @ MLIN, 100 SAY REPLI(CHR(205),20)
      MLIN=MLIN+1

      @ mlin,2 SAY  " T O T A L "
      @ MLIN,42 SAY MAX(DRTOT,CRTOT) PICT  "99999999999999.99"
      @ MLIN,62 SAY " T O T A L "
      @ MLIN,100 SAY MAX(DRTOT,CRTOT)  PICT "99999999999999.99"
       MLIN=MLIN+1
        @ MLIN,42  SAY REPLI(CHR(205),20)
      @ MLIN, 100 SAY REPLI(CHR(205),20)
      MLIN=MLIN+2
        profit=abs(crtot-drtot)
      store 0 to drtot1,crtot1
      IF DRTOT <CRTOT
          @ MLIN,62 SAY " BY BALANCE B/D "
          @ MLIN,100 SAY  profit PICT "99999999999999.99"
           crtot1=profit
      ELSE
         @ MLIN,2 SAY " TO BALANCE B/D "
         @ MLIN,41 SAY profit PICT "99999999999999.99"
        drtot1=profit
     ENDIF
       still=.f.
        sele 3
         goto savcr
        sele 2
          goto saverec
         locate for val(substr(is_code,1,2))>=60

         do while .t.
           if   !eof() .and. val(subs(is_code,1,2))<=84
                 sele 1
                  seek b->is_code
                 sele 2
               if &rap>=0
                 @ mlin,2 say "To " +substr(a->s_desc,1,30)
                 @ mlin,40 say   chr(179)
                 @ mlin,41 say   &rap  pict "@Z99999999999999.99"
                 @ mlin,60 say  chr(179)
                   drtot1=drtot1+&rap
                 else
                    @ mlin,40 say chr(179)
                    @mlin,60 say chr(179)
                    @ mlin,61 say " By " +substr(a->s_desc,1,30)
                    @ mlin,99 say   chr(179)
                    @ mlin,100 say   abs(&rap)  pict "@Z99999999999999.99"
                    @ mlin,120 say  chr(179)
                   crtot1=crtot1+abs(&rap)
                   sele 2
                   skip
                   mlin=mlin+1
                   loop
             endif
           endif
           cf=recno()

              if .not.still
                    sele 1
                      seek c->is_code
                    sele 2
                      seek c->is_code
                    if &rap<=0
                      @ mlin,61  say " By " +substr(a->s_desc,1,30)
                      @ mlin,99  say   chr(179)
                      @ mlin,100 say   abs(&rap)  pict "@Z99999999999999.99"
                      @ mlin,120 say  chr(179)
                      crtot1=crtot1+abs(&rap)
                    else
                     @ mlin,40  say chr(179)
                     @ mlin,60  say chr(179)
                     @ mlin,61  say " By " +substr(a->s_desc,1,30)
                     @ mlin,99  say   chr(179)
                     @ mlin,100 say   abs(&rap)  pict "@Z99999999999999.99"
                     @ mlin,120 say  chr(179)
                     drtot1=drtot1+&rap
                     sele 2
                     skip
                     cf=recno()
                  endif
                    sele 3
                    skip
                   if eof()
                     still=.t.
                   endif
                 else
                        @ mlin,99 say   chr(179)
                        @ mlin,120 say  chr(179)
                  endif
                  sele 2
                   goto cf
                   skip
                       if eof() .and.   still
                        exit
                      endif
                enddo
     sele 2

IF DRTOT1 <CRTOT1
      @ mlin,2 say " TO net profit transfered "
      @ mlin,41 say CRTOT1-DRTOT1 PICT "99999999999999.99"
ELSE
      @ mlin,62 say " BY netloss transfered "
      @ mlin,101 say DRTOT1-crtot1 PICT "99999999999999.99"
ENDIF
     MLIN=MLIN+1
      @ MLIN,42  SAY REPLI(CHR(205),20)
      @ MLIN, 100 SAY REPLI(CHR(205),20)
      MLIN=MLIN+1

      @ mlin,2 SAY  " T O T A L "
      @ MLIN,42 SAY MAX(DRTOT1,CRTOT1) PICT  "99999999999999.99"
      @ MLIN,62 SAY " T O T A L "
      @ MLIN,100 SAY MAX(DRTOT1,CRTOT1)  PICT "99999999999999.99"
       MLIN=MLIN+1
        @ MLIN,42  SAY REPLI(CHR(205),20)
      @ MLIN, 100 SAY REPLI(CHR(205),20)

 set device to screen
 set printer to

 brow("fool.prn")
do balan with crtot1-drtot1
END
close all
retu


FUNCTION m_HEAD
 @ 1,5 say "       S I M I L I A  H O M O E O  L A B O R A T E R I E S   "
 @ 2,20 say "       Trading,Profit & LOSS A/C       "
 @ 3,20 say "   from    " +"01/04/94"+" to "+DTOC(DATE())
 @ 4,0 SAY REPLI(chr(205),130)
 @ 6,0 SAY REPLI (chr(205),130)
 RETU 0



