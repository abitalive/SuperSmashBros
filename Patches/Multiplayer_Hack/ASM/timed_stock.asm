// Timed stock battles

// Prevent sudden death
origin 0x10A4EC
base 0x8018D5FC
lbu t6, 0x03 (t5)
lui a0, 0x800A
addiu a0, a0, 0x4EF8
lli t7, 0x01
beq t6, t7, 0x8018D61C

origin 0x1241A0
base 0x801337F0
addiu t8, r0, 0x03

origin 0x1241B4
base 0x80133804
addiu t9, r0, 0x03

// Show stock icons
origin 0x1389F8
base 0x8013A778
lli t6, 0x01
bnel t5, t6, 0x8013A790

// Show correct places
origin 0x155DA8
base 0x80136C08
j TimeScoring
nop

// Show correct places
origin 0x156564
base 0x801373C4
j TimedStock

pullvar pc, origin

scope TimeScoring: {
  lui t6, 0x800A
  lbu t6, 0x4D0B (t6) // Mode
  lli t7, 0x01
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
  lli t0, 0x01
  beq t6, t0, Time // If mode == time use time scoring
  nop
  lui t0, 0x800A
  lw t0, 0x4D1C (t0) // Timer
  beqz t0, Time // Else if timer == 0 use time scoring
  nop
  Stock:
    j 0x801373CC // Else use stock scoring
    nop
  Time:
    j 0x801373F4
    nop
}

pushvar origin, pc
