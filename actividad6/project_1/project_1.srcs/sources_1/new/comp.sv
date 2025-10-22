`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2025 20:31:58
// Design Name: 
// Module Name: comp
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


module comp
    #(parameter N=8)
    (
        input logic [N-1:0] x, y,
        output logic eq, lt
    );
    
    always_comb
    begin
    
        eq=1'b0;
        lt=1'b0;
        
        if(x<y)
            lt = 1'b1;
        else if (x == y)
            eq=1'b1;
    end
endmodule
