* PROGRAM TO REGENERATE INDEX FILES
* IF CORUPTED WILL BE REMADE
* --------------------------------------------------
USE DATA\JOURNAL
ZAP
INDEX ON J_ID TO DATA\JOURNAL
*---------------------------------------------------
USE DATA\LEDGER
ZAP
INDEX ON DTOs(JDATE)+AC_1 TO DATA\LEDGER1
INDEX ON DTOs(JDATE)+AC_2 TO DATA\LEDGER2
INDEX ON JID TO DATA\LEDGER3
*----------------------------------------------------
 USE DATA\GROUP
* ZAP
INDEX  ON A_CODE TO DATA\GROUP
*--------------------------------------------
 USE data\sgroup index data\sgroup
 *ZAP
index on s_code to data\sgroup
*------------------------------------------
use data\bal_ledg
* ZAP
index  on is_code to data\bal_ledg
*----------------------------------------

