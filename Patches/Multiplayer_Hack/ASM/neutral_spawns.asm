// Neutral Spawns

origin 0x07679C
base 0x800FAF9C
j NeutralSpawns
nop
NeutralSpawns_Return:

pullvar pc, origin

scope NeutralSpawns: {
  lua(t0, ScreenCurrent)
  lbu t0, ScreenCurrent (t0) // Mode
  lli t1, 0x16
  bne t0, t1, End // If mode == versus
  nop
  Count:
    lui t0, 0x800A
    lli t1, 0x02
    lli t2, 0x03
    or t3, r0, r0 // Player counter
    addiu t4, r0, -0x01 // Loop counter
    Loop0:
      lbu t5, 0x4D2A (t0) // Player status flag
      beq t5, t1, IncLoop0 // If player active
      nop
      addiu t3, 0x01 // Increment player counter
      IncLoop0:
        addiu t4, 0x01 // Increment loop counter
      bne t4, a0, EndLoop0 // If player == loop counter
      nop
      move t6, t3 // t6 = player counter
      EndLoop0:
        bne t4, t2, Loop0 // Break if loop counter == 3
        addiu t0, 0x74 // Update pointer for next player
  lli t0, 0x02
  bne t3, t0, End // If players == 2
  nop
  Lookup:
    lua(t0, Stage)
    lbu t0, Stage (t0) // Stage
    lua(t1, NeutralSpawnsTable) // Pointer to lookup stage
    Loop1:
      lbu t2, NeutralSpawnsTable (t1) // Lookup stage
      bnel t0, t2, Loop1 // Break if stage == lookup stage
      addiu t1, 0x03 // Update pointer for next stage
    addu t1, t6 // Update pointer for player
    lbu a0, NeutralSpawnsTable (t1) // Lookup spawn
  End:
   lui a3, 0x8013 // Original instructions
   j NeutralSpawns_Return
   lw a3, 0x1380 (a3)
}

NeutralSpawnsTable:
db 0x00, 0x01, 0x03 // Peach's Castle
db 0x01, 0x01, 0x03 // Sector Z
db 0x02, 0x00, 0x03 // Congo Jungle
db 0x03, 0x00, 0x03 // Planet Zebes
db 0x04, 0x01, 0x02 // Hyrule Castle
db 0x05, 0x02, 0x03 // Yoshi's Island
db 0x06, 0x01, 0x03 // Dream Land
db 0x07, 0x02, 0x03 // Saffron City
db 0x08, 0x00, 0x01 // Mushroom Kingdom
db 0x0C, 0x02, 0x03 // Yoshi's Island (cloudless)
db 0x0D, 0x00, 0x03 // Meta Crystal
db 0x0E, 0x02, 0x03 // Battlefield
db 0x10, 0x00, 0x01 // Final Destination
align(4)

pushvar origin, pc
