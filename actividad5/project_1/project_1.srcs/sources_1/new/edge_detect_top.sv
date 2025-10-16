`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.10.2025 14:44:56
// Design Name: 
// Module Name: edge_detect_top
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


    module edge_detect_top(
    input logic clk, level, reset,
    output logic tick1, tick2  
    );
    
    
    edge_detect_mealy u1(.tick(tick1), .clk(clk), .level(level),.reset(reset));
    edge_detect_moore u2(.tick(tick2), .clk(clk), .level(level),.reset(reset));
    
endmodule
