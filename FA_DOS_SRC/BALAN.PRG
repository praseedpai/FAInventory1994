* program to print balance sheet
* summary  rest in schedules
*-----------------------------------------
param sn
sele 1
use data\group  index data\group
sele 2
 use data\bal_ledg index data\bal_ledg



MHIFI=MONTH(DATE())
MHIFI=IIF(MHIFI>=4 .AND. MHIFI<=12,MHIFI-3,MHIFI+9)
RAP='MONTH'+iif(mhifi<=9,'0'+STR(mhifi,1),str(mhifi,2))
 set device to printer
 set printer to fool.prn
 t_head()
  mlin=6
  @ mlin,10 say " L I A B I L I T I E S "
  @ MLIN+1,10 SAY  "_______________________"
  MLIN=MLIN+2
   sele 1
     go top

        TOT=sn
    sele 2
      sum  &rap to foo1 for substr(ltrim(is_code),1,2)=1
         tot=tot+foo1
         @ mlin,2 say a_desc
        @ mlin,40 say chr(179)
        @ mlin,41 say abs(tot) pict "@Z9999999999999.99"
            mlin=mlin+1
      sele 1
      locate for val(a_code)>1
do while !eof() .and.   val(a_code)<=24
       sele 2
       sum  &rap to foo1 for substr(ltrim(is_code),1,2)=a->a_code
       TOT=TOT+FOO1
       sele 1
        @ mlin,2 say a_desc
        @ mlin,40 say chr(179)
        @ mlin,41 say abs(foo1) pict "@Z9999999999999.99"
        mlin=mlin+1
        skip
    enddo
         @ MLIN,2 SAY " T O T A L "
         @ MLIN,41 SAY abs(TOT) PICT "@z9999999999999.99"
         MLIN=MLIN+1
         @ mlin,10 say "  A S S E T S "
         @ MLIN+1,10 SAY        "______________"

        SELE 1
       locate for val(a_code)>24
       TOT=0
       MLIN=MLIN+2
      do while !eof() .and. val(a_code)<=49
        sele 2
        sum  &rap to foo1 for substr(ltrim(is_code),1,2)=a->a_code
        TOT=TOT+FOO1
        sele 1
        @ mlin,2 say a_desc
        @ mlin,40 say chr(179)
        @ mlin,41 say abs(foo1) pict "@Z9999999999999.99"

         mlin=mlin+1
       skip
      enddo
       MLIN=MLIN+1
        @ MLIN,2 SAY " T O T A L "
         @ MLIN,41 SAY abs(TOT) PICT "@z9999999999999.99"
         MLIN=MLIN+1
   set device to screen
   set printer to
   brow("fool.prn")
close all
 retu






FUNCTION t_HEAD
 @ 1,5 say "       S I M I L I A  H O M O E O  L A B O R A T E R I E S   "
 @ 2,20 say "       balance  sheet       "
 @ 3,20 say "   from    " +"01/04/94"+" to "+DTOC(DATE())
 @ 4,0 SAY REPLI(chr(205),130)
 @ 6,0 SAY REPLI (chr(205),130)
 RETU 0



