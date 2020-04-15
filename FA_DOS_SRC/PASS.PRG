PARAM TIM
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
     SET COLO TO W/N
  if charnot(cstring)=="ß¹°°³ß"
       @ 10,10 SAY " CORRECT PASSWORD "
         RETU
   ELSE
      @ 11,10 SAY  " INCORRECT        "
      RETU
  ENDIF