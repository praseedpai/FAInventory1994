CLEAR

!dEL STOCK\*.NTX
USE STOCK\INV01
ZAP
  
FOR I=2 TO 12
   SD = "STOCK\INV"+IIF(I<=9,'0'+STR(I,1),STR(I,2))+".dbf"
  DELETE FILE (SD)
NEXT
 
use stock\pur
zap

use stock\rstock

  for i=1 to reccount()
    replace rqty with 0.00
    skip
  next

use stock\rstocktr
zap
use stock\cstocktr
zap

use stock\estocktr
zap
  
use stock\cstock
  
  for i=1 to reccount()
    replace rqty with 0.00
    skip
  next

use stock\stock

  
  for i=1 to reccount()
    replace it_qty with 0.00
    skip
  next

use stock\invoice
zap



  
   
