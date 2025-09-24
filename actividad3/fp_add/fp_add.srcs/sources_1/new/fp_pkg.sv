`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2025 20:38:16
// Design Name: 
// Module Name: fp_pkg
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

package fp_pkg;
typedef struct packed{
        logic sign; //signo
        logic [3:0] exp; //exponente
        logic [7:0] frac;//significando
    } fp_t;
endpackage: fp_pkg
