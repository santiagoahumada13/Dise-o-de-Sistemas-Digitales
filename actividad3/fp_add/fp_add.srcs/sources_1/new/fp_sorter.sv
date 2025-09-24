`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2025 20:47:46
// Design Name: 
// Module Name: fp_sorter
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

module fp_sorter(
    input fp_t a,b,
    output fp_t big_num, small_num
    );
    assign big_num = ({a.exp, a.frac} >= {b.exp, b.frac}) ? a : b ;
    //Revisa si el significando y el exponente de a son mayores a los de b, si es cierto el numero mayor el a, si es falso el numero mayor es b
    assign small_num = ({a.exp, a.frac} < {b.exp, b.frac}) ? a : b ;
    //Si el exponente y el significando de a son menores a los de b entonces el numero menor es b, si es falso el numero menor es b
endmodule
