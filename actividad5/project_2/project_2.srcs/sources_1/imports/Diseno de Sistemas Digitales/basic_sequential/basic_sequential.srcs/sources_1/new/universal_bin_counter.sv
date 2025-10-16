`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/17/2025 10:59:10 AM
// Design Name: 
// Module Name: universal_bin_counter
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


module universal_bin_counter
    #(parameter N=8)
    (
    input logic clk, reset,syn_clr, load, en, up,
    input logic [N-1:0] d,
    output logic max_count, min_count,
    output logic [N-1:0] q
    );
    //signal declaration 
    logic [N-1:0] state_reg, state_next;
    //body
    //register
    always_ff @(posedge clk, posedge reset)
    if (reset)
        state_reg <= 0;
    else
        state_reg <= state_next;
    //next state logic
    always_comb
        if (syn_clr)
            state_next = 0;
        else if (load)
            state_next = d;
        else if (en & up)
            state_next = state_reg + 1;
        else if (en & ~up)
            state_next = state_next - 1;
        else
            state_next = state_reg;
    //output logic
    assign q = state_reg;
    assign max_count = (state_reg == 2**N-1) ? 1'b1 : 1'b0;
    assign min_count = (state_reg == 0) ? 1'b1 : 1'b0;
endmodule