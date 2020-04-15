*--------------------- proc to edit headcodes--------------------
*-- headedit <param>
*-- <param>:: A|C|D
param mode_l
  sele 1
    use  stock\e_head index stock\e_head
   sele 2
    use stock\e_subhea index stock\e_subhea,stock\e_sub1,stock\e_sub2,stock\e_sub3
set deleted on
 DECLARE ED[3]
 ED[1]=SPACE(2)
 ED[2]=SPACE(35)
 ED[3]=SPACE(2)
 SELE 1
 @ 10,15 to 23,75 double
 @ 11,16 clea to 22,74
 SET COLO TO /W
 @ 11,16 SAY SPACE(59)
 @ 11,30 SAY "GROUP HEADS "+IIF(MODE_L=="A","ADDITION",IIF(MODE_L=="C","CHANGE","DELETION"))
 @ 22,16 SAY SPACE(59)
 @ 22,16 SAY "   Esc - CANCEL & RETURN TO PREV.  F1-codelist          "

  SET COLO TO
   @ 12,16 SAY REPLI(CHR(205),59)

   @ 14,18 say " CODE      "
   @ 16,18 say " DESCR.    "
   @ 18,18 say " UNIT      "
   @ 20,16 SAY REPLI (CHR(205),59)
*-----------------start of main loop
*-----------------
SET KEY 27 TO ESC_PROC
BEGIN SEQUENCE
  do while .T.
  set key 28 to model_h
    @ 14,38  GET ED[1]  pict "!!" valid good(ed[1],mode_l)
    READ
   Set key 28 to
         IF MODE_L$"CD"
                 ED[2]=DESC
                 ED[3]=UNIT
                 @ 16,38 SAY ED[2]
                 @ 18,38 SAY ED[3]
                      if mode_l="D"
                          if (chr(err_msg(" confirm(y/n) "))$"Yy")
                               sele 2
                               locate for substr(s_code,1,2)=ed[1]
                                 if found()
                                    err_msg(" CANNOT DELETE THIS HEAD ")
                                    SELE 1
                                    LOOP
                                 ENDIF
                             SELE 1
                             replace code with "##",desc with space(35),unit with "  "
                             delete
                             loop
                      endif
                          loop
                       endif
                          ENDIF


              @ 16,38   GET ED[2] PICT "@!"
               read
                   IF ED[2]=SPACE(35)
                      ERR_MSG(" BLANK ITEM NOT ALLOWED ")
                      KEYBOARD CHR(13)
                      LOOP
                  ENDIF
                 @ 18,38   GET ED[3] PICT "@!"
                  READ
                     IF (.not.(ED[3] =="GM" .OR. ED[3]=="ML" .OR. ED[3]=="NO"))
                           err_msg("CHOOSE BET'N  <GM |  ML | NO > ")
                           keyboard chr(13)+chr(13)
                           loop
                     ENDIF
                          IF (CHR(ERR_MSG(" confirm(y/n) "))$"Yy")
                                 if mode_l="A"
                                    locate for deleted()
                                        if !found()
                                           appen blank
                                          else
                                          Recall
                                      endif
                                 endif
                                 for i=1 to fcount()
                                   df=field(i)
                                   replace &df with ed[i]
                                 NEXT I
                            ENDIF

          ENDDO
     END
   SET KEY 28 TO
  set key 27 to
     CLOSE ALL
     RETURN

*-------------- function good
funCtion good
param s,mo
if (at(' ',s)>0) .or. s='  '
err_msg('INVALID DATA  ')
  return .f.
endif
seek s
Do case
  case mo="A" .and. found()
      ERR_MSG(" CODE ALREADY EXISTS  ")
      RETURN .F.
  CASE MO$"CD" .AND. !FOUND()
      ERR_MSG("  CODE DOESN'T EXISTS ")
      RETURN .F.
   OTHERWISE
      RETURN .T.
 ENDCASE






 proc model_h
  private fil[2],samp[2]
  Set key 27 to
  fil[1]="code"
  fil[2]="desc"
  samp[1]=" code  "
  samp[2]="  description  "
  xf=savescreen(4,9,23,61)
    public foo
    foo=""
       set key 28 to
         RSE=SELECT()
         sele 1
         RS_1=SETCOLOR("/W+,W+/N")
          @ 4,9 to 21,61 double
           dbedit(5,10,20,60,fil,"muncr2","",samp)
            set colo to w+/n,n/w+
    set key 27 to Esc_proc
    set key 28 to model_h
         SELECT(RSE)
          SETCOLOR(RS_1)
          restscreen(4,9,23,61,xf)
            release foo
           release xf

   *-----------------------------------------
   *----------------------function func_r
function muncr2
param dfg,klm
   kes=lastkey()
  do case

  case kes=13
     keyb A->Code
       return 0
  case kes=27
      return 0
  case kes>=32
       foo=foo+upper(chr(kes))
  case kes==8
       foo=substr(foo,1,len(foo)-1)
   otherwise
      retu 1
   endcase

      @ 22,9 say space(52)
      @ 22,9 say foo
        set softseek on
           seek foo
         set softseek off
           keyb chr(0)

    return 2
