`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.10.2025 23:23:11
// Design Name: 
// Module Name: counter
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


module counter
    #(parameter N=8)
    (
    input logic clk, reset, d,
    output logic [N-1:0] q 
    );
    
    logic [N-1:0] state_reg, state_next;
    
    always_ff @(posedge clk, posedge reset)
        if(reset)
            state_reg<=0;
        else
            state_reg<=state_next;
    
    always_comb
        if(d)
            state_next=state_reg+1;
        else
            state_next=state_reg;
            
    assign q = state_reg;
endmodule
