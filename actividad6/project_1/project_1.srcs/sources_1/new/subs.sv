`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2025 21:57:05
// Design Name: 
// Module Name: subs
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


module subs
    #(parameter N=8)
    (
        input logic [N-1:0] A,B,
        output logic [N-1:0] R
    );
    
    always_comb
        R <= A - B;
    
endmodule
