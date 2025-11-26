`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.11.2025 18:41:27
// Design Name: 
// Module Name: rx_test
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


module rx_test(
    input logic clr, clk, rdrf,
    output logic rdrf_clr
    );
    
    typedef enum {wtrdfr,load} state_type;
    state_type state_reg, state_next;
    
    always_ff @(posedge clk, posedge clr)
    begin
    rdrf_clr<=1'b0;
    if(clr)
        state_reg<=wtrdfr;
    else begin
        state_reg<=state_next;
        rdrf_clr<=1'b0;
        case(state_reg)
            load: rdrf_clr<=1'b1;
        endcase
        end        
    end
    
    always_comb
    begin
    state_next=state_reg;
        case(state_reg)
            wtrdfr: if (~rdrf)
                state_next=wtrdfr;
                else
                state_next=load;
            load: state_next=wtrdfr;
            default: state_next=wtrdfr;         
        endcase
    end
    
endmodule
