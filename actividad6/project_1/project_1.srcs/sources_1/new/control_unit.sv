`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2025 20:51:44
// Design Name: 
// Module Name: control_unit
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


module control_unit(
        input logic clk, clr, go, eq, lt,
        output logic xsel, ysel, gld, yld, xld
    );
    
    typedef enum {start, _input, test1, done, test2, yx, xy} state_type;
    state_type state_reg, state_next;
    
    always_ff @(posedge clk, posedge clr)
        if(clr)
            state_reg <= start; 
        else
            state_reg <= state_next;
            
    always_comb
    begin
        state_next=state_reg;
        xsel=1'b0;
        ysel=1'b0;
        xld=1'b0;
        yld=1'b0;
        gld=1'b0;
        case(state_reg)
            start: if(~go)
                state_next=start;
                else
                state_next=_input;
                
            _input: begin
                xsel=1'b1;
                ysel=1'b1;
                xld=1'b1;
                yld=1'b1;
                state_next=test1;
            end
            
            test1: if(~eq)
                state_next=test2;
                else
                state_next=done;
                
            test2:
                if (~lt)
                state_next=xy;
                else
                state_next=yx;
            yx: begin
                yld=1'b1;
                ysel=1'b0;
                state_next=test1;
                end
            xy: begin
                xld=1'b1;
                xsel=1'b0;
                state_next=test1;
                end
                
            done: begin 
                gld=1'b1;
                state_next=done;
                end
            default: state_next=start;
            endcase
            end
endmodule
