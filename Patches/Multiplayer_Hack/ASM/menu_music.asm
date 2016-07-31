// Menu music

constant SramTrackMenu(0x7F00) // Menu track variable SRAM location
constant TrackMenu(0x80500002) // Menu track variable location

origin 0x050038
base 0x800D4658
jal MenuMusicRead

origin 0x0500A8
base 0x800D46C8
jal MenuMusicInit

// Boot
origin 0x11DAAC
base 0x80132B1C
jal MenuMusic

// Back from 1P/training/bonus practice css
origin 0x11F118
base 0x80133008
jal MenuMusic

// Back from screen adjust
origin 0x120D58
base 0x801335A8
jal MenuMusic

// Back from sound test
origin 0x1222F8
base 0x80132EA8
jal MenuMusic

// Back from versus css
origin 0x1250F0
base 0x80134740
jal MenuMusic

// Versus css
origin 0x139578
base 0x8013B2F8
jal MenuMusic

// 1P css
origin 0x140734
base 0x80138534
jal MenuMusic

// Training css
origin 0x1474B4
base 0x80137ED4
jal MenuMusic

// Bonus practice css
origin 0x14CF08
base 0x80136ED8
jal MenuMusic

// Versus record
origin 0x15D4F8
base 0x801365B8
jal MenuMusic

// Characters
origin 0x160084
base 0x80134034
jal MenuMusic

// Characters
origin 0x121E40
base 0x801329F0
jal MenuMusicChange

// Versus record
origin 0x121E98
base 0x80132A48
jal MenuMusicChange

// Screen adjust
origin 0x12FC20
base 0x801327C0
jal MenuMusicChange

// Back from 1P css
origin 0x13EEDC
base 0x80136CDC
jal MenuMusicChange

// Back from versus css
origin 0x1363A0
base 0x80138120
jal MenuMusicChange

// Back from bonus practice css
origin 0x14B7B4
base 0x80135784
jal MenuMusicChange

// Back from training css
origin 0x144DD0
base 0x801357F0
jal MenuMusicChange

// Back from sound test
origin 0x188644
base 0x80132274
jal MenuMusicChange

origin 0x188548
base 0x80132178
jal MenuMusicSave

pullvar pc, origin

scope MenuMusicRead: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  jal SramRead // Original instruction
  nop
  lli a0, SramTrackMenu // SRAM source
  addiu a1, sp, 0x10 // RAM destination
  jal SramRead
  lli a2, 0x01 // Size
  lbu t0, 0x10 (sp)
  lua(t1, TrackMenu)
  sb t0, TrackMenu (t1)
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

scope MenuMusicInit: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  jal 0x800D45F4 // Original instruction
  nop
  lua(t0, TrackMenu)
  lli t1, 0x2C
  sb t1, TrackMenu (t0)
  sb t1, 0x10 (sp)
  addiu a0, sp, 0x10 // RAM source
  lli a1, SramTrackMenu // SRAM destination
  jal SramWrite // SRAM Write
  lli a2, 0x01 // Size
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

scope MenuMusic: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  lua(t0, TrackMenu)
  lbu t0, TrackMenu (t0) // Saved track
  lli t1, 0x2C
  beq t0, t1, Original // If saved track == 0x2C (menu); use original track
  nop
  lua(t1, ScreenPrevious)
  lbu t1, ScreenPrevious (t1) // Last screen
  lli t2, 0x01
  beq t1, t2, SavedTrack // Else if last screen == title screen; use saved track
  lli t2, 0x16
  beq t1, t2, SavedTrack // Or last screen == versus; use saved track
  lli t2, 0x18
  beq t1, t2, SavedTrack // Or last screen == results screen; use saved track
  lli t2, 0x1B
  beq t1, t2, SavedTrack // Or last screen == boot; use saved track
  lli t2, 0x34
  beq t1, t2, SavedTrack // Or last screen == 1p game; use saved track
  lli t2, 0x35
  beq t1, t2, SavedTrack // Or last screen == bonus practice; use saved track
  lli t2, 0x36
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
    move a1, t0 // Use saved track
  Original:
    jal 0x80020AB4 // Original instructions
    or a0, r0, r0
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

scope MenuMusicChange: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  SavedTrack:
    lua(t0, TrackMenu)
    lbu t0, TrackMenu (t0) // Saved track
    lli t1, 0x2C
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

scope MenuMusicSave: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  lua(t0, TrackMenu)
  sb a1, TrackMenu (t0) // Save a1
  addiu a0, sp, 0x10 // RAM source
  sb a1, 0 (a0)
  lli a1, SramTrackMenu // SRAM destination
  jal SramWrite // SRAM Write
  lli a2, 0x01 // Size
  lua(t0, TrackMenu)
  lbu a1, TrackMenu (t0) // Restore a1
  jal 0x80020AB4 // Original instructions
  or a0, r0, r0
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

pushvar origin, pc
