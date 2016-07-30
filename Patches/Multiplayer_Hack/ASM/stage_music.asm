// Random stage music

constant TrackLast(0x80500001) // Last track variable location

origin 0x077C08
base 0x800FC408
jal RandomMusic
nop

pullvar pc, origin

scope RandomMusic: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  luia(t0, ScreenCurrent)
  lbu t0, ScreenCurrent (t0) // Mode
  lli t1, 0x01
  beq t0, t1, End // If mode != 1p game
  nop
  Random:
    jal RandomInt
    lli a0, RandomMusicListEnd - RandomMusicList // Range
    luia(a1, RandomMusicList) // Pointer to lookup track
    addu a1, v0 // Update pointer
    lbu a1, RandomMusicList (a1) // Lookup track
    luia(t0, TrackLast)
    lbu t1, TrackLast (t0) // Last track
    beq a1, t1, Random // If lookup track == last track; generate another random track
    nop
    sb a1, TrackLast (t0) // Update last track
  End:
    lui v0, 0x8013 // Original instructions
    or a0, r0, r0
    jal 0x80020AB4
    sw a1, 0x13A0 (v0)
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

RandomMusicList:
db 0x00 // Dream Land
db 0x01 // Planet Zebes
db 0x02 // Mushroom Kingdom
db 0x04 // Sector Z
db 0x05 // Congo Jungle
db 0x06 // Peach's Castle
db 0x07 // Saffron City
db 0x08 // Yoshi's Island
db 0x09 // Hyrule Castle
db 0x19 // Final Destination
db 0x1A // Bonus Stages
db 0x24 // Battlefield
db 0x25 // Meta Crystal
db 0x27 // Credits
RandomMusicListEnd:
align(4)

pushvar origin, pc
