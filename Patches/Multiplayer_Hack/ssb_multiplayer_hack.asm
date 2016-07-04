// Super Smash Bros. Multiplayer ROM Hack by Abitalive

arch n64.cpu
endian msb
//output "", create

include "..\LIB\N64.inc"
include "..\LIB\macros.inc"

origin 0x0
insert "..\LIB\Super Smash Bros. (U) [!].z64"

// Unlock everything
origin 0x042B3B
base 0x800A3DEB
dl 0xFF0FF0

// Boot to character selection screen
origin 0x042CD0
base 0x800A3F80
db 0x10

// Disable timeout to title screen
origin 0x11D5B0
base 0x80132620
b 0x80132640 // MSS

origin 0x11EB1C
base 0x80132A0C
b 0x80132A2C // 1PMS

origin 0x1245A0
base 0x80133BF0
b 0x80133C18 // VMS

origin 0x127284
base 0x80133AA4
b 0x80133AD4 // VOS

origin 0x138BDC
base 0x8013A95C
b 0x8013A984 // VCSS

origin 0x146D08
base 0x80137728
b 0x80137758 // TCSS

origin 0x14F928
base 0x80133DB8
b 0x80133DE0 // SSS

// Default versus settings
origin 0x040898
base 0x800A1B48
jal DefaultVersus

// Dreamland no wind
origin 0x081408
base 0x80105C08
nop

// Sector Z Arwing doesn't shoot
origin 0x0834B8
base 0x80107CB8
nop

// Planet Zebes acid always down
origin 0x083A5C
base 0x8010825C
nop

// Hyrule Castle no tornadoes
origin 0x085BD8
base 0x8010A3D8
nop

// Random stage fixes
origin 0x0A7D6B
base 0x800A716B
db 0x0D // Meta Crystal

origin 0x0A7D73
base 0x800A7173
db 0x0C // Battlefield

origin 0x0A7D7B
base 0x800A717B
db 0x0A // Final Destination

origin 0x14F748
base 0x80133BD8
addiu a0, r0, 0x0C // Range

// Final Destination versus and training fixes
origin 0x080414
base 0x80104C14
jal FinalDestination

origin 0x0216F8
base 0x80020AF8
j FinalDestinationMusic
nop

// Extra versus and training stages
origin 0x0803DC
base 0x80104BDC
j ExtraStagesTraining
nop

origin 0x14F784
base 0x80133C14
jal ExtraStagesSwap

origin 0x14FA40
base 0x80133ED0
jal ExtraStagesToggle

origin 0x14FEFC
base 0x8013438C
jal ExtraStagesVisual

// Quick reset
origin 0x109FB8
base 0x8018D0C8
jal QuickReset

origin 0x10B204
base 0x8018E314
j SkipResults
nop
SkipResults_Return:

// Always show full results screen
origin 0x15688C
base 0x801376EC
nop

// Extra FFA costumes
origin 0x1368C8
base 0x80138648
j ExtraCostumes
nop

// Timed stock battles
origin 0x10A4EC
base 0x8018D5FC
lbu t6, 0x03 (t5)
lui a0, 0x800A
addiu a0, a0, 0x4EF8
ori t7, r0, 0x01
beq t6, t7, 0x8018D61C // Prevent sudden death

origin 0x1241A0
base 0x801337F0
addiu t8, r0, 0x03

origin 0x1241B4
base 0x80133804
addiu t9, r0, 0x03

origin 0x1389F8
base 0x8013A778
ori t6, r0, 0x01
bnel t5, t6, 0x8013A790 // Show stock icons

origin 0x155DA8
base 0x80136C08
j TimeScoring // Show correct places
nop

origin 0x156564
base 0x801373C4
j TimedStock // Show correct places

// Allow start immediately on versus CSS
origin 0x138CF0
base 0x8013AA70
nop

// Allow start immediately on training CSS
origin 0x146DCC
base 0x801377EC
nop

// Allow skipping results screen immediately
origin 0x150FD4
base 0x80131E34
nop

// Initialize
origin 0x001234
base 0x80000634
jal Initialize

origin 0x33204
base 0x80032604
scope Initialize: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  jal 0x80002CA0 // Original instruction (DMA Copy)
  nop
  DMA:
    li a0, 0x00F5F4E0 // Source
    la a1, 0x80400000 // Destination
    li a2, 0x000A0B20 // Size
    jal 0x80002CA0 // DMA Copy
    nop
  ExtraStages:
    lui t0, 0x8050
    sb r0, 0 (t0)
  lw ra, 0x14 (sp)
  jr ra
  addiu sp, 0x18
}

origin 0xF5F4E0
base 0x80400000

// Word copy
// a0 = source
// a1 = destination
// a2 = size
// v0 = counter
// v1 = temp
scope WCopy: {
  ori v0, r0, r0
  Loop:
    lw v1, 0 (a0)
    sw v1, 0 (a1)
    addiu v0, 0x04
    addiu a0, 0x04
    bne a2, v0, Loop
    addiu a1, 0x04
  End:
    jr ra
    nop
}

// Default versus settings
scope DefaultVersus: {
   ori t5, r0, 0x03 // Timed Stock
   sb t5, 0x4D0B (t6)
   ori t5, r0, 0x0804 // 8 minutes 5 stock
   sh t5, 0x4D0E (t6)
   sb r0, 0x4D24 (t6) // Items disabled
   ori t5, r0, 0x09 // CPU level 9
   sb t5, 0x4D28 (t6)
   sb t5, 0x4D9C (t6)
   sb t5, 0x4E10 (t6)
   sb t5, 0x4E84 (t6)
   jr ra
   lw t5, 0 (t1) // Original instruction
}

// Extra versus stages
scope ExtraStagesTraining: {
  lui t6, 0x800A // Original instructions
  lb t6, 0x4AD0 (t6)
  ori t0, r0, 0x36
  bne t6, t0, End // If mode == training
  nop
  lui t0, 0x800A
  lb t0, 0x4ADF (t0)
  ori t1, r0, 0x0D
  beq t0, t1, VersusBackground // If stage == Meta Crystal
  nop
  ori t1, r0, 0x0E
  beq t0, t1, VersusBackground // Or if stage == Battlefield
  nop
  ori t1, r0, 0x10
  beq t0, t1, VersusBackground // Or if stage == Final Destination
  nop
  b End
  nop
  VersusBackground:
    ori t6, r0, 0x16 // Return versus background
  End:
    j 0x80104BE4
    nop
}

scope ExtraStagesSwap: {
  lui t0, 0x8050
  lb t0, 0 (t0)
  beq t0, r0, End // If extra stages enabled
  nop
  beq v0, r0, Peaches
  nop
  ori t0, r0, 0x02
  beq v0, t0, Congo
  nop
  ori t0, r0, 0x04
  beq v0, t0, Hyrule
  nop
  b End
  nop
  Peaches: // If stage == Peaches Castle
    ori v0, r0, 0x0D // Swap with Meta Crystal
    b End
    nop
  Congo: // If stage == Congo Jungle
    ori v0, r0, 0x0E // Swap with Battlefield
    b End
    nop
  Hyrule: // If stage == Hyrule Castle
    ori v0, r0, 0x10 // Swap with Final Destination
  End:
    jr ra
    sb v0, 0x000F (s1) // Original instruction
}

scope ExtraStagesToggle: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  jal 0x8039076C // Original instruction
  nop
  bnez v0, End // Skip if B pushed
  nop
  jal 0x8039076C
  ori a0, r0, 0x2000
  beq v0, r0, End // If Z pushed
  nop
  Toggle:
    lui t0, 0xA013
    sw r0, 0x3F08 (t0) // NOP instructions which change screen
    sw r0, 0x3F10 (t0)
    sw r0, 0x3F1C (t0)
    sw r0, 0x3F20 (t0)
    lui t0, 0x8050
    lb t1, 0 (t0)
    bnez t1, Disable // If extra stages disabled
    Enable:
      ori t1, r0, 0x01
      sb t1, 0 (t0) // Store enabled flag
      b End
      nop
    Disable:
      sb r0, 0 (t0) // Else store disabled flag
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
  lui t0, 0x8050
  lb t0, 0 (t0)
  beq t0, r0, End // If extra stages enabled
  nop
  Pictures: // [Jorgasms]
    MetaCrystal:
      la a0, ImgMetaCrystal // Source
      la a1, 0x8015F928 // Destination
      jal WCopy
      ori a2, r0, 0x0D80 // Size
    Battlefield:
      la a0, ImgBattlefield // Source
      la a1, 0x801614E8 // Destination
      jal WCopy
      ori a2, r0, 0x0D80 // Size
    FinalDestination:
      la a0, ImgFinalDestination // Source
      la a1, 0x801630A8 // Destination
      jal WCopy
      ori a2, r0, 0x0D80 // Size
  Previews:
    lui t0, 0x8013
    ori t1, r0, 0x010D // Meta Crystal
    sw t1, 0x44E4 (t0)
    ori t1, r0, 0x010C // Battlefield
    sw t1, 0x44F4 (t0)
    ori t1, r0, 0x010A // Final Destination
    sw t1, 0x4504 (t0)
    sw r0, 0x4508 (t0)
    lui t1, 0x3F00 // Final Destination (zoom)
    sw t1, 0x4868 (t0)
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

// Final Destination versus and training fixes
scope FinalDestination: {
  lbu v0, 0x01 (t7) // Original instruction
  lui t0, 0x800A
  lb t1, 0x4AD0 (t0)
  ori t2, r0, 0x16
  beq t1, t2, TrainingVersus // If mode == versus
  nop
  ori t2, r0, 0x36
  beq t1, t2, TrainingVersus // Or mode == training
  nop
  b End
  nop
  TrainingVersus:
    lb t1, 0x4ADF (t0)
    ori t2, r0, 0x10
    bne t1, t2, End // If level == Final Destination
    nop
    ori v0, r0, 0x0E // Return Battlefield index
  End:
   jr ra
   nop
}

scope FinalDestinationMusic: {
  lui t0, 0x800A
  lb t1, 0x4AD0 (t0)
  ori t2, r0, 0x16
  beq t1, t2, TrainingVersus // If mode == versus
  nop
  ori t2, r0, 0x36
  beq t1, t2, TrainingVersus // Or mode == training
  nop
  b End
  nop
  TrainingVersus:
    lb t1, 0x4ADF (t0)
    ori t2, r0, 0x10
    bne t1, t2, End // If level == Final Destination
    nop
    ori a1, r0, 0x19 // Return Master Hand music
  End:
    jr ra
    sw a1, 0 (t3) // Original instruction (comment to disable music)
}

// Quick Reset
scope QuickReset: {
  Input:
    lui t0, 0x800A
    ori t1, r0, 0xF010
    Player1:
      lhu t2, 0xEFA4 (t0)
      beq t1, t2, Reset // If player 1 input == A, B, Z, R, Start
      nop
    Player2:
      lhu t2, 0xEFAC (t0)
      beq t1, t2, Reset // Or player 2 input == A, B, Z, R, Start
      nop
    Player3:
      lhu t2, 0xEFB4 (t0)
      beq t1, t2, Reset // Or player 3 input == A, B, Z, R, Start
      nop
    Player4:
      lhu t2, 0xEFBC (t0)
      beq t1, t2, Reset // Or player 4 input == A, B, Z, R, Start
      nop
    b End
    nop
  Reset:
    lui t0, 0x800A
    ori t1, r0, 0x02 // Skip results screen
    sb t1, 0x4AE2 (t0)
    ori t1, r0, 0x07 // Reset
    sb t1, 0x4D19 (t0)
  End:
    j 0x8011485C
    nop
}

scope SkipResults: {
  lui t0, 0x800A
  lb t0, 0x4AE2 (t0)
  Skip:
    ori t1, r0, 0x02
    bne t0, t1, Original // If result == skip
    nop
    ori t0, r0, 0x10 // Skip results screen
    b End
    nop
  Original:
    ori t0, r0, 0x18 // Else original instruction
  End:
   j SkipResults_Return
   sb t0, 0 (v0)
}

// Extra FFA costumes
// Z + C Up: Red team
// Z + C Right: Blue team
// Z + C Down: Green team
// Z + C Left: Extra team
scope ExtraCostumes: {
  Red:
    lw t0, 0x24 (sp)
    lhu t1, 0 (t0)
    ori t2, r0, 0x2000 // Z
    and t3, t1, t2
    bne t2, t3, Blue
    nop
    lhu t1, 0x02 (t0)
    ori t2, r0, 0x0008 // C Up
    and t3, t1, t2
    bne t2, t3, Blue
    nop
    lw a0, 0x40 (sp)
    lw a1, 0x28 (sp)
    lw a2, 0x1C (sp)
    lw a2, 0x80 (a2)
    jal 0x8013718C
    ori a3, r0, 0x04
    bnez v0, Blue
    lw t0, 0x1C (sp)
    lw t0, 0x88 (t0)
    beqz t0, Blue
    nop
    lw a0, 0x28 (sp)
    jal 0x80137EFC
    ori a1, r0, 0x04
  Blue:
    lw t0, 0x24 (sp)
    lhu t1, 0 (t0)
    ori t2, r0, 0x2000 // Z
    and t3, t1, t2
    bne t2, t3, Green
    nop
    lhu t1, 0x02 (t0)
    ori t2, r0, 0x0001 // C Right
    and t3, t1, t2
    bne t2, t3, Green
    nop
    lw a0, 0x40 (sp)
    lw a1, 0x28 (sp)
    lw a2, 0x1C (sp)
    lw a2, 0x80 (a2)
    jal 0x8013718C
    ori a3, r0, 0x05
    bnez v0, Green
    lw t0, 0x1C (sp)
    lw t0, 0x88 (t0)
    beq t0, r0, Green
    nop
    lw a0, 0x28 (sp)
    jal 0x80137EFC
    ori a1, r0, 0x05
  Green:
    lw t0, 0x24 (sp)
    lhu t1, 0 (t0)
    ori t2, r0, 0x2000 // Z
    and t3, t1, t2
    bne t2, t3, Extra
    nop
    lhu t1, 0x02 (t0)
    ori t2, r0, 0x0004 // C Down
    and t3, t1, t2
    bne t2, t3, Extra
    nop
    lw a0, 0x40 (sp)
    lw a1, 0x28 (sp)
    lw a2, 0x1C (sp)
    lw a2, 0x80 (a2)
    jal 0x8013718C
    ori a3, r0, 0x06
    bnez v0, Extra
    lw t0, 0x1C (sp)
    lw t0, 0x88 (t0)
    beq t0, r0, Extra
    nop
    lw a0, 0x28 (sp)
    jal 0x80137EFC
    ori a1, r0, 0x06
  Extra:
    lw t0, 0x24 (sp)
    lhu t1, 0 (t0)
    ori t2, r0, 0x2000 // Z
    and t3, t1, t2
    bne t2, t3, End
    nop
    lhu t1, 0x02 (t0)
    ori t2, r0, 0x0002 // C Left
    and t3, t1, t2
    bne t2, t3, End
    nop
    lw a0, 0x40 (sp)
    lw a1, 0x28 (sp)
    lw a2, 0x1C (sp)
    lw a2, 0x80 (a2)
    jal 0x8013718C
    ori a3, r0, 0x07
    bnez v0, End
    lw t0, 0x1C (sp)
    lw t0, 0x88 (t0)
    beq t0, r0, End
    nop
    lw a0, 0x28 (sp)
    jal 0x80137EFC
    ori a1, r0, 0x07
  End:
    lw t0, 0x24 (sp)
    lhu v1, 0x02 (t0)
    j 0x80138678
    lw a1, 0x28 (sp)
}

// Timed stock
scope TimeScoring: {
  lui t6, 0x800A
  lb t6, 0x4D0B (t6)
  ori t7, 0x01
  beq t6, t7, Time // If mode == stock
  Stock:
    ori t6, r0, 0x74
    multu a0, t6
    mflo t6
    lui t7, 0x800A
    addu t7, t6
    lb v0, 0x4D33 (t7) // Points = stocks
    addiu v0, 0x01
    b End
    nop
  Time: // Else
    sll v1, a0, 0x02
    lui t6, 0x8014
    lui t7, 0x8014
    addu t7, v1
    addu t6, v1
    lw t6, 0x9B80 (t6) // Load KOs
    lw t7, 0x9B90 (t7) // Load deaths
    subu v0, t6, t7 // Points = KOs - deaths
  End:
    jr ra
    nop
}

scope TimedStock: {
  ori t0, r0, 0x01
  beq t6, t0, Time // If mode == time use time scoring
  nop
  lui t0, 0x800A
  lw t0, 0x4D1C (t0)
  beq t0, r0, Time // Else if timer == 0 use time scoring
  nop
  Stock:
    j 0x801373CC // Else use stock scoring
    nop
  Time:
    j 0x801373F4
    nop
}

// Stage pictures
insert ImgMetaCrystal, "Images\meta_crystal.bin"
insert ImgBattlefield, "Images\battlefield.bin"
insert ImgFinalDestination, "Images\final_destination.bin"

fill 0x1000000 - origin() // Zero fill remainder of ROM
