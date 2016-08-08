// Extra versus and training stages

constant ExtraStagesFlag(0x80500000) // Extra stages flag location

origin 0x1145E0
base 0x8018DDC0
jal ExtraStagesTraining0

origin 0x11463C
base 0x8018DE1C
jal ExtraStagesTraining1

origin 0x14F744
base 0x80133BD4
jal ExtraStagesRandom
nop

origin 0x14F774
base 0x80133C04
jal ExtraStagesSwap

origin 0x14FA40
base 0x80133ED0
jal ExtraStagesToggle

origin 0x14FEFC
base 0x8013438C
jal ExtraStagesVisual

pullvar pc, origin

scope ExtraStagesTraining0: {
  lbu v0, 0x01 (t6) // Original instruction
  YoshisIsland:
    lli t0, 0x0C // Yoshi's Island cloudless
    beql v0, t0, End // If stage == Yoshi's Island cloudless
    lli v0, 0x05 // Swap with Yoshi's Island
  lua(t0, ExtraStagesTable) // Pointer to lookup stage
  lli t1, (ExtraStagesTableEnd - ExtraStagesTable) / 2 // Loop counter
  Loop:
    lbu t2, ExtraStagesTable + 1 (t0) // Lookup stage
    beql t2, v0, End // If stage == lookup stage; swap stage
    lbu v0, ExtraStagesTable (t0)
    addiu t1, -0x01 // Decrement loop counter
    bnez t1, Loop // Break if loop counter == 0
    addiu t0, 0x02 // Update pointer for next stage
  End:
    jr ra
    nop
}

scope ExtraStagesTraining1: {
  lbu t3, 0x01 (t2) // Original instruction
  YoshisIsland:
    lli t0, 0x0C // Yoshi's Island cloudless
    beql t3, t0, End // If stage == Yoshi's Island cloudless
    lli t3, 0x05 // Swap with Yoshi's Island
  lua(t0, ExtraStagesTable) // Pointer to lookup stage
  lli t1, (ExtraStagesTableEnd - ExtraStagesTable) / 2 // Loop counter
  Loop:
    lbu t2, ExtraStagesTable + 1 (t0) // Lookup stage
    beql t2, t3, End // If stage == lookup stage; swap stage
    lbu t3, ExtraStagesTable (t0)
    addiu t1, -0x01 // Decrement loop counter
    bnez t1, Loop // Break if loop counter == 0
    addiu t0, 0x02 // Update pointer for next stage
  End:
    jr ra
    nop
}

scope ExtraStagesRandom: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  Random:
    jal RandomInt
    lli a0, RandomStageListEnd - RandomStageList // Range
    lua(t0, RandomStageList) // Pointer to stage
    addu t0, v0 // Update pointer
    lbu v0, RandomStageList (t0) // Stage
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

scope ExtraStagesSwap: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  jal 0x80132430 // Original instruction
  nop
  lua(t0, ExtraStagesFlag)
  lbu t0, ExtraStagesFlag (t0) // Extra stages flag
  beqz t0, End // If extra stages enabled
  nop
  lua(t0, ExtraStagesTable) // Pointer to lookup stage
  lli t1, (ExtraStagesTableEnd - ExtraStagesTable) / 2 // Loop counter
  Loop:
    lbu t2, ExtraStagesTable (t0) // Lookup stage
    beql t2, v0, End // If stage == lookup stage; swap stage
    lbu v0, ExtraStagesTable + 1 (t0)
    addiu t1, -0x01 // Decrement loop counter
    bnez t1, Loop // Break if loop counter == 0
    addiu t0, 0x02 // Update pointer for next stage
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

scope ExtraStagesToggle: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  jal 0x8039076C // Original instruction
  nop
  bnez v0, End // Skip if B pushed
  nop
  jal 0x8039076C
  lli a0, 0x2000 // Z
  beqz v0, End // If Z pushed
  nop
  Toggle:
    lui t0, 0xA013
    sw r0, 0x3F08 (t0) // NOP instructions which change screen
    sw r0, 0x3F10 (t0)
    sw r0, 0x3F1C (t0)
    sw r0, 0x3F20 (t0)
    lua(t0, ExtraStagesFlag)
    lbu t1, ExtraStagesFlag (t0) // Extra stages flag
    xori t1, 0x01 // Toggle flag
    sb t1, ExtraStagesFlag (t0) // Store new flag
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

scope ExtraStagesVisual: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  jal 0x800CDE04 // Original instruction
  nop
  lua(t0, ExtraStagesFlag)
  lbu t0, ExtraStagesFlag (t0) // Extra stages flag
  beqz t0, End // If extra stages enabled
  nop
  Pictures: // [Jorgasms]
    MetaCrystal:
      la a0, ImgMetaCrystal // Source
      la a1, 0x8015F928 // Destination
      jal WordCopy
      lli a2, 0x0D80 // Size
    Battlefield:
      la a0, ImgBattlefield // Source
      la a1, 0x801614E8 // Destination
      jal WordCopy
      lli a2, 0x0D80 // Size
    FinalDestination:
      la a0, ImgFinalDestination // Source
      la a1, 0x801630A8 // Destination
      jal WordCopy
      lli a2, 0x0D80 // Size
  Previews:
    lui t0, 0x8013
    lli t1, 0x010D // Meta Crystal
    sw t1, 0x44E4 (t0) // Stage 0 preview
    lli t1, 0x010C // Battlefield
    sw t1, 0x44F4 (t0) // Stage 2 preview
    lli t1, 0x010A // Final Destination
    sw t1, 0x4504 (t0) // Stage 4 preview
    sw r0, 0x4508 (t0) // Stage 4 preview (offset)
    lui t1, 0x3F00 // Final Destination
    sw t1, 0x4868 (t0) // Stage 4 zoom
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

RandomStageList:
db 0x00 // Peach's Castle
db 0x01 // Sector Z
db 0x02 // Congo Jungle
db 0x03 // Planet Zebes
db 0x04 // Hyrule Castle
db 0x05 // Yoshi's Island
db 0x06 // Dream Land
db 0x07 // Saffron City
db 0x08 // Mushroom Kingdom
db 0x0D // Meta Crystal
db 0x0E // Battlefield
db 0x10 // Final Destination
RandomStageListEnd:
align(4)

ExtraStagesTable:
db 0x00, 0x0D // Peaches Castle / Meta Crystal
db 0x02, 0x0E // Congo Jungle / Battlefield
db 0x04, 0x10 // Hyrule Castle / Final Destination
ExtraStagesTableEnd:
align(4)

// Stage pictures
insert ImgMetaCrystal, "..\Images\meta_crystal.rgba"
insert ImgBattlefield, "..\Images\battlefield.rgba"
insert ImgFinalDestination, "..\Images\final_destination.rgba"
align(4)

pushvar origin, pc
