`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.09.2025 14:21:08
// Design Name: 
// Module Name: count_top
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


module count_top
    #(parameter N=16)
    (
    input logic clk,reset,
    output logic max_count,
    output logic [7:0] seg,
    output logic [3:0] an
    );
    
    disp_mux U1(.hex0(q[3:0]),.hex1(q[7:4]),.hex2(q[11:8]),.hex3(q[N-1:12]),.clk(clk),.reset(reset),.seg(seg),.an(an),.dp_in(dp));
    logic [3:0] dp;
    assign dp= '1;
    logic [N-1:0] q;
    //signal declaration
    logic [N-1:0] state_reg;
    logic [N-1:0] state_next;
    logic [25:0] fd_reg, fd_next;
    
    always_ff @(posedge clk, posedge reset)
        if(reset)
            fd_reg<='0;
        else
            fd_reg<=fd_next;
    assign fd_next = fd_reg + 1;    
    //body
    //register
    always_ff @(posedge fd_reg[25], posedge reset)
        if (reset)
            state_reg <= 0;
        else
            state_reg <= state_next;
    //next state logic
    assign state_next = state_reg + 1;
    //output logic
    assign q = state_reg;
    assign max_count = (state_reg == 2**N-1) ? 1'b1 : 1'b0;
endmodule
