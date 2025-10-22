`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2025 22:06:52
// Design Name: 
// Module Name: gdc_tb
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


module gdc_tb();
    localparam T=20;
    
    logic [7:0] xin, yin, gcd;
    logic clk, clr, go;
    gdc_top uut(.*);
    
    always 
    begin
        clk=1'b1;
        #(T/2);
        clk=1'b0;
        #(T/2);
    end
    
    initial
    begin
        clr=1'b1;
        #(T);
        clr=1'b0;
        #(T);
    end
    
    initial
    begin
    xin=7'b00111010;
    yin=7'b00011010;
    go=1'b0;
    #(T);
    go=1'b1;
    #(T/2);
    go=1'b0;
    #(T/2);
    repeat(18)@(negedge clk)
    
    clr=1'b0;
    #(T);
     $stop;
    end
endmodule
