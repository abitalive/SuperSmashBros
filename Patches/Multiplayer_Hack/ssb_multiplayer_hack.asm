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
dl 0xFF0FF0

// Boot to character selection screen
origin 0x042CD0
base 0x800A3F80
db 0x10

// Disable timeout to title screen
origin 0x11D5B0
base 0x80132620
b 0x80132640 // MSS

origin 0x1245A0
base 0x80133BF0
b 0x80133C18 // VMS

origin 0x127284
base 0x80133AA4
b 0x80133AD4 // VOS

origin 0x138BDC
base 0x8013A95C
b 0x8013A984 // CSS

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

// Final Destination versus fixes
origin 0x080414
base 0x80104C14
jal FinalDestination

origin 0x0216F8
base 0x80020AF8
j FinalDestinationMusic
nop

// Disable original C button behavior on stage selection screen
origin 0x14FAB0
base 0x80133F40
ori a0, r0, 0x0800 // Up

origin 0x14FB84
base 0x80134014
ori a0, r0, 0x0400 // Down

origin 0x14FC54
base 0x801340E4
ori a0, r0, 0x0220 // Left

origin 0x14FD58
base 0x801341E8
ori a0, r0, 0x0110 // Right

// Extra versus stages
origin 0x10B0B8
base 0x8018E1C8
jal ExtraStages

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

// Extra costumes
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

origin 0x156564
base 0x801373C4
j TimedStockScore // Show correct places

// DMA
origin 0x001234
base 0x80000634
jal DMA

origin 0x33204
base 0x80032604
scope DMA: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  jal 0x80002CA0 // Original instruction (DMA Copy)
  nop
  li a0, 0x00F5F4E0 // Source
  la a1, 0x80400000 // Destination
  li a2, 0x000A0B20 // Size
  jal 0x80002CA0 // DMA Copy
  nop
  lw ra, 0x14 (sp)
  jr ra
  addiu sp, 0x18
}

origin 0xF5F4E0
base 0x80400000

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

// Extra Stages
// C Up: Meta Crystal
// C Right: Battlefield
// C Down: Final Destination
scope ExtraStages: {
  la t2, 0x8009EFA4
  Input:
    lhu t3, 0 (t2) // Get input
    ori t4, 0xFFFF
    beq t3, t4, Loop // If controller connected
    nop
    C_Up:
      ori t4, r0, 0x08
      and t5, t3, t4
      bne t4, t5, C_Right // If input == C Up
      nop
      ori t9, r0, 0x0D // Return Meta Crystal
    C_Right:
      ori t4, r0, 0x01
      and t5, t3, t4
      bne t4, t5, C_Down // If input == C Right
      nop
      ori t9, r0, 0x0E // Return Battlefield
    C_Down:
      ori t4, r0, 0x04
      and t5, t3, t4
      bne t4, t5, Loop // If input == C Down
      nop
      ori t9, r0, 0x10 // Return Final Destination
    Loop:
      addiu t2, 0x08
      la t3, 0x8009EFC4
      beq t2, t3, End
      nop
      b Input
      nop
  End:
    jr ra
    sb t9, 0x0001 (t0) // Original instruction
}

// Final Destination versus fixes
scope FinalDestination: {
  lbu v0, 0x01 (t7) // Original instruction
  ori t0, r0, 0x16
  lb t1, -0x0238 (t7)
  bne t0, t1, End // If mode == Versus
  nop
  ori t0, r0, 0x10
  bne t0, v0, End // And level == Final Destination
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
  bne t1, t2, End // If mode == Versus
  nop
  lb t1, 0x4D09 (t0)
  ori t2, r0, 0x10
  bne t1, t2, End // And level == Final Destination
  nop
  ori a1, r0, 0x19 // Return Master Hand music
  b End
  nop
  End:
    jr ra
    sw a1, 0 (t3) // Original instruction
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

// Extra costumes
// Z + C Up: Red team
// Z + C Right: Blue team
// Z + C Down: Green team
// Z + C Left: Extra team
scope ExtraCostumes: {
  Red:
    lw t0, 0x24 (sp)
    lhu t1, 0 (t0)
    ori t2, r0, 0x2008 // Z + C Up
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
    ori t2, r0, 0x2001 // Z + C Right
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
    ori t2, r0, 0x2004 // Z + C Down
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
    ori t2, r0, 0x2002 // Z + C Left
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
scope TimedStockScore: {
  ori t0, r0, 0x01
  beq t6, t0, Time
  nop
  lui t0, 0x800A
  lw t0, 0x4D1C (t0)
  beq t0, r0, TimeNoKo
  nop
  Stock:
    j 0x801373CC
    nop
  TimeNoKo: // If mode == stock and timer == 0
    lui t0, 0xA013
    ori t1, r0, 0x7025 // or t6, r0, r0
    sw t1, 0x6C1C (t0) // Don't load KOs
  Time:
    j 0x801373F4
    nop
}

fill 0x1000000 - origin() // Zero fill remainder of ROM
