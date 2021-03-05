;#;include(`z88dk.m4')

; Scroll screen routine
;--------------------------------------------------

#define d_file $400C

#define dcols 32

#define cols 33
#define rows 24

define(`ev', 0)

define(`LD_DE_HL', `ld   d,h
    ld   e,l')

define(`CONV_16', `cp  8
    jp  c, format(`e%d', ev)
    ld  b, a
    ld  a, $`'8F
    sub b
format(`.e%d', ev)
    define(`ev', incr(ev))')

define(`CONV_16_AND_ROTATE', `CONV_16
    and $2
    $1
    $1')

define(`FOR_B',`ld  b, $1
$2:
    push bc')

define(`NEXT_B',`pop bc
    djnz $1')

PUBLIC pixelScroll
PUBLIC bottomrow

.pixelScroll

    ld   hl, (d_file)

    inc  hl

    LD_DE_HL

    ld   bc, cols
    add  hl, bc

    ; repeat the scroll for all rows.
    FOR_B(rows, loop2)

        ; have to account for the very bottom row.
        ld   a, b
        dec  a
        jp  nz, j1
        ld  hl, bottomrow
        .j1

        FOR_B(dcols, loop3)

            ld   a, (hl)

            or   a
            jp   z, j2
            CONV_16_AND_ROTATE(rla, $03)
            .j2

            ld   c, a
            
            ld   a, (de)
            or   c

            jp   z, j3
            ld   a, (de)

            CONV_16_AND_ROTATE(rra, $0C)

            ; This is the key instruction - or the current char with the one below
            or   c

            ; convert the combined value back to a zx81 block char
            CONV_16

            ; and save it back to the display.
            ld (de), a

            .j3

            inc de
            inc hl

        NEXT_B(loop3)

        ; account for the 33rd column
        inc de
        inc hl

    NEXT_B(loop2)

    ret

    ; the bottom row to load from buffer
    .bottomrow
        defs cols, $00