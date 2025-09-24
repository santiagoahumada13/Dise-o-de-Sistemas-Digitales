`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2025 21:35:43
// Design Name: 
// Module Name: fp_leading_zeros
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


module fp_leading_zeros(
        input logic [7:0] number,
        output logic [2:0] lead0s
    );
    
    always_comb
    begin
        if (number[7])
            begin
                lead0s=3'o0;
            end
        else if (number[6])
            begin
                lead0s=3'o1;
            end
        else if (number[5])
            begin
                lead0s=3'o2;
            end
        else if (number[4])
            begin
                lead0s=3'o3;
            end
        else if (number[3])
            begin
                lead0s=3'o4;
            end
        else if (number[2])
            begin
                lead0s=3'o5;
            end
        else if (number[1])
            begin
                lead0s=3'o6;
            end
        else 
            begin
                lead0s=3'o7;
            end
   end
endmodule
