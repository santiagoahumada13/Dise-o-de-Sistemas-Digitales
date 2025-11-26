`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.11.2025 17:34:10
// Design Name: 
// Module Name: tx_test_top
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


module tx_test_top(
        input logic clk, clr, btn,
        input logic [7:0] sw_data,
        output logic [7:0] seg,
        output logic [3:0] an,
        output logic TxD
    );
    
    logic btnd;
    logic [3:0] dp;
    assign dp='1;
    
    
    debouncing U1 (.clk(clk), .reset(clr),.sw_inp(btn),.debounced_out(btnd)); 
    uart_tx U2 (.ready(ready),.clr(clr),.clk(clk),.tx_data(sw_data),.TxD(TxD),.tdre(tdre));
    tx_test U3 (.clk(clk),.clr(clr),.tdre(tdre),.ready(ready),.go(btnd));
    disp_mux U4 (.clk(clk),.reset(clr),.an(an),.seg(seg),.hex0(sw_data[3:0]),.hex1(sw_data[7:4]),.dp_in(dp));
    
    
    
endmodule
