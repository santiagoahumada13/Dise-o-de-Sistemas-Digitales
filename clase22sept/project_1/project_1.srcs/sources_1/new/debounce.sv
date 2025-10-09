`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.09.2025 23:51:44
// Design Name: 
// Module Name: debounce
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

module debounce
    #(parameter N=8)
    (
    input logic clk, reset,
    input logic [N-1:0] btn,
    output logic [N-1:0] debounced,
    output logic nq3 
    );
    
    logic [N-1:0] q1, q2, q3;
    logic clk_deb;
        
    freq_div #(.N(19)) U1 (.s_out(clk_deb), .clk(clk), .reset(reset));
    
    always_ff @(posedge clk_deb, posedge reset)
        if(reset)
            q1<=0;
        else
            q1 <= btn;
    
    always_ff @(posedge clk_deb, posedge reset)
        if(reset)
            q2<=0;
        else
            q2 <= q1;
    
    always_ff @(posedge clk_deb, posedge reset)
       if(reset)
            q3<=0;
        else
            q3 <= q2;
    
    assign debounced = q3;
    assign nq3 = ~(|q3) ;
    
    
endmodule