`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.09.2025 13:28:29
// Design Name: 
// Module Name: disp_mux
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


module disp_mux(
        input logic clk, reset,
        input logic [4:0] hex0, hex1, hex2, hex3, 
        input logic [3:0] dp_in, 
        output logic [3:0] an,
        output logic [7:0] seg        
    );
    
    localparam N=18;
    logic [N-1:0] state_reg, state_next;
    logic [4:0] hex_in;
    logic dp;
    
    
    always_ff @(posedge clk, posedge reset)
        if(reset)
            state_reg<='0;
        else
            state_reg<=state_next;
    assign state_next = state_reg + 1;
    
    always_comb
        case(state_reg[N-1:N-2])
            2'b00:
                begin 
                    an= 4'b1110;
                    hex_in = hex0;
                    dp=dp_in[0];
                end 
            2'b01: 
                begin
                    an=4'b1101;
                    hex_in = hex1;
                    dp=dp_in[1];
                end 
            2'b10: 
                begin
                    an=4'b1011;
                    hex_in = hex2;
                    dp=dp_in[2];
                end
            2'b11: 
                begin
                    an=4'b0111;
                    hex_in = hex3;
                    dp=dp_in[3];
                end
            default:
                begin
                end
        endcase
     always_comb
     begin
        case(hex_in)
            5'b00000: seg[6:0]= 7'b1000000; //0
            5'b00001: seg[6:0]= 7'b1111001; //1
            5'b00010: seg[6:0]= 7'b0100100; //2
            5'b00011: seg[6:0]= 7'b0110000; //3
            5'b00100: seg[6:0]= 7'b0011001; //4
            5'b00101: seg[6:0]= 7'b0010010; //5
            5'b00110: seg[6:0]= 7'b0000010; //6
            5'b00111: seg[6:0]= 7'b1111000; //7
            5'b01000: seg[6:0]= 7'b0000000; //8
            5'b01001: seg[6:0]= 7'b0010000; //9 
            5'b01010: seg[6:0]= 7'b0001000; //A
            5'b01011: seg[6:0]= 7'b0000000; //B
            5'b01100: seg[6:0]= 7'b1000110; //C
            5'b01101: seg[6:0]= 7'b1000000; //D
            5'b01110: seg[6:0]= 7'b0000110; //E
            5'b01111: seg[6:0]= 7'b0001110; //F
            5'b10000: seg[6:0]= 7'b0101111; //r
            5'b10001: seg[6:0]= 7'b0001100; //P
            5'b10010: seg[6:0]= 7'b1111111;
            default:  seg[6:0]= 7'b0001110;
        endcase
        seg[7]=dp;
     end   
endmodule
