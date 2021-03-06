// Frozen stages

constant FrozenStagesFlag(0x80500003) // Frozen stages flag location
constant FrozenStagesPtr(0x80500004) // Cursor color pointer location

// Dream Land wind
origin 0x081734
base 0x80105F34
jal FrozenHazard

// Sector Z Arwing
origin 0x08364C
base 0x80107E4C
jal FrozenHazard

// Planet Zebes acid
origin 0x083C10
base 0x80108410
jal FrozenHazard

// Mushroom Kingdom POW blocks
origin 0x0851AC
base 0x801099AC
jal FrozenHazard

// Mushroom Kingdom Piranha Plants
origin 0x085424
base 0x80109C24
jal FrozenObject

// Congo Jungle barrel
origin 0x0857BC
base 0x80109FBC
jal FrozenObject

// Hyrule Castle tornadoes
origin 0x086160
base 0x8010A960
jal FrozenHazard

// Saffron City Pokemon
origin 0x086974
base 0x8010B174
jal FrozenHazard
nop
nop

// Save pointer to cursor color
origin 0x14E6A8
base 0x80132B38
jal CursorColorPtr

// Initial color
origin 0x14E6DC
base 0x80132B6C
jal CursorColorInitial

// Yoshi's Island cloudless (random)
origin 0x14F74C
base 0x80133BDC
jal FrozenYoshisIsland0
nop
nop

// Yoshi's Island cloudless
origin 0x14F784
base 0x80133C14
jal FrozenYoshisIsland1

// L or R button pressed
origin 0x14F9D4
base 0x80133E64
jal CursorColorToggle
nop

// Disable original L button behavior
origin 0x14FC54
base 0x801340E4
lli a0, 0x0202

// Disable original R button behavior
origin 0x14FD58
base 0x801341E8
lli a0, 0x0101

pullvar pc, origin

scope FrozenHazard: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  lua(t0, FrozenStagesFlag)
  lbu t0, FrozenStagesFlag (t0) // Frozen stages flag
  beqz t0, Original // If frozen stages enabled
  nop
  lua(t0, ScreenCurrent)
  lbu t0, ScreenCurrent (t0) // Mode
  lli t1, 0x16
  beq t0, t1, End // And mode == versus; skip instruction(s)
  lli t1, 0x36
  beq t0, t1, End // Or mode == training; skip instruction(s)
  nop
  Original:
    lua(t0, StagePtr)
    lw t0, StagePtr (t0) // Stage pointer
    lbu t0, 0x01 (t0) // Stage
    lua(t1, HazardFunctionsTable) // Pointer to lookup stage
    Loop:
      lw t2, HazardFunctionsTable (t1)
      bnel t0, t2, Loop // Break if stage == lookup stage
      addiu t1, 0x0C // Update pointer for next stage
    lw t3, HazardFunctionsTable + 4 (t1) // Hazard function 1
    jalr t3
    sw t1, 0x10 (sp) // Save t1
    lw t1, 0x10 (sp) // Restore t1
    lw t3, HazardFunctionsTable + 8 (t1) // Hazard function 2
    beqz t3, End // If hazard function 2 != 0
    nop
    jalr t3
    nop
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

scope FrozenObject: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  lua(t0, FrozenStagesFlag)
  lbu t0, FrozenStagesFlag (t0) // Frozen stages flag
  beqz t0, Original // If frozen stages enabled
  nop
  lua(t0, ScreenCurrent)
  lbu t0, ScreenCurrent (t0) // Mode
  lli t1, 0x16
  beq t0, t1, End // And mode == versus; skip instruction
  lli t1, 0x36
  beq t0, t1, End // Or mode == training; skip instruction
  nop
  Original:
    lua(t0, StagePtr)
    lw t0, StagePtr (t0) // Stage pointer
    lbu t0, 0x01 (t0) // Stage
    lua(t1, ObjectFunctionsTable) // Pointer to lookup stage
    Loop:
      lw t2, ObjectFunctionsTable (t1)
      bnel t0, t2, Loop // Break if stage == lookup stage
      addiu t1, 0x08 // Update pointer for next stage
    lw t3, ObjectFunctionsTable + 4 (t1) // Object function
    jalr t3
    nop
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

scope CursorColorPtr: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  jal 0x800CCFDC // Original instruction
  nop
  lua(t0, FrozenStagesPtr)
  sw v0, FrozenStagesPtr (t0) // Save pointer to cursor color
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

scope CursorColorInitial: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  lua(t0, FrozenStagesFlag)
  lbu t0, FrozenStagesFlag (t0) // Frozen stages flag
  beqz t0, Original // If frozen stages enabled
  nop
  Toggle:
    sb r0, 0x28 (v0) // Red
    lli t0, 0xFF
    sb t0, 0x2A (v0) // Blue
  Original:
    jal 0x80132A58 // Original instruction
    nop
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

scope FrozenYoshisIsland0: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  lua(t0, FrozenStagesFlag)
  lbu t0, FrozenStagesFlag (t0) // Frozen stages flag
  beqz t0, Original // If frozen stages enabled
  nop
  lli t0, 0x05 // Yoshi's Island
  bne v0, t0, Original // And stage == Yoshi's Island
  nop
  lli v0, 0x0C // Swap with Yoshi's Island cloudless
  Original:
    move s0, v0 // Original instructions
    jal 0x80131BAC
    move a0, v0
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

scope FrozenYoshisIsland1: {
  lua(t0, FrozenStagesFlag)
  lbu t0, FrozenStagesFlag (t0) // Frozen stages flag
  beqz t0, End // If frozen stages enabled
  nop
  lli t0, 0x05 // Yoshi's Island
  bne v0, t0, End // And stage == Yoshi's Island
  nop
  lli v0, 0x0C // Swap with Yoshi's Island cloudless
  End:
    jr ra
    sb v0, 0x000F (s1) // Original instruction
}

scope CursorColorToggle: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  jal 0x8039076C
  lli a0, 0x0030 // L+R
  beqz v0, Original // If L or R Pushed
  nop
  Toggle:
    lui t0, 0x8050
    lbu t1, FrozenStagesFlag (t0) // Frozen stages flag
    xori t1, 0x01 // Toggle flag
    sb t1, FrozenStagesFlag (t0)
    lw t2, FrozenStagesPtr (t0)
    lbu t3, 0x28 (t2) // Red
    xori t3, 0xFF // Toggle red
    sb t3, 0x28 (t2)
    lbu t3, 0x2A (t2) // Blue
    xori t3, 0xFF // Toggle blue
    sb t3, 0x2A (t2)
  Original:
    jal 0x8039076C
    lli a0, 0x9000
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

// Hazard functions table
HazardFunctionsTable:
dw 0x00000001, 0x80106AC0, 0x00000000 // Sector Z Arwing
dw 0x00000003, 0x801082B4, 0x00000000 // Planet Zebes acid
dw 0x00000004, 0x8010A3B4, 0x00000000 // Hyrule Castle tornado
dw 0x00000006, 0x80105BE8, 0x00000000 // Dream Land wind
dw 0x00000007, 0x8010AF48, 0x8010B108 // Saffron City Pokemon
dw 0x00000008, 0x80109888, 0x00000000 // Mushroom Kingdom POW blocks

// Object functions table
ObjectFunctionsTable:
dw 0x00000002, 0x80109E84 // Congo Jungle barrel
dw 0x00000008, 0x80109774 // Mushroom Kingdom Piranha Plants

pushvar origin, pc
