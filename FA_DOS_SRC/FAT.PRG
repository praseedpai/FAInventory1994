*--------------- Program to Transfer Accounts 

!Del Data\*.ntx
use data\narr
zap

use data\group
  go top
   
    for i=1 to reccount()
       Replace A_CurrBal with 0
       skip      
next

 use data\sgroup
    
   
    for i=1 to reccount()
       Replace S_OPBAL with  0
       skip
    next
  close all 
use data\ban
    
 
    for i=1 to reccount()
       Replace S_OPbal with 0
       skip
    next
  cloSE ALL
  
USE DATA\LEDGER
ZAP
USE DATA\JOURNAL
ZAP

USE DATA\BAL_LEDG
GO TOP

  fOR I=1 TO RECCOUNT()
     fOR J=2 TO fCOUNT()
        g=fIELD(J)
        rEPLACE &g WITH 0.0
     NEXT
     SKIP
   NEXT

   
  
 
     