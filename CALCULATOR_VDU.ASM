;MAIN  
CLO
MOV BL,B0 ; MEMORY
CALL 8A  ;INPUT
;----------------
MOV DL,[B1] ; SIGN
MOV AL,[B0] ; NUMBER 1
MOV BL,[B2] ; NUMBER 2
;----------------
SUB AL,30 ; TO GET CORRECT NUMBER
SUB BL,30
;-----SIGN CHECK---
CMP DL,2B ; +
JZ PLUS   ;IF SIGN +

CMP DL,2D ; - 
JZ MINUS  ;IF SIGN - 

CMP DL,2A ; *
JZ MULTI  ;IF SIGN *

CMP DL,2F ; /
JZ DIVID  ;IF SIGN /
;=================
JMP STOPP ; IF NO SIGN

PLUS:
  ADD AL,BL
  JMP CONTROL

MINUS:
  SUB AL,BL
  JS NEGAT ; S=1=NEGATIVE RESULT
  CALL A8
  HALT

MULTI:
  MUL AL,BL
  JMP CONTROL

DIVID:
  DIV AL,BL
  CALL A8
  HALT

NEGAT:          ;NEGATIVE RESULT
  MOV AL,[B2] ; NUMBER 2
  MOV BL,[B0] ; NUMBER 1
  SUB AL,30 ; TO GET CORRECT NUMBER
  SUB BL,30
  SUB AL,BL ;NUM2-NUM1=POSITIVE RESULT
  MOV CL,2D ; MINUS SIGN
  MOV [C0],CL ; OUTPUT -
  CALL A8 ; OUTPUT NUMBER
HALT 

CONTROL:
MOV [B4],AL
CMP AL,0A  ; 9-10= -1 , 10-10= +0 , 24-10= +14
JS OUPUT   ; IF AL 0-9
DIV AL,0A  ; IF AL 10-99, 24/10= 2 NUMBER OF TENS
MOV [B5],AL  
MUL AL,0A  ; 2*10= 20
MOV BL,[B4]
SUB BL,AL  ; 24-20= 4 NUMBER OF UNITS
PUSH BL
MOV AL,[B5]
ADD AL,30
MOV [C0],AL  ; VDU
POP AL
ADD AL,30
MOV [C1],AL
HALT  ; PRESS CPU RESET


OUPUT:
  CALL A8

STOPP:
  HALT

;---INPUT---
ORG 8A
;PUSH AL
;PUSH BL
PUSHF
MOV CL,3  ; COUNTER

REP:
  IN 00
  MOV [BL],AL
  INC BL
  DEC CL

JNZ REP ; IF CL=0 STOP

STOP:
  MOV AL,0
  MOV [BL],AL

  POPF
  ;POP BL
  ;POP AL
  RET
;----OUTPUT VDU----
ORG A8
ADD AL,30 ; TO GET CORRECT SIGN CODE
MOV [C1],AL

RET

; PRESS CPU RESET

END