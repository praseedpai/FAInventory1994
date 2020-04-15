* Program to print dealer code
*
* date written 29-03-1995
*
******************************************************************
Sele 1
Use stock\dealer

index on dlr_code to drt
 go top
 set device to printer
 set printer to rt.txt
  mlin=5
 bhead()
  Do while !EOf()
   @ mlin,1 Say Dlr_Name
   @ mlin,35 say Dlr_COde
   @ mlin,42 say Dlr_ADD1
   skip
    mlin=mlin+1 
    if mlin>60
         mlin=3
         eject
         bhead()  
     endif
  Enddo
  
set device to screen
set printer to
 brow("RT.TXT")

Function bhead
@ 1,1 say   "     DEALER NAME               CODE                   ADDRESS     "
@ 2,1 say "----------------------------------------------------------------------"
return 0  


    