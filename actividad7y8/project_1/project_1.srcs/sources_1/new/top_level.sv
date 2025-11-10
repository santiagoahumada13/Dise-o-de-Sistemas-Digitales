`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2025 00:08:59
// Design Name: 
// Module Name: top_level
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


module top_level(
    input logic clk, clr, RsRx, 
    output logic RsTx
    );
    
    logic [15:0] res_moser, curr_moser, res_pad, curr_pad;
    logic go_moser, go_pad, df_moser, df_pad;
    logic [7:0] n_moser, n_pad, rx_data, tx_data;
    
    
    
    moser U1 (.clk(clk), .clr(clr), .n(n_moser), .res(res_moser), .curr(curr_moser),.done_f(df_moser),.go(go_moser));
    padovan U2 (.clk(clk), .clr(clr), .n(n_pad), .res(res_pad), .curr(curr_pad),.done_f(df_pad),.go(go_moser));
    
    
    
    
    
endmodule
