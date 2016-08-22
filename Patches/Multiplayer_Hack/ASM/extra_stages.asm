// Extra versus and training stages

constant ExtraStagesFlag(0x80500000) // Extra stages flag location

// Training stage selected (background)
origin 0x1145E0
base 0x8018DDC0
jal ExtraStagesTraining0

// Training stage selected (background)
origin 0x11463C
base 0x8018DE1C
jal ExtraStagesTraining1

// Random stage selected
origin 0x14F744
base 0x80133BD4
jal ExtraStagesRandom
nop

// Stage selected
origin 0x14F774
base 0x80133C04
jal ExtraStagesSwap

// Z pressed
origin 0x14FA40
base 0x80133ED0
jal ExtraStagesToggle

// Enter sss
origin 0x14FEFC
base 0x8013438C
jal ExtraStagesInitial

pullvar pc, origin

scope ExtraStagesTraining0: {
  lbu v0, 0x01 (t6) // Original instruction
  YoshisIsland:
    lli t0, 0x0C // Yoshi's Island cloudless
    beql v0, t0, End // If stage == Yoshi's Island cloudless
    lli v0, 0x05 // Swap with Yoshi's Island
  lua(t0, StageTable) // Pointer to lookup stage
  lli t1, (StageTableEnd - StageTable) / 0x70 // Loop counter
  Loop:
    lw t2, StageTable + 0x38 (t0) // Lookup stage
    beql t2, v0, End // If stage == lookup stage; swap stage
    lw v0, StageTable (t0)
    addiu t1, -0x01 // Decrement loop counter
    bnez t1, Loop // Break if loop counter == 0
    addiu t0, 0x70 // Update pointer for next stage
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
  lua(t0, StageTable) // Pointer to lookup stage
  lli t1, (StageTableEnd - StageTable) / 0x70 // Loop counter
  Loop:
    lw t2, StageTable + 0x38 (t0) // Lookup stage
    beql t2, t3, End // If stage == lookup stage; swap stage
    lw t3, StageTable (t0)
    addiu t1, -0x01 // Decrement loop counter
    bnez t1, Loop // Break if loop counter == 0
    addiu t0, 0x70 // Update pointer for next stage
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
  lua(t0, StageTable) // Pointer to lookup stage
  lli t1, (StageTableEnd - StageTable) / 0x70 // Loop counter
  Loop:
    lw t2, StageTable (t0) // Lookup stage
    beql t2, v0, End // If stage == lookup stage; swap stage
    lw v0, StageTable + 0x38 (t0)
    addiu t1, -0x01 // Decrement loop counter
    bnez t1, Loop // Break if loop counter == 0
    addiu t0, 0x70 // Update pointer for next stage
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

scope ExtraStagesToggle: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  jal 0x8039076C
  lli a0, 0x2000 // Z
  beqz v0, Original // If Z pushed
  nop
  Toggle:
    lua(t0, ExtraStagesFlag)
    lbu t1, ExtraStagesFlag (t0) // Extra stages flag
    xori t1, 0x01 // Toggle flag
    sb t1, ExtraStagesFlag (t0) // Store new flag
  jal ExtraStagesVisual // Update visuals
  nop
  Draw:
    lui a0, 0x8004
    jal 0x80009A84 // Free
    lw a0, 0x6804 (a0) // Pointer to ?
    jal 0x80132528 // Draw icons
    nop
    lui a0, 0x8013
    jal 0x801329AC // Draw logo and text
    lw a0, 0x4BD8 (a0) // Cursor position
    lui a0, 0x8013
    jal 0x80132430 // Get stage
    lw a0, 0x4BD8 (a0) // Cursor position
    jal 0x801333B4 // Draw preview
    move a0, v0 // Stage
  Original:
    jal 0x8039076C // Original instructions
    lli a0, 0x4000
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

scope ExtraStagesInitial: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  jal 0x800CDE04 // Original instruction
  nop
  Extra:
    lua(t0, ExtraStagesFlag)
    lbu t0, ExtraStagesFlag (t0) // Extra stages flag
    beqz t0, End // If extra stages enabled
    nop
    jal ExtraStagesVisual // Update visuals
    nop
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

scope ExtraStagesVisual: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  la t0, StageTable // Pointer to stage table
  lua(t1, ExtraStagesFlag)
  lbu t1, ExtraStagesFlag (t1) // Extra stages flag
  bnezl t1, (pc() + 8) // If extra stages enabled; update pointer for extra stages
  addiu t0, 0x38
  lli t1, (StageTableEnd - StageTable) / 0x70 // Loop counter
  Loop:
    lw t2, 0 (t0) // Stage
    slti t3, t2, 0x09
    beqzl t3, (pc() + 8) // If stage > 8; load original stage
    lw t2, -0x38 (t0)
    Preview:
      sll t3, t2, 0x03
      la t4, 0x801344E4 // Pointer to preview file list
      addu t4, t3 // Update pointer
      lw t5, 0x04 (t0) // Preview index
      sw t5, 0 (t4)
      lw t5, 0x08 (t0) // Preview file
      sw t5, 0x04 (t4)
      sll t3, t2, 0x02
      la t4, 0x80134858 // Pointer to preview zoom list
      addu t4, t3 // Update pointer
      lw t5, 0x0C (t0) // Preview zoom
      sw t5, 0 (t4)
      sll t3, t2, 0x02
      sll t4, t3, 0x01
      addu t3, t4
      la t4, 0x8013487C // Pointer to preview coordinates list
      addu t4, t3 // Update pointer
      lw t5, 0x10 (t0) // Preview x
      sw t5, 0 (t4)
      lw t5, 0x14 (t0) // Preview y
      sw t5, 0x04 (t4)
    Logo:
      lw t3, 0x18 (t0) // Pointer to logo image
      lw t4, 0x1C (t0) // Logo image
      sw t4, 0 (t3)
      sll t3, t2, 0x03
      la t4, 0x801347E4 // Pointer to logo coordinates list
      addu t4, t3 // Update pointer
      lw t5, 0x20 (t0) // Logo x
      sw t5, 0 (t4)
      lw t5, 0x24 (t0) // Logo y
      sw t5, 0x04 (t4)
    Text:
      lw t3, 0x28 (t0) // Pointer to text image
      lw t4, 0x2C (t0) // Text image
      sw t4, 0 (t3)
    Icon:
      lw t3, 0x30 (t0) // Pointer to icon image
      lw t4, 0x34 (t0) // Icon image
      sw t4, 0 (t3)
    addiu t1, -0x01 // Decrement loop counter
    bnez t1, Loop // Break if loop counter == 0
    addiu t0, 0x70 // Update pointer for next stage
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

// Random stage list
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

// Stage table
StageTable:
// Peaches Castle
dd 0x00000000 // Stage
dd 0x00000103, 0x00000014; float32 0.5, 1700, 1800 // Preview (file, offset, zoom, x, y)
dd 0x80157AF0, 0x801574E8; float32 3, 19 // Logo (pointer, image, x, y)
dd 0x8015BB20, 0x8015B938 // Text (pointer, image)
dd 0x801606B0, 0x8015F928 // Icon (pointer, image)
// Meta Crystal
dd 0x0000000D // Stage
dd 0x0000010D, 0x00000014; float32 0.55, 1600, 1600 // Preview (file, offset, zoom, x, y)
dd 0x80157AF0, 0x801574E8; float32 3, 19 // Logo (pointer, image, x, y)
dd 0x8015BB20, TextMetaCrystal // Text (pointer, image)
dd 0x801606B0, IconMetaCrystal // Icon (pointer, image)

// Congo Jungle
dd 0x00000002 // Stage
dd 0x00000105, 0x00000014; float32 0.6, 1600, 1600 // Preview (file, offset, zoom, x, y)
dd 0x80158150, 0x80157B48; float32 3, 20 // Logo (pointer, image, x, y)
dd 0x8015BFA0, 0x8015BDB8 // Text (pointer, image)
dd 0x80162270, 0x801614E8 // Icon (pointer, image)
// Battlefield
dd 0x0000000E // Stage
dd 0x0000010C, 0x00000014; float32 0.65, 1600, 1600 // Preview (file, offset, zoom, x, y)
dd 0x80158150, LogoSsb; float32 1, 20 // Logo (pointer, image, x, y)
dd 0x8015BFA0, TextBattlefield // Text (pointer, image)
dd 0x80162270, IconBattlefield // Icon (pointer, image)

// Hyrule Castle
dd 0x00000004 // Stage
dd 0x00000109, 0x00000014; float32 0.3, 1600, 1500 // Preview (file, offset, zoom, x, y)
dd 0x80159AD0, 0x801594C8; float32 3, 17 // Logo (pointer, image, x, y)
dd 0x8015C428, 0x8015C238 // Text (pointer, image)
dd 0x80163E30, 0x801630A8 // Icon (pointer, image)
// Final Destination
dd 0x00000010 // Stage
dd 0x0000010A, 0x00000000; float32 0.55, 1600, 1500 // Preview (file, offset, zoom, x, y)
dd 0x80159AD0, LogoSsb; float32 1, 20 // Logo (pointer, image, x, y)
dd 0x8015C428, TextFinalDestination // Text (pointer, image)
dd 0x80163E30, IconFinalDestination // Icon (pointer, image)
StageTableEnd:
align(4)

// Images
insert LogoSsb, "..\Images\ssb_logo.ia"
insert TextMetaCrystal, "..\Images\meta_crystal_text.ia"
insert TextBattlefield, "..\Images\battlefield_text.ia"
insert TextFinalDestination, "..\Images\final_destination_text.ia"
insert IconMetaCrystal, "..\Images\meta_crystal_icon.rgba" // [Jorgasms]
insert IconBattlefield, "..\Images\battlefield_icon.rgba" // [Jorgasms]
insert IconFinalDestination, "..\Images\final_destination_icon.rgba" // [Jorgasms]
align(4)

pushvar origin, pc
