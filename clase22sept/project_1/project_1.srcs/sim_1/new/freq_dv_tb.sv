 `timescale 1ns / 10ps
 module freq_dv_tb();
    localparam T=10;
    logic clk, reset, s_out;
    freq_div #(.N(19)) uut(.*);
    always 
        begin
            clk=1'b1;
            #(T/2);
            clk=1'b0;
            #(T/2);
        end 
    initial
        begin   
            reset=1'b1;
            #(T/2);
            reset=1'b0;
        end
    initial
        begin
            @(negedge reset);
            repeat(10000000) @(negedge clk);
            $stop;
        end
 endmodule