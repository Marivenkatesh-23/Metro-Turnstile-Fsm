`include "metro_turnstile.v"

module tb_metro_turnstile();

    reg clk = 0;
    reg rset;
    reg validate_code;
    reg [3:0] access_code;
    wire open_access_door;
    wire [1:0] state_out;

    metro_turnstile MT(
        .clk(clk),
        .rset(rset),
        .validate_code(validate_code),
        .access_code(access_code),
        .open_access_door(open_access_door),
        .state_out(state_out)
    );

    always #1 clk = ~clk;

    initial begin
        $monitor($time," access_code = %4b,state_out = %2b, open_access_door = %b",
                        access_code,state_out,open_access_door);
        rset = 0; 
        validate_code = 0; access_code = 0;
        #2.5; rset  = 1;
        
        @(posedge clk);
        validate_code = 1; access_code = 0;
        @(posedge clk);
        validate_code = 1; access_code = 0;
        @(posedge clk);
        validate_code = 1; access_code = 9;
        @(posedge clk);
        validate_code = 0; access_code = 9;
        #40; $finish;
    end

    initial begin
        $dumpfile("metro_turnstile.vcd");
        $dumpvars(0,tb_metro_turnstile);
    end

endmodule