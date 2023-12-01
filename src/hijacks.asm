@include

org hijack_every_frame
		JSL every_frame
		
org hijack_level
		JSL every_igt_frame
		
org hijack_bonus_intro
		JSL every_intermission_frame
		
org hijack_map
		JSR hijack_map_jump
		
org $B4FFFB
hijack_map_jump:
		JSL every_map_frame
		RTS
		
org hijack_lives
		JSL handle_displays
		NOP
		RTS
		
org hijack_goal
		JSL on_goal

if !rom_revision == 0
org input_poll_hijack
		jsl read_poll_inputs_flag
		nop #14

; nmi hijack
org $80CA4F
		JSL draw_boomer_stuff
		nop 
endif	