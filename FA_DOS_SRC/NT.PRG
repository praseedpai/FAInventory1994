

*------ Clear Stock File  of Container

use stock\cstock
replace rqty with 0


*------ Clear Stock File of  Raw Material

use stock\rstock
replace rqty with 0


*-------- Clear Stock File of End Product

use stock\stock
replace it_qty with 0


*---------

Use stock\Estocktr
zap

use stock\CStocktr
zap

use stock\Rstocktr
zap

Use stock\invoice
zap




