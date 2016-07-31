// Default versus settings

constant DefMode(0x03) // Default versus mode (01 = time, 02 = stock, 03 = time+stock)
constant DefTime(0x08) // Default time (00-99, 100 = infinite)
constant DefStock(0x04) // Default stock (00-98)
constant DefHandicap(0x00) // Default handicap (00 = off, 01 = on, 02 = auto)
constant DefTeamAttack(0x00) // Default team attack (00 = off, 01 = on)
constant DefStage(0x01) // Default stage select (00 = off, 01 = on)
constant DefDamage(0x64) // Default damage% (50-200)
constant DefItem(0x00) // Default item appearance% (00-05)
constant DefCpu(0x09) // Default CPU level (01-09)

origin 0x040898
base 0x800A1B48
jal DefaultVersus

pullvar pc, origin

scope DefaultVersus: {
  lli t5, DefMode
  sb t5, 0x4D0B (t6) // Versus mode
  lli t5, (DefTime << 8) + DefStock
  sh t5, 0x4D0E (t6) // Time + stock
  lli t5, (DefHandicap << 8) + DefTeamAttack
  sh t5, 0x4D10 (t6) // Handicap + team attack
  lli t5, (DefStage << 8) + DefDamage
  sh t5, 0x4D12 (t6) // Stage select + damage%
  lli t5, DefItem
  sb t5, 0x4D24 (t6) // Item appearance%
  lli t5, DefCpu
  sb t5, 0x4D28 (t6) // CPU levels
  sb t5, 0x4D9C (t6)
  sb t5, 0x4E10 (t6)
  sb t5, 0x4E84 (t6)
  End:
    jr ra
    lw t5, 0 (t1) // Original instruction
}

pushvar origin, pc
