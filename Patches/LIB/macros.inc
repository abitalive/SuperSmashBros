// Common macros

macro luia(reg, evaluate addr) {
   if (({addr} & 0x8000) > 0) {
      lui {reg}, (1 + ({addr} >> 16))
   } else {
      lui {reg}, ({addr} >> 16)
   }
}
