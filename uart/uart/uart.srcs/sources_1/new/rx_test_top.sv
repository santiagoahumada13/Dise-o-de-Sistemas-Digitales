`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.11.2025 18:51:58
// Design Name: 
// Module Name: rx_test_top
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


module rx_test_top(
    input logic clk, clr, RxD,
    output logic [7:0] seg,
    output logic [3:0] an,
    output logic FE
    );
    
    logic [3:0] dp;
    assign dp='1;
    logic [7:0] rx_data_top;
    

    uart_rx U1 (.clk(clk),.clr(clr),.RxD(RxD),.rdrf_clr(rdrf_clr),.rdrf(rdrf),.FE(FE),.rx_data(rx_data_top));
    rx_test U2 (.clk(clk),.clr(clr),.rdrf(rdrf),.rdrf_clr(rdrf_clr));
    disp_mux U3 (.clk(clk),.reset(clr),.an(an),.seg(seg),.hex0(rx_data_top[3:0]),.hex1(rx_data_top[7:4]),.dp_in(dp));

endmodule
