* PROGRAM TO REGENERATE INDEX FILES
* IF CORUPTED WILL BE REMADE
* --------------------------------------------------
showbox()

USE DATA\JOURNAL 
PACK
INDEX ON J_ID TO DATA\JOURNAL
index on jcode+Dtos(jdate) to data\journal1
*---------------------------------------------------
USE DATA\LEDGER
pack
INDEX ON DTOS(JDATE)+AC_1 TO DATA\LEDGER1
INDEX ON DTOS(JDATE)+AC_2 TO DATA\LEDGER2
INDEX ON JID TO DATA\LEDGER3
index on ac_1+str(month(jdate),2) to Data\ledger4
index on ac_2+str(month(jdate),2) to Data\ledger5
*----------------------------------------------------
USE DATA\GROUP
pack
INDEX  ON A_CODE TO DATA\GROUP
*--------------------------------------------
USE data\sgroup 
pack
index on s_code to data\sgroup
index on s_desc to data\Sgr1
 copy to data\ban for val(s_code)>35001 .and. val(s_code)<=35099
*------------------------------------------
use data\bal_ledg
index  on is_code to data\bal_ledg

use data\narr
pack
index on jour_no to data\narr
*----------------------------------------

CLOSE ALL
*-----------------------------------
SET COLO TO
hidebox()


Function hidebox
RESTSCREEN(10,10,16,40,VMA)
release vma
Return 0


function showbox
public vma
VMA=SAVESCREEN(10,10,16,40)
@ 10,10 TO 16,40
rse=setcolor("G/B")
@ 11,11 CLEA TO 15,39
SET COLO TO N/W
@ 13,16 SAY "  DON'T INTERRUPT  "
setcolor(rse)
return 0