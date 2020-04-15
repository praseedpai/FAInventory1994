CLEAR

SELE 1
USE \SIMI\DATA\BAL_LEDG.DBF
SELE 2
USE \SIMI\DATA\SGROUP.DBF
DO WHILE !EOF()
  SELE 1
  APPEND BLANK
  REPLACE IS_CODE WITH b->S_CODE
  SELE 2
  SKIP
ENDDO
