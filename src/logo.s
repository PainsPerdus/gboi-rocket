/* At $0104 we need to put graphical data for the bootstrap (Nitendo Logo)
   If they're not present the game won't launch
   We could use directive .NITENDOLOGO instead */
.ORG $0104
.DB $CE,$ED,$66,$66,$CC,$0D,$00,$0B,$03,$73,$00,$83,$00,$0C
.DB $00,$0D,$00,$08,$11,$1F,$88,$89,$00,$0E,$DC,$CC,$6E,$E6
.DB $DD,$DD,$D9,$99,$BB,$BB,$67,$63,$6E,$0E,$EC,$CC,$DD,$DC
.DB $99,$9F,$BB,$B9,$33,$3E
