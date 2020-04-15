
FUNCTION BROW
param foo
SELE 0
use data\text
KS=SAVESCREEN(1,0,24,78)
 if !file(foo)
   retu 0
 endif
clear
zap
append from &foo sdf
go top
@ 1,0 to 24,78 double
SET COLO TO G/W
@ 2,12 say " S I M I L I A  H O M O E O   L A B O R A T O R Y "
SET COLO TO
dbedit(3,1,23,77,"","RAPPY","","","_","","","")
USE
RESTSCREEN(1,0,24,78,KS)
RETU 0
*--------------------------------------------------
  FUNC RAPPY
    PARAM SN,FO
     IF LASTKEY()=-9
       RETU 0
     ELSE
      RETU 1
     ENDIF
