`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2025 21:46:42
// Design Name: 
// Module Name: fp_norm
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
import fp_pkg::fp_t;

module fp_norm(
        input logic c_out,
        input fp_t unnorm,
        output fp_t norm
    );
    
    logic [2:0] lead_z;
    //ceros iniciales sin contar el acarreo inicial
    fp_leading_zeros U1(.number(unnorm.frac),.lead0s(lead_z));
    
    always_comb
    begin
        if (c_out)
            begin
                norm.exp = unnorm.exp + 1;
                norm.frac = {1'b1, unnorm.frac[7:1]}; 
            end
        else if (lead_z > unnorm.exp)
            begin
                norm.exp = 0;
                norm.frac = 0;
            end
        else 
            begin
                norm.exp = unnorm.exp - lead_z;
                norm.frac = unnorm.frac << lead_z;
            end
        norm.sign = unnorm.sign;
    end
    
endmodule
