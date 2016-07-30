// Super Smash Bros. functions

constant DmaCopy(0x80002CA0)
// a0 = ROM source
// a1 = RAM destination
// a2 = Size

constant SramRead(0x80002DA4)
// a0 = SRAM source
// a1 = RAM destination
// a2 = Size

constant SramWrite(0x80002DE0)
// a0 = RAM source
// a1 = SRAM destination
// a2 = Size

constant RandomInt(0x80018A30)
// a0 = Range
// v0 = Random integer
