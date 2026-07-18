    .inesprg 1
    .ineschr 1
    .inesmap 0
    .inesmir 1

    .rsset $0000
scratch         .rs 16
ptr             .rs 2
nmifinished     .rs 1    

    .bank 0
    .org $C000   
RESET:
    SEI
    CLD
    LDX #$40
    STX $4017
    LDX #$FF
    TXS
    INX
    STX $2000
    STX $2001
    STX $4010

vblankwait1:
    BIT $2002
    BPL vblankwait1   


clrmem:
    LDA #$00
    STA $0000, x
    STA $0100, x
    STA $0200, x
    STA $0300, x
    STA $0400, x
    STA $0500, x
    STA $0600, x
    STA $0700, x
    LDA #$FE
    STA $0300, x
    INX
    BNE clrmem

vblankwait2:
    BIT $2002
    BPL vblankwait2

    ; Load SFX
    ; ldx #LOW(sounds)
    ; ldy #HIGH(sounds)
    ; jsr famistudio_sfx_init

Start:
    
    JSR LoadPalettes 

    LDA #$00
    STA $2005
    STA $2005

    LDA #%10010000
    STA $2000
    LDA #%00011110
    STA $2001

.loop:
    LDA nmifinished
    BEQ .loop

    ;LDA buttons
    ;AND #$10
    ;BNE Game

    LDA #$00
    STA nmifinished
    JMP .loop    

NMI:
    LDA #$01
    STA nmifinished

    RTI

LoadPalettes:
    LDA $2002
    LDA #$3F
    STA $2006
    LDA #$00
    STA $2006

    LDX #$00
.loop:
    LDA PaletteData, x
    STA $2007
    INX
    CPX #$20
    BNE .loop  

    RTS

PaletteData:
    .db $0F,$3C,$11,$03,$0F,$35,$16,$06,$0F,$39,$3A,$3B,$0F,$3D,$28,$38
.sprites:
    .db $0F,$36,$25,$15,$0F,$27,$27,$16,$0F,$07,$3D,$13,$0F,$02,$38,$3C 


    .bank 1
 ;   .org $E000




    .org $FFFA
    .dw NMI
    .dw RESET
    .dw 0


    .bank 2
    .org $0000
    .incbin "gfx.chr"