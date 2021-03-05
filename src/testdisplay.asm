
INCLUDE "defs.asm"

#define blockchars 1

;------------------------------------------------------------
; code starts here and gets added to the end of the REM
;------------------------------------------------------------

PUBLIC testdisplay
EXTERN rand
EXTERN seed

testdisplay:
    ld   a,(frames)
    ld   (seed), a

    ld   hl,(d_file)
    inc  hl

    ld   b, n_rows - 2                  ; rows

rowloop:
    push bc

if blockchars
    ld   a, n_blockchars
else
    ld   a, n_uniquechars
endif

    ld   b, n_columns                    ; columns
    call colloop

    inc  hl

    pop  bc

    djnz rowloop

    ret

colloop:
    ld   c, a
loop1:
    push bc
    call rand
    pop  bc
    ld   (hl), a
    inc  hl
    ld   a, c
    djnz loop1
    ret
