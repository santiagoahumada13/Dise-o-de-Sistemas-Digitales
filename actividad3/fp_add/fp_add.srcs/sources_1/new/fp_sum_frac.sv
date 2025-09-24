`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2025 21:28:09
// Design Name: 
// Module Name: fp_sum_frac
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

module fp_sum_frac(
        input fp_t bign,smalln,
        output logic [8:0] sum
    );
    
    assign sum = (bign.sign == smalln.sign) ?
    {1'b0, bign.frac} + {1'b0, smalln.frac} : //Si son signos iguales suma ambos significandos, 
    {1'b0, bign.frac} - {1'b0, smalln.frac};    //Si son signos diferentes resta el mayore menos el menor (ya que ya se encuentra normalizado en el top level)
endmodule
