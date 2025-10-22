`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2025 11:42:01 AM
// Design Name: 
// Module Name: debouncing
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


module debouncing(
    input logic clk, reset,
    input logic sw_inp,
    output logic debounced_out
    );
    //counter bits m_tick = 10s (2^N * 10ns)
    localparam N = 21;
    typedef enum{zero, wait1_1, wait1_2, wait1_3,
                 one, wait0_1, wait0_2, wait0_3} state_type;
    //signal declaration
    state_type state_reg, state_next;
    logic [N-1:0] q_reg, q_next;
    logic m_tick;
    //body
    
    //counter to generate 10ms tick
    always_ff @(posedge clk)
    q_reg <= q_next;
    //next-state logic
    assign q_next = q_reg + 1;
    //output tick
    assign m_tick = (q_reg == 0) ? 1'b1 : 1'b0;
    
    //debouncing fsm
    //state register
    always_ff @(posedge clk, posedge reset)
        if (reset)
            state_reg <= zero;
        else
            state_reg <= state_next;
    //next-state logic
    always_comb
    begin
        state_next = state_reg; //defaults
        debounced_out = 1'b0;   
        case (state_reg)
            zero:
                if (sw_inp)
                state_next = wait1_1;
                else
                state_next = zero;  
            wait1_1:
                if (sw_inp & m_tick)
                state_next=wait1_2;
                else if(sw_inp & ~m_tick)
                state_next=wait1_1;
                else if (~sw_inp)
                state_next=zero;
            wait1_2:
                if (sw_inp & m_tick)
                state_next=wait1_3;
                else if(sw_inp & ~m_tick)
                state_next=wait1_2;
                else if (~sw_inp)
                state_next=zero;
            wait1_3:
                if (sw_inp & m_tick)begin
                state_next=one;
                end
                else if(sw_inp & ~m_tick)
                state_next=wait1_3;
                else if (~sw_inp)
                state_next=zero;
            one:begin
                debounced_out=1'b1;
                if(~sw_inp)
                    state_next=wait0_1;
                else
                    state_next=one;
            end
            wait0_1:begin
                debounced_out=1'b1;
                if(~sw_inp&m_tick)
                    state_next=wait0_2;
                else if(~sw_inp&~m_tick)
                    state_next=wait0_1;
                else if(sw_inp)
                    state_next=one;
            end
            wait0_2:begin
                debounced_out=1'b1;
                if(~sw_inp&m_tick)
                    state_next=wait0_3;
                else if(~sw_inp&~m_tick)
                    state_next=wait0_2;
                else if(sw_inp)
                    state_next=one;
            end
            wait0_3:begin
                debounced_out=1'b1;
                if(~sw_inp&m_tick)
                    state_next=zero;
                else if(~sw_inp&~m_tick)
                    state_next=wait0_3;
                else if(sw_inp)
                    state_next=one;
            end
            
            default: state_next = zero;
        endcase
    end
endmodule
