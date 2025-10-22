module metro_turnstile(
    input clk,
    input rset,
    input validate_code,
    input [3:0] access_code,  //access pass code
    output reg open_access_door,
    output [1:0] state_out 
);

    //declaration of state values
    parameter [1:0] IDLE = 2'b0,
                    CHECK_CODE = 2'b01,
                    ACCESS_GRANTED = 2'b10;

    //logic for state machines
    reg [1:0] state;
    reg [1:0] next_state;
    reg [3:0] timer;            //counter that keeps the gate open

    //nxt state logic
    always @(*) begin
        next_state = IDLE;
        open_access_door = 0;
        case(state)
            IDLE : begin
                    if(validate_code)
                        next_state = CHECK_CODE;
                    end
            CHECK_CODE : begin
                            if((access_code>=4'd4) && (access_code <= 4'd11))
                                next_state = ACCESS_GRANTED;
                    end
            ACCESS_GRANTED : begin
                                open_access_door = 1;
                                if(timer == 4'hF)
                                    next_state = IDLE;
                                else
                                    next_state = ACCESS_GRANTED;
                    end
            default : next_state = IDLE; //to avoid latch formation or stuck in the FSM
        endcase
    end

    //state sequencer logic and it is similar to pipo register
    always @(posedge clk or negedge rset) begin
        if(!rset)    //active low reset
            state <= IDLE;
        else   
            state <= next_state;
    end

    assign state_out = state;

    //timer logic
    always @(posedge clk or negedge rset) begin
        if(!rset)
            timer <= 0;
        else if (state == ACCESS_GRANTED)
            timer <= timer + 1'b1;
        else
            timer <= 0;
    end
    
endmodule