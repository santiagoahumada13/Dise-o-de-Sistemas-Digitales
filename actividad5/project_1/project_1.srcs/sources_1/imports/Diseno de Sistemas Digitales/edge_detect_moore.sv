`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2024 06:32:25 AM
// Design Name: 
// Module Name: edge_detect_moore
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

module edge_detect_moore(
    input logic clk,reset,
    input logic level,
    output logic tick
    );
    //fsm state type
    typedef enum {zero, edg, one} state_type;
    //signal declaration
    state_type state_reg, state_next;
    //state register
    always_ff @(posedge clk, posedge reset)
    if (reset)
        state_reg <= zero;
        else
            state_reg <= state_next;
    // next-state logic and output logic
    always_comb
    begin
        state_next = state_reg; //default state
        tick = 1'b0;
        case (state_reg)
            zero:
                if (level)
                    state_next = edg;
            edg:
                begin
                    tick = 1'b1;
                    if (level)
                        state_next = one;
                    else
                        state_next = zero;                 
                end
            one:
                if (~level)
                    state_next = zero;
            default: state_next = zero;
        endcase    
    end
endmodule    