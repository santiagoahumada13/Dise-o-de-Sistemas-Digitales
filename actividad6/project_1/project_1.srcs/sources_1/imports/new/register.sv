`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/16/2025 10:01:50 PM
// Design Name: 
// Module Name: register
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


module register(
    input logic clk, clr, ld,
    input logic [7:0] d,
    output logic [7:0] q
    );
    //body
    always_ff @(posedge clk, posedge clr)
    if (clr)
        q <= 0;
    else if (ld)
        q <= d; 
endmodule
