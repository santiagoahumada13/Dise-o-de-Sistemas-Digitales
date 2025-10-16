`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2025 09:41:00 AM
// Design Name: 
// Module Name: edge_detect_mealy
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


module edge_detect_mealy(
    input logic clk,reset,
    input logic level,
    output logic tick
    );
    //fsm state type
    typedef enum {zero, one} state_type;
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
                    begin
                        tick = 1'b1;
                        state_next = one;
                    end
            one:
                if (~level)
                    state_next = zero;
            default: state_next = zero;
        endcase    
    end 
endmodule
