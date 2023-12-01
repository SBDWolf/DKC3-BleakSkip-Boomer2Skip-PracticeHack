@include

handle_displays:
		; drawing this thing here i don't even remember why
		JSR draw_bleak_stuff
		SEP #$20
		LDA !fade_type
		BMI .skip_update
		LDA !timer_stopped
		BNE .draw
		
	.update:
		LDA !timer_frames
		STA !timer_disp_frames
		LDA !timer_seconds
		STA !timer_disp_seconds
		LDA !timer_minutes
		STA !timer_disp_minutes
		
	.skip_update:
		; checking here lets the timer tick on the first frame you hit the goal
		; to properly account for lag frames
		LDA !goal_flag
		CMP #$40
		BNE +
		INC !timer_stopped
	+
		
	
	
	.draw:
		REP #$20
		; starting x position
		LDX #!timer_x
		; starting y position
		LDA #!timer_y
		STA $1A
		
		LDA !timer_disp_minutes
		JSR draw_digit
		; 2 pixels padding
		INX
		INX
		; tens
		LDA !timer_disp_seconds
		LSR #4
		JSR draw_digit
		; units
		LDA !timer_disp_seconds
		AND #$000F
		JSR draw_digit
		INX
		INX
		; tens
		LDA !timer_disp_frames
		LSR #4
		JSR draw_digit
		; units
		LDA !timer_disp_frames
		AND #$000F
		JSR draw_digit
		
draw_dropped_frames:
		; starting x position
		LDX #!dropped_frames_x
		; starting y position
		LDA #!dropped_frames_y
		STA $1A
		
		; check hundreds
		LDA !dropped_frames
		CMP #$0999
		BCC .no_cap
		LDA #$0009
		JSR draw_digit
		LDA #$0009
		JSR draw_digit
		LDA #$0009
		BRA .last
		
	.no_cap:
		; hundreds
		XBA
		AND #$00FF
		JSR draw_digit
		; tens
		LDA !dropped_frames
		LSR #4
		AND #$000F
		JSR draw_digit
		; units
		LDA !dropped_frames
		AND #$000F
	.last:
		JSR draw_digit
		RTL
		
		
draw_digit:
		LDY $82
		CLC
		ADC #$01CC
		ORA $3E
		STA $0002,y
		ADC #$000A
		STA $0006,y
		TXA
		ORA $1A
		STA $0000,y
		CLC
		ADC #$0800
		STA $0004,y
		TYA
		CLC
		ADC #$0008
		STA $82
		TXA
		CLC
		ADC #$0008
		TAX
		RTS


draw_bleak_stuff:
		; only runs	if current level is bleak
		REP #$20
		LDA !current_level
		CMP #!bleak_level
		BNE +

		; drawing tens
		; starting y position
		LDA #!bleak_feedback_y
		STA $1A
		
		LDX !bleak_feedback

		LDA !bleak_early_late_flag
		BNE late1
		; early case here
		LDA #$0000
		SEP #$20
		; $BAC000 = digits_table
		LDA $BAC000, X
		REP #$20
		LSR
		LSR
		LSR
		LSR
		AND #$000F
		CLC
		ADC #$0200
		BRA finalize_tens_draw

		late1:
		LDA #$0000
		SEP #$20
		; $BAC000 = digits_table
		LDA $BAC000, X
		REP #$20
		LSR
		LSR
		LSR
		LSR
		AND #$000F
		CLC
		ADC #$0600

		finalize_tens_draw:
		; starting x position
		LDX #!bleak_feedback_x

		JSR draw_digit

		; drawing units
		; starting y position
		
		TXY
		LDX !bleak_feedback

		LDA !bleak_early_late_flag
		BNE late2
		; early case here
		LDA #$0000
		SEP #$20
		; $BAC000 = digits_table
		LDA $BAC000, X
		REP #$20
		AND #$000F
		ADC #$0200
		BRA finalize_units_draw

		late2:
		LDA #$0000
		SEP #$20
		; $BAC000 = digits_table
		LDA $BAC000, X
		REP #$20
		AND #$000F
		ADC #$0600

		finalize_units_draw:
		
		; starting x position
		TYX

		JSR draw_digit

		+:
		RTS

if !rom_revision == 0
; this is called during vblank due to needing to update CGRAM
draw_boomer_stuff:
		; restore hijacked instructions
		LDA #$0000
		TCD
		CLD

		; only runs	if in boomer's house
		SEP #$20
		LDA !house_index_maybe
		CMP #$0C
		REP #$20
		BNE +

		; drawing tens
		; starting y position
		LDA #!boomer_feedback_y
		STA $1A
		
		LDA !boomer_feedback
		LSR
		LSR
		LSR
		LSR
		AND #$000F


		; starting x position
		LDX #!boomer_feedback_x

		JSR draw_digit

		; drawing units
		; starting y position

		LDA !boomer_feedback
		AND #$000F

		JSR draw_digit

		LDA !boomer_early_late_value
		BEQ perfect

		; skip updating kong color palette if already done. not doing so may cause glitches on console??
		LDA !already_changed_kong_colors
		BNE +
		; change kong color palette depending on B press timing

		SEP #$30
		LDA #$C0
		STA $2121		; CGRAM ACCESS ADDRESS
		LDX #$3F		; loop size

		LDA !boomer_early_late_value
		CMP #$02
		BNE early

		; if late
		LDA #$4D
		BRA write_to_cgram

		early:
		LDA #$2A

		write_to_cgram:	    
-:		STA $2122
		DEX
		BPL -
		REP #$30


		LDA #$0001
		STA !already_changed_kong_colors
		bra +


		perfect:
		LDA #$0000
		STA !already_changed_kong_colors
		+:

		RTL
endif