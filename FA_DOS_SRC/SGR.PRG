* PROGRAM TO EDIT SUBROUP ITEM
* THREE PARAMETERS ADD CHANGE DELETE EXTIT
* PROGRAM  TO EDIT GROUP HEADS
 Param _what
*---------------use the data file
SELE 1
 USE data\group INDEX data\group
SELE 2
 USE data\sgroup INDEX data\sgroup,data\sgr1
sele 3
 use data\bal_ledg inde data\BAL_ledg
Set score off
SELE 1
public _goo
tmapa=SAVESCREEN(2,5,18,70)
  @ 3,6 TO 17,69 DOUBLE
  Set colo to n/w
  @ 4,7 clea to 4,68
  @ 4,10 say "                   Subgroups "+iif(_what=="A"," Addition ",iif(_what=="C"," Change "," Deletion"))
  set colo to
  @ 5,7 say repli(chr(205),62)
  scroll(6,7,16,68,0)
  @ 7,8 SAY  " Code            "
  @ 10,8 say " Descr           "
  @ 13,8 say " OP BALANCE      "
  @ 16,8 SAY " DR /CR          "

PRIVATE _pool[5]
_pool[1]=SPACE(5)
_pool[2]=SPACE(35)
_pool[3]=0.00
_pool[4]=SPACE(1)
_pool[5]=0.00
SET COLO TO /W+,W+/N
SET KEY 27 TO ESC_PROC
_ksu= iif(_what=="A","Code_h","munc_h")
      set colo to w+/n+,n/w,,,w+/n+
 BEGIN SEQUENCE
    Do  WHILE .T.
    set key 28 to &_ksu
       @ 7,25  GET _pool[1]
       READ
        if  VAL(_pool[1])<=99
            err_msg(" INVALID CODE ")
            LOOP
        ENDIF
      SELE 1
      SEEK LEFT(_pool[1],2)
        IF !FOUND()
          ERR_MSG(" GROUP HEAD ERROR ")
          LOOP
       ENDIF
       SELE 2
        SEEK _pool[1]
         IF (_WHAT="A" .AND. FOUND())
            ERR_MSG(" DUPLICATION ")
            LOOP
         ELSEIF (_WHAT$"CD" .AND. !FOUND())
            ERR_MSG(" INVALID CODE    ")
            LOOP
         ENDIF
         set key 28 to
           IF _WHAT=="D"
             SELE 3
             SEEK _POOL[1]
             RMK=MONTH(DATE())
             RMK=IIF(RMK>=4 .AND. RMK<=12,RMK-3,RMK+9)
             RAP='MONTH'+IIF(RMK<9,"0"+STR(RMK,1),STR(RMK,2))
             IF &RAP<>0
               ERR_MSG(" CANNOT DELETE ")
               SELE 2
                LOOP
              ENDIF
              SELE 2
              ENDIF

         IF _WHAT$"CD"
           _pool[2]=S_DESC
           _pool[3]=S_OPBAL
           _pool[4]=S_DRCR
           ORG_BAL=S_OPBAL
           ORG_DRCR=S_DRCR
               @ 10,25 say  _pool[2]
               @ 13,25 say  _pool[3]
               @ 16,25 say  _pool[4]
         ENDIF
                   IF _WHAT="D"
                     if (chr(err_msg(" CONFIRM (Y/N) "))$"yY")
                         REPLACE S_CODE WITH "#####",s_desc with space(25)
                         Delete
                         rf=select()
                         Sele 3
                         seek _pool[1]
                         replace is_code with "#####"
                         delete
                      ENDIF
                      LOOP
                  ENDIF
            @ 10,25 GET _pool[2]
            READ
              IF (_pool[2]=SPACE(25) )
                ERR_MSG("INVALID ITEM ")
                KEYB CHR(13)
                LOOP
              ENDIF
               @13,25 GET _pool[3]
               READ
                IF (_pool[3]<0)
                    ERR_MSG("INVALID AMOUNT ")
                    KEYB CHR(13)
                    LOOP
                ENDIF

                 KEYB SAMENU()
                 @ 16,25 GET _pool[4]
                 READ

         IF CHR(ERR_MSG("CONFIRM (Y/N) "))$"Yy"
                    IF (_WHAT="A")
                          SEEK "####"
                            IF !FOUND()
                              appen blank
                              Else
                              Recall
                           ENDIF
                    ENDIF
                          REPLACE S_CODE WITH _pool[1]
                          REPLACE S_DESC WITH _pool[2]
                          REPLACE S_TYPE WITH A->A_TYPE
                          REPLACE S_OPBAL WITH _pool[3]
                          REPLACE S_DRCR WITH _pool[4]
                          REPLACE S_FLAG WITH .T.
                            sele 3

               if _what="A"
                     seek "#####"
                          if !found()
                            appen blank
                            Else
                            Recall
                          endif
                      replace is_code with _pool[1]
                      RMK=MONTH(DATE())

                      RMK=IIF(RMK>=4 .AND. RMK<=12,RMK-3,RMK+9)
                     
                   FOR I=0 TO RMK
                       CRP='MONTH'+IIF(I<=9,'0'+STR(I,1),STR(I,2))
                       REPL &CRP WITH iif(_pool[4]="D",_pool[3],-_pool[3])
                   NEXT I
                  ELSEIF _WHAT$"cC"
                        seek _pool[1]
                        RMK=MONTH(DATE())
                        RMK=IIF(RMK>=4 .AND. RMK<=12,RMK-3,RMK+9)
                        for i=0 to rmk
                          CRP='MONTH'+IIF(I<=9,'0'+STR(I,1),STR(I,2))      
                           repl &crp with &crp +if(org_DRCR=="D",-org_bal,org_bal)
                        next i
           
                   FOR I=0 TO RMK
                        CRP='MONTH'+IIF(I<=9,'0'+STR(I,1),STR(I,2))
                        REPL &CRP WITH &crp+iif(_pool[4]="D",_pool[3],-_pool[3])
                     NEXT I


             endif

                          sele 2

                     ENDIF

              ENDdo
    END
 close all
set key 27 to
set key 28 to
RESTSCREEN(4,5,18,65,tmapa)

retu
*--------------------- Function for code_help
 FUNCTION SAMENU
  SDpa=SAVESCREEN(15,0,16,79)
SET COLO TO W/N
  DO WHILE .T.
  set inten on
  @ 16,25 PROMPT "dEBIT"
  @ 16,35 PROMPT "cREDIT"
  MENU TO Kir
   IF (Kir=0)
     LOOP
   ENDIF
   exit
   ENDDO
   RESTSCREEN(15,0,16,79,SDpa)
   RETURN IF(Kir=1,"D","C")

 *----------------------------------------------
 *------------------------------------------------------------------------
* Program to print ledger balance for
*-------------------------------------------------
    PROC munc_H
    PRIVATE FIL[2],SAMP[2]
    Set key 27 to
     fil[1]="S_code"
     FIL[2]="S_desc"
     samp[1]=" CODE  "
     SAMP[2]="  DESCRIPTION  "
      xf=savescreen(4,9,23,61)
      public foo
      foo=""
       set key 28 to
         sele 2
         set order to 2
           Set SoftSeek on
         mk=setcolor()
          setcolor("/w+,w+/n ")
          @ 4,9 to 21,61 double
           dbedit(5,10,20,60,fil,"dUNCR","",samp)
            setcolor(mk)
            set order to 1 
                Set softSeek off
            Set key 27 to Esc_proc
           set key 28 to Munc_H
          restscreen(4,9,23,61,xf)
          release xf

function dUNCR
 param dfg,klm
   kes=lastkey()
 do case
    case kes=13
      KEYB b->s_code
      RETURN 0
    case KES=27
      RETURN 0
     CASE kes>=32
        FOO=FOO+upper(CHR(KES))
      CASE KES==8
        FOO=SUBSTR(FOO,1,LEN(FOO)-1)
      OTHERWISE
       RETU 1
     ENDCASE
      @ 22,9 SAY SPACE(52)
      @ 22,9 SAY FOO
         set softseek on
            seek foo
         set softseek off
            keyb chr(0)
           return 2 
*--------------------------------------------------
