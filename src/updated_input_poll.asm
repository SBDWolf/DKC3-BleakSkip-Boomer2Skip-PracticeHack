@include

read_poll_inputs_flag:
        LDA !poll_inputs_flag
        BEQ .read_inputs_normally
        ; we're writing inputs to custom memory addresses here
        


        LDA $04CA
        STA !custom_inputs_held
        STZ $04D8
        LDA !custom_inputs_held
        EOR !custom_inputs_previous
        AND !custom_inputs_held
        STA !custom_inputs_1f
        STA $04DC

        STZ !poll_inputs_flag

        LDA !custom_inputs_held
        STA !custom_inputs_previous

        RTL


    .read_inputs_normally:
        LDA $04CA
        STA $04D6
        STZ $04D8
        LDA $04CE
        STA $04DA
        STA $04DC

        RTL