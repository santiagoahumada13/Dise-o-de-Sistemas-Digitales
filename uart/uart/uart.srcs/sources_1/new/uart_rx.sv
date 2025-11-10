`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.10.2025 22:03:06
// Design Name: 
// Module Name: uart_rx
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


module uart_rx(
        input logic clk, clr, RxD, rdrf_clr,
        output logic rdrf, FE,
        output logic [7:0] rx_data
    );
    
    logic [15:0] bit_time, baud_count,bit_time_2;
    logic [7:0] rxbuff, bit_count;
      
    assign bit_time = 16'h21E8; //Baud Rate 115200
    assign bit_time_2= 16'h10f4;
    typedef enum {start, mark, stop, delay, shift} state_type;
    state_type state_reg, state_next;

    always_ff @(posedge clk, posedge clr)
        if(clr)
            state_reg<=mark;
        else
            state_reg<=state_next;
    
    always_comb 
    case(state_reg)
        mark:begin
        bit_count=8'h0;
        rdrf<=1'b0; 
            if(~RxD)
                state_next=start;
            else
                state_next=mark;
            end             
            
        start: begin 
            baud_count<=baud_count+1;
            if(baud_count<bit_time_2)
                state_next=start;
            else
                state_next=delay;
            end         
        delay: begin
            baud_count<=baud_count+1;
            //bit_time<=bit_time+1;
            if(baud_count<bit_time)
                state_next=delay;
            else if(baud_count>=bit_time)
                if(bit_count >= 8'h8)
                    state_next=stop;
                else
                    state_next=shift;
            end
         shift: begin
            bit_count<=bit_count+1;
            baud_count<=8'h0000;
            rxbuff<={RxD,rxbuff[7:1]};
            state_next=delay;
            if(bit_count==7)
                rx_data<={RxD,rxbuff[7:1]};
            end
         stop: begin
            rdrf<=1'b1;
            FE <= (RxD == 1'b0) ? 1'b1 : 1'b0;
            state_next=mark;
            end
   
    endcase
endmodule
