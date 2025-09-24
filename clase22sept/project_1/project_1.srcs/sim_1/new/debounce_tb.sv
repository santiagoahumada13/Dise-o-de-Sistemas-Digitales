 `timescale 1ns / 10ps
 module debounce_tb();
    localparam T=10;
    logic clk, reset, nq3;
    logic [3:0] btn;
    logic [3:0] debounced;

    debounce #(.N(4)) uut(.*);
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
            btn[0]=1'b1;
            repeat(2000000) @(negedge clk);
            btn[0]=1'b0;
            repeat(2000000) @(negedge clk);
            btn[1]=1'b1;
            repeat(2000000) @(negedge clk);
            btn[1]=1'b0;
            repeat(2000000) @(negedge clk);
            btn[2]=1'b1;
            repeat(2000000) @(negedge clk);
            btn[2]=1'b0;
            repeat(2000000) @(negedge clk);
            btn[3]=1'b1;
            repeat(2000000) @(negedge clk);
            btn[3]=1'b0;
            repeat(2000000) @(negedge clk);
            $stop;
        end
 endmodule