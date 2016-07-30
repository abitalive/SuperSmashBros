// Stock handicap

// Disable original handicap behavior
origin 0x10A38C
base 0x8018D49C
lli t9, 0x09

// Stock count
origin 0x10A3A4
base 0x8018D4B4
jal StockHandicap

// Use places for auto
origin 0x156C5C
base 0x80137ABC
addiu t3, t3, 0x9BB0

// Use places for auto
origin 0x156CBC
base 0x80137B1C
addiu t3, t3, 0x9BB0

// Use places for auto
origin 0x156DA4
base 0x80137C04
addiu t3, t3, 0x9BB0

// Use places for auto
origin 0x157370
base 0x801381D0
addiu t3, t3, 0x9BB0

// Use places for auto
origin 0x1573D0
base 0x80138230
addiu t3, t3, 0x9BB0

// Use places for auto
origin 0x1574B8
base 0x80138318
addiu t3, t3, 0x9BB0

// Use places for auto
origin 0x157898
base 0x801386F8
move a0, v0 // Winner
jal 0x80138548
lw a1, 0x18 (sp) // Loser

pullvar pc, origin

scope StockHandicap: {
  lui t0, 0x800A
  lbu t0, 0x4D10 (t0) // Handicap flag
  beqz t0, End // If handicap enabled
  nop
  lbu t8, 0x21 (v1) // Stocks = handicap
  addiu t8, -0x01
  End:
    jr ra
    sb t8, 0x77 (sp) // Original instruction
}

pushvar origin, pc
