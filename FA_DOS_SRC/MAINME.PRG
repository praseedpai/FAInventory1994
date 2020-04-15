clear
set talk off
set stat off
@ 1,0 say repli(chr(205),80)
 @ 3,0 say repli(chr(205),80)
set colo to w/w
@ 4,0,24,79 box repli (chr(219),9)
set colo to
 do while .t.
 @ 2,5 PROMPT   " Accounts  "
 @ 2,25 PROMPT  " Inventory "
 @ 2,45 PROMPT  " Utilities "
 @ 2,65 prompt  " Exit      "

 MENU TO K
  do case
    case k=4
    clear screen
    clear all
    close all
      retu
   endcase


enddo
