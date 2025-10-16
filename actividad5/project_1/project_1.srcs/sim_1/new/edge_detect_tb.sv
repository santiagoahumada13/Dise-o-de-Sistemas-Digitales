`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.10.2025 14:50:27
// Design Name: 
// Module Name: edge_detect_tb
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


module edge_detect_tb();

    localparam T=20;
    
    logic clk, level, tick1, tick2, reset;
    edge_detect_top uut(.*);
    
    always
    begin
        clk = 1'b1;
        #(T/2);
        clk = 1'b0;
        #(T/2);
    end 
    
    initial
    begin
        reset = 1'b1;
        #(T/2);
        reset = 1'b0;
        #(T/2);
    end
    
    initial
    begin
        level=1'b0;
        #(T);
        level=1'b1;
        #(T/2);
        level=1'b0;
        #(T*2);
        level=1'b1;
        #(T*2);
        level=1'b0;
        #(T/2);
        level=1'b1;
        #(T/2);
        level=1'b0;
        #(T);
        level=1'b1;
        #(T/2);
        
        
        $stop;
    end
endmodule
