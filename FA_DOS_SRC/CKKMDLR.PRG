*******************************************************************
*     PROGRAM :TO UPDATE CKKMDEALERS                               *
*     DATE WRITTEN:19/04/94                                        *
*********************************************************************
Param Hmode
priva Mscr
BEGIN SEQUENCE
public Hmode
private DLR[9],mscr
*----------------------------------
 Store Space(30)  to DLR[2],DLR[3]
DLR[4]=space(25)
 STORE SPACE(6) TO DLR[5]
 Store Space(20) to DLR[6],DLR[7]
 Store Space(4)  to DLR[1]
 store space(3) to DLR[9]
 Store .T. to Pass
 stor space(1) to dlr[8]
*----------------------------------
 Sele 1
 Use stock\DEALER Inde stock\DEALER

*----------------------------------
*------------ Screen Section
mscr=savescreen(0,0,24,79)
Scroll(5,20,18,70,0)
sele 1
Scroll(24,0,24,79,0)
@ 5,20 to 18,70  double
set color to /w+
Do Case
   Case Hmode = 'A'
        @ 5,37 say ' Dealer Addition '
   Case Hmode = 'D'
        @ 5,37 say ' Dealer Deletion '
   Case Hmode = 'C'
        @ 5,37 say ' Dealer Updation '
Endcase
set color to w+
@ 5,54 say 'Ã'
@ 5,36 say  '´'
*--------------------------------------
@ 07,26 Say 'Dealer Code  :'
@ 08,26 Say 'Name         :'
@ 09,26 Say 'Address      :'
@ 10,26 Say 'City         :'
@ 11,26 SAY 'Pin          :'
@ 12,26 SAY 'CST No       :'
@ 13,26 SAY 'KGST No      :'
@ 14,26 SAY 'State Status :'
@ 15,26 SAY 'Area Code    :'
set key 27 to esc_proc
set colo to w+/n+,n/w,,,w+/n+
Do While Pass
   Set key 28 to munc_s
   @ 07,42 Get DLR[1] Pict '@!' Valid MPheadVa(DLR[1])
   Read

   set key 28 to
         IF LEN(ALLTRIM(DLR[1])) !=4
             ERR_MSG("INVALID CODE ")
             LOOP
         ENDIF
   if hmode$'CD'
      FOR I=2 TO 9
          Fpos=FIELD(I)
          DLR[I]=&Fpos
          if hmode='D'
                @ i+5,42 say DLR[I]
         endif
      NEXT
   endif
   set colo to
   If Hmode != 'D'
      set colo to w+/n+,n/w,,,w+/n+
      @ 08,42  Get DLR[2] Pict '@s25!' Valid DLR[2] <> Space(30)
      @ 09,42  Get DLR[3] PICT '@S25!' Valid DLR[3] <> Space(30)
      @ 10,42  Get DLR[4] PICT '@!' Valid DLR[4] <> Space(25)
      @ 11,42  GET DLR[5] PICT '@!' VALID LEN(ALLTRIM(DLR[5]))=6 .AND. VAL(alltrim(DLR[5]))>0
      @ 12,42  GET DLR[6] PICT '@!' VALID DLR[6] <>SPACE(20)
      @ 13,42  GET DLR[7] PICT '@!' Valid DLR[7] <> Space(20)
      @ 14,42  GET DLR[8] PICT '!'  Valid Dlr[8] $ 'IO'
      @ 15,42  GET DLR[9] PICT '@!'  valid !(dlr[9]=space(3)) .and. isalpha(dlr[9])
      Read
      set colo to
      If Hmode = 'A'
         If !Found()
            Append Blank
         Endif
      Endif
      FOR I=1 TO 9
          Fpos=FIELD(I)
          Repl &Fpos WITH DLR[I]
      NEXT
   Else
      If Chr(ERR_MSG("CONFIRM(Y/N)"))$"Yy"
         Repl dlr_code With '####'
         delete
      Endif
   Endif
Enddo
END
SET KEY 27 TO
SET KEY 28 TO
Release all like dlr
close databases
restscreen(0,0,24,79,mscr)
release all like mscr
Retu
*----------------------------------------------------------

*------------ Main Heads Validation
Func MPheadVa
Param MhVal
if mhval='####' .or. mhval='    '
 return .f.
endif
Seek MhVal
  Do Case
     Case Found() .AND. Hmode = 'A'
          Err_MSG(" DUPLICATION ")
          return .f.
     Case !Found() .AND. Hmode$'CD'
          Err_MSG(" CODE NOT FOUND ")
          Retu  .F.
    Otherwise
         retu .T.
 EndCase
************************************************************************8
*-------------------------------------------------
    PROC munc_s
    Set key 27 to
     Set key 28 to
      xf=savescreen(4,9,23,61)
        public foo
        foo=""
         mk=setcolor("/w+,w+/n ")
          @ 4,9 to 21,61 double
           dbedit(5,10,20,60,"","summa")
            setcolor(mk)
            Set key 27 to Esc_proc
           set key 28 to Munc_s
          restscreen(4,9,23,61,xf)
          release xf

*--------------- Function summa
 func summa
  param dfg,klm
  kes=lastkey()
  do case
    case kes >=32
        foo=foo+upper(chr(kes))
    case kes=13
       keyb dlr_code  
       return 0
    Case kes=27
      return 0
   
    Case kes==8
       foo=Left(foo,len(foo)-1)
     otherwise
      retu 1
   endcase
       tm=len(foo)
        @ 22,9 say foo+space(52-tm)
        set softseek on
           seek foo
        set softseek off
        keyb chr(0)    
return 2

