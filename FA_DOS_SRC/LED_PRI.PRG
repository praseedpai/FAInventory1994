*------------------------------------------------------------------------
* Program to print ledger balance for
*-------------------------------------------------

lgfi=""
set key 27 to esc_proc
fir=iif(month(date())<=9,'0'+str(month(date()),1),str(month(date()),2))+str(year(date())%100,2)
lgfi="data\"+"lg"+fir
lgfi1="data\"+'A'+'lg'+fir
lgfi2="data\"+'B'+'lg'+fir
lgfi3="data\"+'J'+'lg'+fir
jfi="data\"+"jg"+fir
set date brit
sele 1
use &lgfi index &lgfi1,&lgfi2

sele 2
use data\sgroup index data\sgroup
clear
sele 3
use ld
zap
code=space(5)
fri=ctod("")
to=date()
 @ 10,10 say "Code " get code
 read
 @ 11,10 say " from " get fri
 read
 @ 12,10 say " to   " get to
 read

  Do while fri<=to
  sele 1
   set order to 1
   seek dtoc(fri)+code
     if found()
       Do while jdate==fri .and. ac_1==code .and. !eof()
         sele 3
         appen blank
           Replace date with a->jdate
           sele 2
           seek a->ac_2
           sele 3
           replace desc with "To "+b->S_desc
           replace amount with a->amount
         sele 1
          skip
        enddo
    endif
  set order to 2
 seek dtoc(fri)+code
     if found()
       Do while jdate==fri .and. ac_2==code .and. !eof()
         sele 3
         appen blank
           Replace date with a->jdate
           sele 2
           seek a->ac_1
           sele 3
           replace desc with "By "+b->S_desc
           replace amount1 with a->amount
         sele 1
          skip
        enddo
    endif
 fri= fri +1

enddo
sele 3
clear
dbedit()