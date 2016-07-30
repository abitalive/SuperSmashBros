// Default versus settings

constant DefMode(0x03) // Default versus mode
constant DefTime(0x08) // Default time
constant DefStock(0x04) // Default stock
constant DefItem(0x00) // Default item appearance%
constant DefCpu(0x09) // Default CPU level

origin 0x040898
base 0x800A1B48
jal DefaultVersus

pullvar pc, origin

scope DefaultVersus: {
  lli t5, DefMode
  sb t5, 0x4D0B (t6) // Versus mode
  lli t5, (DefTime << 8) + DefStock
  sh t5, 0x4D0E (t6) // Time + stock
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
