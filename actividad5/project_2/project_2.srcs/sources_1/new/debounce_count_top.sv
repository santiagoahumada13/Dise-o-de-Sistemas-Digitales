`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.10.2025 23:06:55
// Design Name: 
// Module Name: debounce_count_top
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


module debounce_count_top
    #(parameter N=8)
    (
    input logic clk,reset,btn,
    output logic [7:0] seg,
    output logic [3:0] an
    );
    
    logic deb_out, edg_out1, edg_out2, tick1, tick2;
    
    logic [N-1:0] q1, q2;
    
    
    //instancias de debouncer
    debouncing U1(.debounced_out(deb_out),.clk(clk),.reset(reset),.sw_inp(btn));    
    
    //instancias de detector de flancos
    edge_detect_mealy U2(.clk(clk),.reset(reset),.level(btn),.tick(edg_out1));
    edge_detect_mealy U3(.clk(clk),.reset(reset),.level(deb_out),.tick(edg_out2));
    
    //instancias de contador
    counter #(.N(N)) U4(.q(q1),.clk(clk),.reset(reset),.d(edg_out1)); 
    counter #(.N(N)) U5(.q(q2),.clk(clk),.reset(reset),.d(edg_out2)); 
    
    //instancia display 7 seg
    disp_mux U6(.clk(clk),.reset(reset), .hex0(q1[3:0]), .hex1(q1[N-1:4]),
                .hex2(q2[3:0]),.hex3(q2[N-1:4]),.seg(seg),.an(an));
    
endmodule
