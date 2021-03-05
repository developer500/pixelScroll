
PUBLIC rand
PUBLIC seed


; trashes de
rand:
    ld   e,a                    ; e is required for getMod - will be 28 here
    call rand255                ; a = rand 255 #
    ld   d,a                    ; d = rand 255 #
    call getMod                 ; a = d mod e

; move this - adds 78 to make block char
    cp   8
    jr   c, skip1
    add  $78
skip1:

    ret

getMod:
; Integer divides D by E
; Result in D, remainder in A
; Clobbers F, B
    xor  a
    ld   b,8
loopM:
    sla  d
    rla
    cp   e
    jr   c,loopP
    sub  e
    inc  d
loopP:
    djnz loopM
    ret


rand255:
; trashes b

    ld   a,(seed)
    ld   b,a

    rrca                        ; multiply by 32
    rrca
    rrca
    xor  0x1f

    add  a,b
    sbc  a,255                  ; carry

    ld   (seed),a
    ret

seed:
    defb $00
