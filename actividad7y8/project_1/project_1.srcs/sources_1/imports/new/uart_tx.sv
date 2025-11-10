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
       input logic clk, clr, ready, b_sel,
       input logic [7:0] tx_data,
       output logic TxD, tdre 
    );
    
    logic [15:0] bit_time, baud_count;
    logic [7:0] txbuff, bit_count;
      
    assign bit_time = 16'h21E8; //Baud Rate 115200
    
    typedef enum {start, mark, stop, delay, shift} state_type;
    state_type state_reg, state_next;
    
    always_ff @(posedge clk, posedge clr)
        if(clr)
            state_reg<=mark;
        else
            state_reg<=state_next;
    
    always_comb
    case(state_reg)
        mark: begin
                bit_count<=8'h0;
                tdre<=1'b1;
                txbuff<=8'b0;
                TxD<=1'b1;
                if(~ready)
                    state_next=mark;
                else
                    state_next=start;
            end
        start: begin
                baud_count<=16'h0;
                TxD<=1'b0;
                tdre<=1'b0;
                state_next=delay;
            end
        delay:begin
              baud_count<=baud_count+1;
             if(baud_count<bit_time)
                state_next=delay;
             else if (baud_count>=bit_time)
                  if(bit_count<8'h8)
                    state_next=shift;
                  else if(bit_count>=8'h8 && baud_count<=16'h0)
                    state_next=stop;
                    end
        shift: begin
                tdre<=1'b0;
                TxD<=txbuff[0];
                txbuff [6:0]<= txbuff[7:1];
                bit_count <= bit_count+1;
                state_next=delay;
            end
        stop: begin
                TxD<=1'b1;
                tdre<=1'b0;
                if(bit_count<bit_time)
                    state_next=stop;
                else
                    state_next=mark;
            end
        default: state_next=mark;      
    endcase
endmodule
