// Super Smash Bros. Multiplayer ROM Hack by Abitalive

arch n64.cpu
endian msb
//output "", create

include "..\LIB\N64.inc"
include "..\LIB\macros.inc"

origin 0x0
insert "..\LIB\Super Smash Bros. (U) [!].z64"

// Unlock Everything
origin 0x42B3B
dl 0xFFFFFF

// Boot to Character Selection Screen
origin 0x42CD0
db 0x10

// All Computers Are Level 9 By Default
origin 0x42D38
db 0x09
origin 0x42DAC
db 0x09
origin 0x42E20
db 0x09
origin 0x42E94
db 0x09

// Default Settings
origin 0x42D1B
db 0x02 // Stock
origin 0x42D1E
db 0x05 // 5 Stock
origin 0x42D1F
db 0x04 // 5 Minutes
origin 0x42D22
db 0x00 // All Random Off

// Planet Zebes No Acid
origin 0xAa04C
dd 0x801056F8

// Random Stage Fixes
origin 0xA7D6B
db 0x0D // Meta Crystal
origin 0xA7D73
db 0x0C // Battlefield
origin 0xA7D7B
db 0x0A // Final Destination
origin 0x14F748
addiu a0, r0, 0x000C

// Final Destination Fixes
origin 0x80414
addiu v0, r0, 0x000E
origin 0x189E2B
db 0x18
origin 0x640CD2
dw 0xC33E

// Disable Original Stage Select Option Behavior
origin 0x138C6C
nop
nop

// Disable Original C Button Behavior on Stage Selection Screen
origin 0x14FAB0
addiu a0, r0, 0x0800 // Up

origin 0x14FB84
addiu a0, r0, 0x0400 // Down

origin 0x14FC54
addiu a0, r0, 0x0220 // Left

origin 0x14FD58
addiu a0, r0, 0x0110 // Right

// Disable Character Selection Screen Timeout (Versus)
origin 0x138BDC
beq r0, r0, 0x138C04

// Hooks

// Extra Stages
origin 0x10B0B8 // Hook (RAM 0x8018E1C8)
jal 0x801080EC // ROM 0x838EC

// Random CPU
origin 0x138F5C // Hook (RAM 0x8013ACDC)
j 0x80108138

// Random All Players
origin 0x138CC0 // Hook (RAM 0x8013AA40)
jal 0x80108178

// Functions
origin 0x838EC // Replaces Planet Zebes acid function (RAM 0x801080EC)

// Extra Stages
// C Up: Meta Crystal
// C Right: Battlefield
// C Down: Final Destination
lui t2, 0x800A
lh t2, 0xEFA4 (t2) // Load buttons
ori t3, r0, 0x0008 // C Up
and t4, t2, t3
bne t3, t4, Next01 // Button check
nop
addiu t9, r0, 0x000D // Meta Crystal
Next01:
  ori t3, r0, 0x0001 // C Right
  and t4, t2, t3
  bne t3, t4, Next02 // Button check
  nop
  addiu t9, r0, 0x000E // Battlefield
Next02:
  ori t3, r0, 0x0004 // C Down
  and t4, t2, t3
  bne t3, t4, Skip01 // Button check
  nop
  addiu t9, r0, 0x0010 // Final Destination
Skip01:
  jr ra
  sb t9, 0x0001 (t0) // Original instruction at 0x10B0B8 (RAM 0x8018E1C8)

// Random CPU (RAM 0x80108138)
addiu sp, sp, 0xFFE8
sw ra, 0x0014 (sp)
sh r0, 0x00AC (v0) // Original instruction at 0x138F5C (RAM 0x8013ACDC)
addu a2, v0, r0 // Backup v0
addu a3, v1, r0 // Backup v1
addiu v0, r0, 0x0001
bne a1, v0, Skip02 // CPU/Human check
nop
jal 0x80018a30 // Generate random character
addiu a0, r0, 0x000B // Range = 0x00-0x0B
addu t0, v0, r0 // Change character
Skip02:
  addu v0, a2, r0 // Restore v0
  addu v1, a3, r0 // Restore v1
  lw ra, 0x0014 (sp)
  j 0x8013ACE4
  addiu sp, sp, 0x0018

// Random All Players
addiu sp, sp, 0xFFE8
sw ra, 0x0014 (sp)
lui t0, 0x800A
ori t0, t0, 0x4D12
lb t0, 0x0000 (t0) // Load options
beq t0, r0, Skip03 // Options check
nop
lui a2, 0x8013
jal 0x801081C4 // Randomize
ori a3, a2, 0xBAD3 // P1
jal 0x801081C4 // Randomize
ori a3, a2, 0xBB8F // P2
jal 0x801081C4 // Randomize
ori a3, a2, 0xBC4B // P3
jal 0x801081C4 // Randomize
ori a3, a2, 0xBD07 // P4
Skip03:
  lw ra, 0x0014 (sp)
  j 0x8013A664 // Return
  addiu sp, sp, 0x0018

Randomize:
  addiu sp, sp, 0xFFE8
  sw ra, 0x0014 (sp)
  lbu t1, 0x0000 (a3) // Load active player
  addiu t2, r0, 0x001C
  beq t1, t2, Skip04 // Active player check
  nop
  jal 0x80018a30 // Generate random character
  addiu a0, r0, 0x000B // Range = 0x00-0x0B
  sb v0, 0x0000 (a3) // Change character
Skip04:
  lw ra, 0x0014 (sp)
  jr ra
  addiu sp, sp, 0x0018
