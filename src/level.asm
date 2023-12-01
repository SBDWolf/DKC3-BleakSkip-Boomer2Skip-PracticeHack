@include

on_goal:
		STA !goal_flag
		JML $BEC02A


every_igt_frame:
		JSR tick_timer

if !rom_revision == 0
		; if inside boomer's house, don't restore hijacked instructions and don't run bleak code
		SEP #$20
		LDA !house_index_maybe
		CMP #$0C
		REP #$20
		BEQ +
endif
		INC $00
		INC $C2
		JSR bleak_stuff

		RTL

if !rom_revision == 0
+		
		JSR boomer_stuff
		RTL
endif	
		
; bonus intro
every_intermission_frame:
		JSR tick_timer
		INC $00
		INC $F4
		RTL
		
		
tick_timer:
		; decimal mode
		SEP #$28
		LDA !timer_stopped
		BNE .done
		
		; skip if game is paused
		BIT !pause_flags
		BVS .done
		
		LDA !timer_frames
		CLC
		ADC !real_frames_elapsed
		STA !timer_frames
		CMP #$60
		BCC .done
		
		SBC #$60
		STA !timer_frames
		TDC
		ADC !timer_seconds
		STA !timer_seconds
		CMP #$60
		BCC .done
		
		SBC #$60
		STA !timer_seconds
		TDC
		ADC !timer_minutes
		STA !timer_minutes
		CMP #$10
		BCC .no_cap
		LDA #$59
		STA !timer_frames
		LDA #$59
		STA !timer_seconds
		LDA #$59
	.no_cap:
		STA !timer_minutes
	.done:
		REP #$28
		RTS

bleak_stuff:
		; only runs	if current level is bleak
		LDA !current_level
		CMP #!bleak_level
		BEQ +
		RTS
		+:
		; don't run if it's too early in the death animation, this is necessary because of how death_timer works
		LDA !approaching_fadeout
		CMP #!approaching_fadeout_value
		BEQ +
		RTS
		+:
		; todo: add case where you don't run this if game is paused
		; checks if start has been pressed
		LDA !current_inputs_1f
		AND #$1000
		BNE +
		RTS
		+:
		LDA !death_timer
		CMP #$8000
		BCS late_start_press
		; the following is the case for the early start press, instead:
		STA !bleak_feedback
		RTS

		late_start_press:
		LDA #$FFFF
		SBC !death_timer
		ADC #$0046
		STA !bleak_feedback
		LDA #$0001
		STA !bleak_early_late_flag
		RTS

if !rom_revision == 0
boomer_stuff:
		; writing my own routine that polls for inputs, because after boomer's first textbox the game stops polling for inputs
		LDA #$0001
		STA !poll_inputs_flag
		JSL $808015

		LDA !custom_inputs_1f
		AND #$8000
		BEQ +

		; boomer skip wil work on lui timer 1s54f (internally, the visual will display 1s52f instead)
		LDA !timer_seconds
		ASL
		TAX
		LDA.l boomer_lui_timer_lookup_table, x
		SEP #$08			; set decimal mode
		CLC
		ADC !timer_frames
		STA !boomer_lui_timer_converted
		REP #$08
		CMP #$0114

		BCS boomer_late_start_press
		; the following is the case for the early start press, instead:
		SEP #$08			; set decimal mode
		SEC
		LDA #$0114
		SBC !boomer_lui_timer_converted
		STA !boomer_feedback
		REP #$08

		LDA #$0001
		STA !boomer_early_late_value
		RTS

		boomer_late_start_press: 
		SEP #$08			; set decimal mode
		SEC
		LDA !boomer_lui_timer_converted
		SBC #$0114
		STA !boomer_feedback
		REP #$08
		BEQ ++
		; if late
		LDA #$0002
		STA !boomer_early_late_value
		BRA ++
		; if perfect
		LDA #$0000
		STA !boomer_early_late_value
++		RTS
		+:
		RTS

boomer_lui_timer_lookup_table:
	dw $0000, $0060, $0120, $0180, $0240, $0300, $0360, $0420, $0480
endif