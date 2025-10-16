`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.10.2025 00:04:09
// Design Name: 
// Module Name: debounce_count_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module debounce_count_tb();
    localparam T=20;
    localparam bounce_ms= 5;
    localparam bounce_ns= bounce_ms * 1000000;
    
    logic clk,reset,btn;
    logic [7:0] seg;
    logic [3:0] an;
    
    debounce_count_top #(.N(8)) uut(.*);
    
    always
    begin
        clk = 1'b1;
        #(T/2);
        clk = 1'b0;
        #(T/2);
    end
    //reset for fisrt half cycle
    initial
    begin
        reset = 1'b1;
        #(T/2);
        reset = 1'b0;    
    end
    
    initial
    begin
    btn=1'b0;
    #(bounce_ns);
    btn=1'b1;
    #(bounce_ns);
    btn=1'b0;
    #(bounce_ns);
    btn=1'b1;
    #(bounce_ns);
    
    btn=1'b0;
    #(bounce_ns);
    btn=1'b1;
    repeat(20) #(bounce_ns);
    
    btn=1'b0;
    #(bounce_ns);
    btn=1'b1;
    #(bounce_ns);
    btn=1'b0;
    #(bounce_ns);
    btn=1'b1;
    #(bounce_ns);
    btn=1'b0;
    #(bounce_ns);
    $stop;
    end
    
    
        
endmodule
