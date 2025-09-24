`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2025 22:19:23
// Design Name: 
// Module Name: fp_add_sim
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


module fp_add_sim;
fp_t a, b ,c;
fp_add uut(.a(a), .b(b), .c(c));
initial
begin
    //signo (1 bit) // exponente (4 bits) // significando (8 bits)
    a='{1'b0, 4'b1011, 8'b0110_1010}; b='{1'b0, 4'b0010, 8'b0010_1101}; #10;
    //a=106*2^11=217.088x10^3; b=173*2^2=692
    a='{1'b1, 4'b1101, 8'b0011_1001}; b='{1'b0, 4'b1000, 8'b0111_1110}; #10;
    
    a='{1'b0, 4'b0110, 8'b0010_1111}; b='{1'b0, 4'b1011, 8'b1101_1100}; #10;
    $stop;
end
endmodule
