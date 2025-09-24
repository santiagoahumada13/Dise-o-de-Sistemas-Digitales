`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.09.2025 23:54:10
// Design Name: 
// Module Name: freq_div
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


module freq_div
    #(parameter N=8)
    (
        input logic clk, reset,
        output logic s_out
    );
    logic [N-1:0] state_reg, state_next;
    
    always_ff @(posedge clk, posedge reset)
        if(reset)
            state_reg<=0;
        else 
            state_reg<=state_next;
            
    assign state_next = state_reg + 1'b1;
    assign s_out = state_reg[N-1];
endmodule
