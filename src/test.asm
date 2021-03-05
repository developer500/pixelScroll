
EXTERN pixelScroll
EXTERN bottomrow

    
.st
    LD HL, bottomrow
    CALL RANDOM
	AND $1F
	LD DE,$00
	LD E,A
	ADD HL,DE  ;RANDOM POSITION

	CALL RANDOM
	rrc  a

    jp  c, j1
    ld  a, $01
    jp  j2
    .j1
    ld  a, $02
    .j2

    ld (hl), a

    push  hl
    call pixelScroll
    pop  hl
    xor  a
    ld (hl), a

    jp st
    
    ret

RANDOM:
;GENERATE RANDOMISH NUMBER INTO A REGISTER
	LD A,($4034)
	LD B,A
	LD A,(RNDSEED)
	ADD A,B
	LD B,A
	RRCA ; multiply by 32
	RRCA
	RRCA

	XOR $1F

	ADD A,B
	SBC A,$FF ; carry

	LD (RNDSEED),A

	RET  ;RANDOM


.RNDSEED
	defb $00
