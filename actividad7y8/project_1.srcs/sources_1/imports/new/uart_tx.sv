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


module uart_tx
    (
       input logic clk, clr, ready,
       input logic [7:0] tx_data,
       output logic TxD, tdre 
    );
    
    logic [15:0] bit_time, baud_count;
    logic [7:0] txbuff, bit_count;
      
    assign bit_time = 16'h364; //Baud Rate 115200 (100MHz * 8.68us = 868. 055 = 346h) 
    
    typedef enum {start, mark, stop, delay, shift} state_type;
    state_type state_reg, state_next;
    
    always_ff @(posedge clk, posedge clr)
        if(clr)
            state_reg<=mark;
        else begin
            state_reg<=state_next;
            case(state_reg)
                mark: begin 
                    bit_count<=8'd0; 
                    tdre<=1'b1; 
                    end
                start: begin
                    TxD <= 1'b0;
                    baud_count<=16'h000;
                    txbuff<=tx_data;
                    tdre<=1'b0;
                    end    
                delay: baud_count<=baud_count + 1;
                shift: begin
                    TxD <=txbuff[0];
                    txbuff<=txbuff>>1;
                    bit_count<=bit_count+1;
                    baud_count<=16'h0;
                    end
                stop: begin
                    TxD=1'b1;
                    tdre<=1'b0;
                    baud_count<=baud_count+1;
                    end
            endcase
            end
            
    always_comb
    begin
    state_next=state_reg;
    case(state_reg)
        mark: if(~ready)
            state_next=mark;
            else
            state_next=start;
        start: state_next=delay;
        delay:begin
             if(baud_count<bit_time)
                state_next=delay;
             else if (baud_count>=bit_time)
                  if(bit_count<8'h8)
                    state_next=shift;
                  else if(bit_count>=8'h8)
                    state_next=stop;
                    end
        shift: state_next=delay;
        stop: if(baud_count<bit_time)
            state_next=stop;
            else
            state_next=mark;
        default: state_next=mark;      
    endcase
    end
endmodule
