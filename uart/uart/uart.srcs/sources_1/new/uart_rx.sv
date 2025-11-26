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
          
        assign bit_time = 16'h364; //Baud Rate 115200
        assign bit_time_2= 16'h1B2;
        typedef enum {start, mark, stop, delay, shift} state_type;
        state_type state_reg, state_next;
        
        always_ff @(posedge clk, posedge clr)
            if(clr)
                state_reg<=mark;
            else begin
                state_reg<=state_next;
                if(rdrf_clr)
                    rdrf<=1'b0;
                case(state_reg)
                    mark: begin
                        bit_count<= 8'd0;
                        baud_count <= 16'd0;
                        rdrf<=1'b0;
                        FE<=1'b0;
                        end
                    start: baud_count <= baud_count + 1;             
                    delay: begin 
                        baud_count <= baud_count + 1;
                        end
                    shift: begin
                        baud_count<=16'h0;
                        bit_count<=bit_count+1;
                        rxbuff<={RxD,rxbuff[7:1]};
                        end   
                    stop: begin
                        rx_data<=rxbuff;
                        rdrf <= 1'b1;
                        if(~RxD)
                            FE<=1'b1;
                        end          
                endcase
            end
            
        always_comb 
        case(state_reg)
            mark: if(~RxD)
                state_next=start;
                else
                state_next=mark;            
                
            start: begin 
                if(baud_count<bit_time_2)
                    state_next=start;
                else
                    state_next=delay;
                end         
            delay: begin
                if(baud_count<bit_time)
                    state_next=delay;
                else if(baud_count>=bit_time)
                    if(bit_count >= 8'h8)
                        state_next=stop;
                    else
                        state_next=shift;
                end
             shift: 
                state_next=delay;
             stop: 
                state_next=mark;
       
        endcase
        
       
    endmodule
