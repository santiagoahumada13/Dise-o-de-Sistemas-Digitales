`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2025 20:59:17
// Design Name: 
// Module Name: fp_alignment
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

module fp_alignment(
        input fp_t bigger,smaller,
        output fp_t aligned
    );
    logic [3:0] exp_diff; //Diferencia de los exponentes
    always_comb
    begin
        exp_diff= bigger.exp - smaller.exp;
        aligned.frac =smaller.frac >> exp_diff; //Desplaza a la derecha el significando el numero de bits de la diferencia de los exponentes
        aligned.exp = bigger.exp;
        aligned.sign=smaller.sign;
    end
endmodule
