// Frozen stages

constant FrozenStagesFlag(0x80500003) // Frozen stages flag location
constant FrozenStagesPtr(0x80500004) // Cursor color pointer location

// Dream Land no wind
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

// Yoshi's Island (cloudless)
origin 0x14F774
base 0x80133C04
jal FrozenYoshisIsland

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
  lua(t0, ScreenCurrent)
  lbu t0, ScreenCurrent (t0) // Mode
  lli t1, 0x16
  beq t0, t1, TrainingVersus // If mode == versus
  lli t1, 0x36
  beq t0, t1, TrainingVersus // Or mode == training
  nop
  b Original
  nop
  TrainingVersus:
    lua(t0, FrozenStagesFlag)
    lbu t0, FrozenStagesFlag (t0) // Frozen stages flag
    bnez t0, End // And frozen stages enabled; skip instruction
    nop
  Original:
    lua(t0, Stage)
    lbu t0, Stage (t0) // Stage
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
  lua(t0, ScreenCurrent)
  lbu t0, ScreenCurrent (t0) // Mode
  lli t1, 0x16
  beq t0, t1, TrainingVersus // If mode == versus
  lli t1, 0x36
  beq t0, t1, TrainingVersus // Or mode == training
  nop
  b Original
  nop
  TrainingVersus:
    lua(t0, FrozenStagesFlag)
    lbu t0, FrozenStagesFlag (t0) // Frozen stages flag
    bnez t0, End // And frozen stages enabled; skip instruction
    nop
  Original:
    lua(t0, Stage)
    lbu t0, Stage (t0) // Stage
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
    lbu t0, 0x28 (v0) // Red
    xori t0, 0xFF // Toggle red
    sb t0, 0x28 (v0)
    lbu t0, 0x2A (v0) // Blue
    xori t0, 0xFF // Toggle blue
    sb t0, 0x2a (v0)
  Original:
    jal 0x80132A58 // Original instruction
    nop
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

scope FrozenYoshisIsland: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  jal 0x80132430 // Original instruction
  nop
  lua(t0, ScreenPrevious)
  lbu t0, ScreenPrevious (t0) // Mode
  lli t1, 0x10
  beq t0, t1, TrainingVersus // If mode == versus
  lli t1, 0x12
  beq t0, t1, TrainingVersus // Or mode == training
  nop
  b End
  nop
  TrainingVersus:
    lua(t0, FrozenStagesFlag)
    lbu t0, FrozenStagesFlag (t0) // Frozen stages flag
    beqz t0, End // And frozen stages enabled
    nop
    lli t0, 0x05 // Yoshi's Island
    bne v0, t0, End // If stage == Yoshi's Island
    nop
    lli v0, 0x0C // Swap with Yoshi's Island (cloudless)
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
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
    sb t3, 0x2a (t2)
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
dd 0x00000001, 0x80106AC0, 0x00000000 // Sector Z Arwing
dd 0x00000003, 0x801082B4, 0x00000000 // Planet Zebes acid
dd 0x00000004, 0x8010A3B4, 0x00000000 // Hyrule Castle tornado
dd 0x00000006, 0x80105BE8, 0x00000000 // Dream Land wind
dd 0x00000007, 0x8010AF48, 0x8010B108 // Saffron City Pokemon
dd 0x00000008, 0x80109888, 0x00000000 // Mushroom Kingdom POW blocks
align(4)

// Object functions table
ObjectFunctionsTable:
dd 0x00000002, 0x80109E84 // Congo Jungle barrel
dd 0x00000008, 0x80109774 // Mushroom Kingdom Piranha Plants
align(4)

pushvar origin, pc
