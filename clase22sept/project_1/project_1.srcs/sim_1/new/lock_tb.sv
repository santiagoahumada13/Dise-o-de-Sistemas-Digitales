`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.09.2025 00:01:14
// Design Name: 
// Module Name: lock_tb
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


module lock_tb();
logic clk,reset,correct,incorrect;
logic [1:0] dig1,dig2,dig3,dig4;
logic [3:0] btn;

lock #(.N(4)) uut(.*);
localparam T=10;
always 
        begin
            clk=1'b1;
            #(T/2);
            clk=1'b0;
            #(T/2);
        end 
    initial
        begin   
            reset=1'b0;
            #(T/2);
            reset=1'b1;
            #(T/2);
            reset=1'b0;
        end
    initial
        begin
            dig1=2'b00;
            dig2=2'b10;
            dig3=2'b01;
            dig4=2'b10;
            
            @(negedge reset);
            btn='0;
            repeat(2000000) @(negedge clk);
            btn[0]=1'b1;
            repeat(2000000) @(negedge clk);
            btn[0]=1'b0;
            repeat(2000000) @(negedge clk);
            btn[2]=1'b1;
            repeat(2000000) @(negedge clk);
            btn[2]=1'b0;
            repeat(2000000) @(negedge clk);
            btn[1]=1'b1;
            repeat(2000000) @(negedge clk);
            btn[1]=1'b0;
            repeat(2000000) @(negedge clk);
            btn[2]=1'b1;
            repeat(2000000) @(negedge clk);
            btn[2]=1'b0;
            repeat(2000000) @(negedge clk);
            btn[3]=1'b1;
            repeat(2000000) @(negedge clk);
            $stop;
            
        end
endmodule
