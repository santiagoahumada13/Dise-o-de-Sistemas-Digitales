`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.11.2025 20:20:36
// Design Name: 
// Module Name: padovan_tb
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


module padovan_tb;
    localparam T=10;
    logic clk, clr, go, done_f;
    logic [7:0] n;
    logic [15:0] res, curr;
    
    padovan uut(.*);
    
    
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
            #(T/2);
            clr=1'b0;
        end
    
    initial
        begin
            n=8'hE;
            @(negedge clr);
            go=1'b0;
            #(T);
            go=1'b1;
            repeat(20) @(posedge clk);
            $stop;
        end     
        
    
endmodule
