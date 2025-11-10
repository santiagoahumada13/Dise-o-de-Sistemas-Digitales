`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.11.2025 21:03:17
// Design Name: 
// Module Name: moser
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


module moser(
    input logic [7:0] n,
    input logic go, clk, clr,
    output logic [15:0] res, curr,
    output logic done_f
    );
    
    logic [15:0] res_buff, pow_4;
    logic [7:0] n_buff;
    logic [3:0] pos;
    
    typedef enum {_wait, start ,add, next, done} state_type;
    state_type state_reg, state_next;
    
    assign curr = res_buff;
    
    always_ff @(posedge clk, posedge clr)
    if(clr)
    state_reg<=_wait;
    else begin
        state_reg<=state_next;
        case(state_reg)
            _wait: begin 
                done_f<=1'b0;
                if(go)
                    n_buff<=n;
                end
            start: begin
                res_buff<=16'h0;
                pos<=4'd0;
                pow_4<=16'h1;             
                end
            add: begin
                    if(n_buff[pos] == 1'b1) begin
                        res_buff <= res_buff + pow_4;
                        //curr <= res_buff + pow_4;
                    end
                end
            next: begin
                pow_4 <= pow_4 << 2;
                pos <= pos+1;
            end
            done: begin
                res<=res_buff;
                done_f<=1'b1;
                end
        endcase
    end
    always_comb
    case(state_reg)
        _wait: if(~go)
            state_next=_wait;
            else
            state_next=start;
       start: if(n_buff == 8'h0)
                state_next=done;
                else
                state_next=add;
       add: state_next= next;
       next: if (pos >= 4'd7)
            state_next=done;
            else
            state_next=add;
       done: state_next=done;
    default: state_next=_wait;
    endcase
endmodule