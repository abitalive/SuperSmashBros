// Super Smash Bros. Multiplayer ROM Hack by Abitalive

arch n64.cpu
endian msb
//output "", create

include "..\LIB\N64.inc"
include "..\LIB\macros.inc"

origin 0x0
insert "..\LIB\Super Smash Bros. (U) [!].z64"

// Disable music
origin 0x0216FC
base 0x80020AFC
//nop

// Unlock everything
origin 0x042B3B
base 0x800A3DEB
dl 0x7F0C90

// Boot to character selection screen
origin 0x042CD0
base 0x800A3F80
db 0x10

// Disable timeout to title screen
origin 0x11D5B0
base 0x80132620
b 0x80132640 // Mode select screen

origin 0x11EB1C
base 0x80132A0C
b 0x80132A2C // 1P menu screen

origin 0x120658
base 0x80132EA8
b 0x80132ED0 // Option screen

origin 0x121D20
base 0x801328D0
b 0x801328F0 // Data screen

origin 0x1245A0
base 0x80133BF0
b 0x80133C18 // Versus menu screen

origin 0x127284
base 0x80133AA4
b 0x80133AD4 // Versus options screen

origin 0x138BDC
base 0x8013A95C
b 0x8013A984 // Versus character selection screen

origin 0x1401F4
base 0x80137FF4
b 0x80138024 // 1P character selection screen

origin 0x146D08
base 0x80137728
b 0x80137758 // Training character selection screen

origin 0x14CA28
base 0x801369F8
b 0x80136A28 // Bonus practice character selection screen

origin 0x14F928
base 0x80133DB8
b 0x80133DE0 // Stage selection screen

// Default versus settings
origin 0x040898
base 0x800A1B48
jal DefaultVersus

// Dreamland no wind
origin 0x081734
base 0x80105F34
nop

// Sector Z no Arwing
origin 0x08364C
base 0x80107E4C
nop

// Planet Zebes acid always down
origin 0x083C10
base 0x80108410
nop

// Hyrule Castle no tornadoes
origin 0x086160
base 0x8010A960
nop

// Saffron City no Pokemon
origin 0x086974
base 0x8010B174
nop
nop
nop

// Random stage fixes
origin 0x14F744
base 0x80133BD4
jal RandomStages
nop

// Final Destination versus and training fixes
origin 0x080414
base 0x80104C14
jal FinalDestination

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

// Neutral Spawns
origin 0x07679C
base 0x800FAF9C
j NeutralSpawns
nop
NeutralSpawns_Return:

// Stock handicap
origin 0x10A38C
base 0x8018D49C
ori t9, r0, 0x09 // Disable original handicap behavior

origin 0x10A3A4
base 0x8018D4B4
jal StockHandicap // Stock count

origin 0x156C5C
base 0x80137ABC
addiu t3, t3, 0x9BB0 // Use places for auto

origin 0x156CBC
base 0x80137B1C
addiu t3, t3, 0x9BB0 // Use places for auto

origin 0x156DA4
base 0x80137C04
addiu t3, t3, 0x9BB0 // Use places for auto

origin 0x157370
base 0x801381D0
addiu t3, t3, 0x9BB0 // Use places for auto

origin 0x1573D0
base 0x80138230
addiu t3, t3, 0x9BB0 // Use places for auto

origin 0x1574B8
base 0x80138318
addiu t3, t3, 0x9BB0 // Use places for auto

origin 0x157898
base 0x801386F8
lw a1, 0x18 (sp) // Loser
jal 0x80138548 // Use places for auto
or a0, v0, r0 // Winner

// Random stage music
origin 0x077C08
base 0x800FC408
jal RandomMusic // Stage music
nop

// Menu music
origin 0x050038
base 0x800D4658
jal SramRead // SRAM read

origin 0x0500A8
base 0x800D46C8
jal SramInit // SRAM initialize

origin 0x11DAAC
base 0x80132B1C
jal MenuMusic // Boot

origin 0x11F118
base 0x80133008
jal MenuMusic // Back from 1PCSS/TCSS/B1PCSS/B2PCSS

origin 0x120D58
base 0x801335A8
jal MenuMusic // Back from Screen Adjust

origin 0x1222F8
base 0x80132EA8
jal MenuMusic // Back from Sound Test

origin 0x1250F0
base 0x80134740
jal MenuMusic // Back from VCSS

origin 0x139578
base 0x8013B2F8
jal MenuMusic // VCSS

origin 0x140734
base 0x80138534
jal MenuMusic // 1PCSS

origin 0x1474B4
base 0x80137ED4
jal MenuMusic // TCSS

origin 0x14CF08
base 0x80136ED8
jal MenuMusic // B1PCSS/B2PCSS

origin 0x15D4F8
base 0x801365B8
jal MenuMusic // Versus Record

origin 0x160084
base 0x80134034
jal MenuMusic // Characters

origin 0x121E40
base 0x801329F0
jal ChangeMusic // Characters

origin 0x121E98
base 0x80132A48
jal ChangeMusic // Versus Record

origin 0x12FC20
base 0x801327C0
jal ChangeMusic // Screen Adjust

origin 0x13EEDC
base 0x80136CDC
jal ChangeMusic // Back from 1PCSS

origin 0x1363A0
base 0x80138120
jal ChangeMusic // Back from VCSS

origin 0x14B7B4
base 0x80135784
jal ChangeMusic // Back from B1PCSS/B2PCSS

origin 0x144DD0
base 0x801357F0
jal ChangeMusic // Back from TCSS

origin 0x188644
base 0x80132274
jal ChangeMusic // Back from Sound Test

origin 0x188548
base 0x80132178
jal SaveMusic

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
  Settings:
    lui t0, 0x8050
    sb r0, 0 (t0) // Extra versus stages
    ori t1, 0xFF
    sb t1, 0x01 (t0) // Random stage music
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
// v0 = temp
scope WCopy: {
  lw v0, 0 (a0)
  addiu a2, -0x04
  sw v0, 0 (a1)
  addiu a0, 0x04
  bnez a2, WCopy
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

// Random stage fixes
scope RandomStages: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  Random:
    jal 0x80018A30 // Random
    ori a0, r0, 0x11 // Range = 0x00-0x10
    ori t0, r0, 0x09 // If return value == 0x09
    beq v0, t0, Random
    ori t0, r0, 0x0A // Or return value == 0x0A
    beq v0, t0, Random
    ori t0, r0, 0x0B // Or return value == 0x0B
    beq v0, t0, Random
    ori t0, r0, 0x0C // Or return value == 0x0C
    beq v0, t0, Random
    ori t0, r0, 0x0F // Or return value == 0x0F
    beq v0, t0, Random // Generate another random stage
    nop
    b End
    nop
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
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
  ori t1, r0, 0x0E
  beq t0, t1, VersusBackground // Or if stage == Battlefield
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
  ori t0, r0, 0x02
  beq v0, t0, Congo
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

// Quick Reset
scope QuickReset: {
  Input:
    lui t0, 0x800A
    ori t1, r0, 0xF010
    Player1:
      lhu t2, 0xEFA4 (t0)
      beq t1, t2, Reset // If player 1 input == A, B, Z, R, Start
    Player2:
      lhu t2, 0xEFAC (t0)
      beq t1, t2, Reset // Or player 2 input == A, B, Z, R, Start
    Player3:
      lhu t2, 0xEFB4 (t0)
      beq t1, t2, Reset // Or player 3 input == A, B, Z, R, Start
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
  ori t7, r0, 0x01
  beq t6, t7, Time // If mode == stock
  nop
  Stock:
    sll t6, a0, 0x07
    sll t7, a0, 0x03
    subu t6, t7
    sll t7, a0, 0x02
    subu t6, t7
    lui t7, 0x800A
    addu t7, t6
    lb v0, 0x4D33 (t7) // Points = stocks
    addiu v0, 0x01 // Add 1 to get real stocks number
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

// Neutral spawns
scope NeutralSpawns: {
  lui t0, 0x800A
  lbu t0, 0x4AD0 (t0) // Mode
  ori t1, r0, 0x16
  bne t0, t1, End // If mode == versus
  nop
  Count:
    la t0, 0x800A4D2A // Pointer to player status flag
    ori t1, r0, 0x02
    ori t2, r0, 0x03
    or t3, r0, r0 // Player counter
    addiu t4, r0, -0x01 // Loop counter
    Loop0:
      lbu t5, 0 (t0) // Player status flag
      beq t5, t1, IncLoop0 // If player active
      nop
      addiu t3, 0x01 // Increment player counter
      IncLoop0:
        addiu t4, 0x01 // Increment loop counter
      bne t4, a0, EndLoop0 // If player == loop counter
      nop
      or t6, r0, t3 // t6 = player counter
      EndLoop0:
        bne t4, t2, Loop0 // Break if loop counter == 3
        addiu t0, 0x74 // Update pointer for next player
  ori t0, r0, 0x02
  bne t3, t0, End // If players == 2
  nop
  Lookup:
    lui t0, 0x800A
    lbu t0, 0x4ADF (t0) // Stage
    la t1, NeutralSpawnsTable // Pointer to lookup table
    Loop1:
      lbu t2, 0 (t1) // Lookup stage
      bnel t0, t2, Loop1 // Break if stage == lookup stage
      addiu t1, 0x03 // Update pointer for next stage
    addu t1, t6
    lbu a0, 0 (t1) // Lookup spawn
  End:
   lui a3, 0x8013 // Original instructions
   j NeutralSpawns_Return
   lw a3, 0x1380 (a3)
}

// Stock handicap
scope StockHandicap: {
  lui t0, 0x800A
  lb t0, 0x4D10 (t0)
  beqz t0, End // If handicap enabled
  nop
  lbu t8, 0x21 (v1) // Stocks = handicap
  addiu t8, -0x01
  End:
    jr ra
    sb t8, 0x77 (sp) // Original instruction
}

// Random stage music
scope RandomMusic: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  lui t0, 0x800A
  lbu t0, 0x4AD0 (t0) // Mode
  ori t1, r0, 0x01
  beq t0, t1, End // If mode != 1p game
  nop
  la t0, RandomMusicTable
  Random:
    jal 0x80018A30 // Random
    ori a0, r0, RandomMusicTableEnd - RandomMusicTable // Range
    la a1, RandomMusicTable
    addu a1, v0
    lbu a1, 0 (a1) // Lookup track
    lui t0, 0x8050
    lbu t1, 0x01 (t0) // Last track
    beq a1, t1, Random // If lookup track == last track; generate another random track
    nop
    sb a1, 0x01 (t0) // Update last track
  End:
    la v0, 0x801313A0 // Original instructions
    or a0, r0, r0
    jal 0x80020AB4
    sw a1, 0 (v0)
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

// Menu music
scope SramRead: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  jal 0x80002DA4 // Original instruction
  nop
  ori a0, r0, 0x7F00 // SRAM source
  addiu a1, sp, 0x10 // RAM destination
  jal 0x80002DA4 // SRAM Read
  ori a2, r0, 0x01 // Size
  lbu t0, 0x10 (sp)
  lui t1, 0x8050
  sb t0, 0x02 (t1)
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

scope SramInit: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  jal 0x800D45F4 // Original instruction
  nop
  lui t0, 0x8050
  ori t1, r0, 0x2C
  sb t1, 0x02 (t0)
  sb t1, 0x10 (sp)
  addiu a0, sp, 0x10 // RAM source
  ori a1, r0, 0x7F00 // SRAM destination
  jal 0x80002DE0 // SRAM Write
  ori a2, r0, 0x01 // Size
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

scope MenuMusic: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  lui t0, 0x8050
  lbu t0, 0x02 (t0) // Saved track
  ori t1, r0, 0x2C
  beq t0, t1, Original // If saved track == 0x2C (menu); use original track
  nop
  lui t1, 0x800A
  lbu t1, 0x4AD1 (t1) // Last screen
  ori t2, r0, 0x01
  beq t1, t2, SavedTrack // Else if last screen == title screen; use saved track
  ori t2, r0, 0x16
  beq t1, t2, SavedTrack // Or last screen == versus; use saved track
  ori t2, r0, 0x18
  beq t1, t2, SavedTrack // Or last screen == results screen; use saved track
  ori t2, r0, 0x1B
  beq t1, t2, SavedTrack // Or last screen == boot; use saved track
  ori t2, r0, 0x34
  beq t1, t2, SavedTrack // Or last screen == 1p game; use saved track
  ori t2, r0, 0x35
  beq t1, t2, SavedTrack // Or last screen == bonus practice; use saved track
  ori t2, r0, 0x36
  beq t1, t2, SavedTrack // Or last screen == training; use saved track
  nop
  la t1, 0x80132EB0
  bne ra, t1, End // If ra == 0x80132EB0 (back from sound test)
  nop
  lui t1, 0x800A
  lw t1, 0xD974 (t1) // Pointer to current track
  lw t1, 0 (t1) // Current track
  li t2, 0xFFFFFFFF
  beq t1, t2, SavedTrack // And current track == 0xFFFFFFFF
  nop
  b End
  nop
  SavedTrack:
    or a1, r0, t0 // Use saved track
  Original:
    jal 0x80020AB4 // Original instructions
    or a0, r0, r0
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

scope ChangeMusic: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  SavedTrack:
    lui t0, 0x8050
    lbu t0, 0x02 (t0) // Saved track
    ori t1, r0, 0x2C
    beq t0, t1, Original // If saved track == 0x2C (menu); original instruction
    nop
  NoTrack:
    la t0, 0x8013227C
    bne ra, t0, End // If ra == 0x8013227C (back from sound test)
    nop
    lui t0, 0x800A
    lw t0, 0xD974 (t0) // Pointer to current track
    lw t0, 0 (t0) // Current track
    li t1, 0xFFFFFFFF
    bne t0, t1, End // And current track == 0xFFFFFFFF
    nop
  Original:
    jal 0x80020A74 // Original instruction
    nop
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

scope SaveMusic: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  lui t0, 0x8050
  sb a1, 0x02 (t0) // Save a1
  addiu a0, sp, 0x10 // RAM source
  sb a1, 0 (a0)
  ori a1, r0, 0x7F00 // SRAM destination
  jal 0x80002DE0 // SRAM Write
  ori a2, r0, 0x01 // Size
  lui t0, 0x8050
  lbu a1, 0x02 (t0) // Restore a1
  jal 0x80020AB4 // Original instructions
  or a0, r0, r0
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

// Neutral spawns table
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
db 0x0D, 0x00, 0x03 // Meta Crystal
db 0x0E, 0x02, 0x03 // Battlefield
db 0x10, 0x00, 0x01 // Final Destination
align(4)

// Random stage music table
RandomMusicTable:
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
RandomMusicTableEnd:
align(4)

// Stage pictures
insert ImgMetaCrystal, "Images\meta_crystal.rgba"
insert ImgBattlefield, "Images\battlefield.rgba"
insert ImgFinalDestination, "Images\final_destination.rgba"

fill 0x1000000 - origin() // Zero fill remainder of ROM
