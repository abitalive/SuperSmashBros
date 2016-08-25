// Super Smash Bros. Multiplayer ROM Hack by abitalive

arch n64.cpu
endian msb
//output "", create

include "..\LIB\functions.inc"
include "..\LIB\macros.inc"
include "..\LIB\N64.inc"
include "..\LIB\variables.inc"

origin 0x0
insert "..\LIB\Super Smash Bros. (U) [!].z64"

origin 0xF5F4E0
base 0x80400000
pushvar origin, pc

include "ASM\initialize.asm"

include "ASM\allow_start_immediately.asm"
include "ASM\boot_to_css.asm"
include "ASM\css_time.asm"
include "ASM\css_toggle.asm"
include "ASM\default_settings.asm"
//include "ASM\disable_music.asm"
include "ASM\extra_costumes.asm"
include "ASM\extra_stages.asm"
include "ASM\final_destination.asm"
include "ASM\frozen_stages.asm"
include "ASM\full_results_screen.asm"
include "ASM\menu_music.asm"
include "ASM\neutral_spawns.asm"
include "ASM\preview_y_fix.asm"
include "ASM\quick_reset.asm"
include "ASM\random_stage_fix.asm"
include "ASM\stage_music.asm"
include "ASM\stock_handicap.asm"
include "ASM\timed_stock.asm"
include "ASM\title_screen_timeouts.asm"
include "ASM\unlock_everything.asm"
include "ASM\volume_fix.asm"
