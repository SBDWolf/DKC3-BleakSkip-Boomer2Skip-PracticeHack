@include

; define rom locations based on rom revision
if !rom_revision == 0
	hijack_every_frame = $808389
	hijack_level = $808353
	hijack_bonus_intro = $808379
	freerom = $B3F957
	hijack_map = $B4B293
	hijack_goal = $B8ABE3
	hijack_lives = $BBB16C
	end_bananas = $BBB310
	input_poll_hijack = $808A5B
elseif !rom_revision == 1
	hijack_every_frame = $808378
	hijack_level = $808342
	hijack_bonus_intro = $808368
	freerom = $B3F957
	hijack_map = $B4B17B
	hijack_goal = $B8AC02
	hijack_lives = $BBB17E
	end_bananas = $BBB322
elseif !rom_revision == 2
	hijack_every_frame = $808378
	hijack_level = $808342
	hijack_bonus_intro = $808368
	freerom = $B9F907
	hijack_map = $B4B189
	hijack_goal = $B8AC23
	hijack_lives = $BBB17E
	end_bananas = $BBB322
endif

; constants
!dropped_frames_x = $0008
!dropped_frames_y = $0900
!timer_x = $00CC
!timer_y = $0900
!bleak_feedback_x = $0080
!bleak_feedback_y = $0900
!bleak_level = $0021
!approaching_fadeout_value = $0010
!boomer_feedback_x = $0094
!boomer_feedback_y = $9000


; wram
!freeram = $1E30

!freeram_used = 0
macro def_freeram(id, size)
	!<id> := !freeram+!freeram_used
	!freeram_used #= !freeram_used+<size>
endmacro

!current_level = $00C0
!house_index_maybe = $0070	; contains 0x12 inside boomer's house
!death_timer = $1C05
; this variable is used to make sure the checks for bleak's framer only run right at the appropriate times
; otherwise death_timer would use the same value on multiple occurrences and trigger the checks at inappropriate times
!approaching_fadeout = $08B6
!current_inputs_1f = $04DA
!fade_type = $04ED


if !rom_revision == 0
	!pause_flags = $05AF
else
	!pause_flags = $05B5
endif

!counter_60hz = $5A

%def_freeram(previous_60hz, 2)

%def_freeram(dropped_frames, 2)
%def_freeram(real_frames_elapsed, 2)

%def_freeram(timer_frames, 2)
%def_freeram(timer_seconds, 2)
%def_freeram(timer_minutes, 2)

%def_freeram(timer_disp_frames, 2)
%def_freeram(timer_disp_seconds, 2)
%def_freeram(timer_disp_minutes, 2)

%def_freeram(timer_stopped, 2)

%def_freeram(goal_flag, 2)



%def_freeram(bleak_feedback, 2)

%def_freeram(bleak_early_late_flag, 2)

%def_freeram(custom_inputs_previous, 2)

%def_freeram(custom_inputs_held, 2)

%def_freeram(custom_inputs_1f, 2)

%def_freeram(poll_inputs_flag, 2)

%def_freeram(boomer_feedback, 2)

%def_freeram(boomer_lui_timer_converted, 2)

%def_freeram(boomer_early_late_value, 2)

%def_freeram(already_changed_kong_colors, 2)


assert !freeram+!freeram_used < $2000, "exceeded freeram area"
