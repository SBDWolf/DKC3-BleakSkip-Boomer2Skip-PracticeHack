@include

every_frame:
		LDA !counter_60hz
		SEC
		SBC !previous_60hz
		STA !real_frames_elapsed
		DEC
		BMI .end
		SED
		CLC
		ADC !dropped_frames
		STA !dropped_frames
		CLD
	.end:
		LDA !counter_60hz
		STA !previous_60hz
		
if !rom_revision == 0
	; quick and dirty fix for making the timer run inside boomer's house
	; if you're inside boomer's house, also tick the timer
		SEP #$20
		LDA !house_index_maybe
		CMP #$0C
		REP #$20
		BNE +

		JSL every_igt_frame

+		
endif
		LDA $4C
		STA $4A
		RTL


		