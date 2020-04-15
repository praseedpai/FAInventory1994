set key 27 to
VMA=SAVESCREEN(10,10,16,40)
@ 10,10 TO 16,40
SET COLO TO G/B
@ 11,11 CLEA TO 15,39
SET COLO TO N/W
@ 13,16 SAY "  DON'T INTERRUPT  "


Use stock\cstock
Pack
index on rcode to stock\cstock

Use stock\rstock
Pack
index on rcode to stock\rstock

use stock\csub
Pack
index on code to stock\csub

use stock\rsub

Pack

index on code to stock\rsub
use stock\C_head
Pack

index on code to stock\C_head
use stock\R_head
Pack

index on code to stock\R_head

use stock\E_head
Pack

index on code to stock\E_head


Use stock\cstocktr 
Pack
index on tno to  stock\cstocktr
index on tcode to stock\cst1

Use stock\rstocktr 
pack
index on tno to  stock\rstocktr
index on tcode to stock\rst1
Use stock\estocktr 
Pack
index on tno to stock\estocktr
index on tcode to stock\est1

Use stock\e_subhea
Pack
index on str(S_pack1,5)+S_code to stock\e_sub1
index on str(S_pack2,5)+S_code to stock\e_sub2
index on str(S_pack3,5)+S_code to stock\e_sub3
index on S_code to stock\e_subhea

use stock\invoice
pack
index on  invno to stock\invoice
index on Party_cd+dtos(invdate) to stock\invoice1
Use stock\stock
Pack
index on it_code to stock\stock
for i=1 to 12
   fil="stock\"+"inv"+iif(i<=9,'0'+str(i,1),str(i,2))
    if !file(fil+".dbf")
       exit
    endif
    use &fil
    pack
   index on invno to &fil

next 

use stock\dealer 
pack
index on dlr_code to stock\dealer


CLOSE ALL
*-----------------------------------
SET COLO TO
RESTSCREEN(10,10,15,40,VMA)
retu