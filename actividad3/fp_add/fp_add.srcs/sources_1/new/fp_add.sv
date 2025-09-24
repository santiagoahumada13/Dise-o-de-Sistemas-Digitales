`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2025 21:28:09
// Design Name: 
// Module Name: fp_add
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
//importa el tipo de punto flotante creado en el paquete "fp_pkg"
module fp_add(
    input fp_t a,b,
    output fp_t c
);

    fp_t bign, smalln, small_aligned, unnormalized;
    logic [8:0] sum;
    
    fp_sorter U1(.a(a), .b(b), .big_num(bign), .small_num(smalln) );
    fp_alignment U2(.bigger(bign), .smaller(smalln), .aligned(small_aligned) );
    fp_sum_frac U3(.bign(bign), .smalln(small_aligned), .sum(sum) );
    fp_norm U4(.c_out(sum[8]), .unnorm(unnormalized), .norm(c) );
    
    assign unnormalized = '{bign.sign, bign.exp, sum[7:0]};
endmodule