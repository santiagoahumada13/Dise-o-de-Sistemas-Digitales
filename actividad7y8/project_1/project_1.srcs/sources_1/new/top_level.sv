`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2025 00:08:59
// Design Name: 
// Module Name: top_level
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


module top_level(
    input logic clk, clr, RsRx, 
    output logic RsTx,FE
    );
    
    localparam byte cmd_padovan = 8'h4D;
    localparam byte cmd_moser = 8'h50;
    
    typedef enum {_wait, echo_cmd, echo_n, wait_n, start, wait_done, send_h, send_l} state_type;
    state_type state_reg, state_next;
    
    logic [15:0] res_moser, curr_moser, res_pad, curr_pad,res_reg;
    logic go_moser, go_pad, df_moser, df_pad, tx_ready, rdrf ,tdre, rdrf_clr;
    logic [7:0] n_reg, rx_data, tx_data, cmd_reg;
    
    
    
    
    moser U1 (.clk(clk), .clr(clr), .n(n_moser), .res(res_moser), .curr(curr_moser),.done_f(df_moser),.go(go_moser));
    padovan U2 (.clk(clk), .clr(clr), .n(n_pad), .res(res_pad), .curr(curr_pad),.done_f(df_pad),.go(go_moser));
    uart_tx U3 (.clk(clk),.clr(clr), .ready(ready),.TxD(RsTx),.tx_data(tx_data),.tdre(tdre));
    uart_rx U4 (.clk(clk), .clr(clr), .rdrf(rdrf), .rdrf_clr(rdrf_clr), .FE(FE),.rx_data(rx_data),.RxD(RsRx));
    
    always_ff @(posedge clk, posedge clr)
        if(clr)begin
            state_reg<=_wait;
            cmd_reg<=8'h0;
            n_reg<=8'h0;
            res_reg<=16'h0;
        end
        else begin
            state_reg<=state_next;
            case(state_reg)
                echo_cmd: cmd_reg<=rx_data;
                echo_n: n_reg<=rx_data;      
                wait_done: if((df_pad && cmd_reg == cmd_padovan) || (df_moser && cmd_reg == cmd_moser) )
                    res_reg<=(cmd_reg ==cmd_padovan)? res_pad : res_moser;       
            endcase
        end
        
    always_comb begin
        rdrf_clr = 1'b0;
        tx_ready = 1'b0;
        tx_data = 8'h00;
        go_pad = 1'b0;
        go_moser=1'b0;
        
        case(state_reg)
            _wait: if(rdrf) begin
                    rdrf_clr = 1'b1;
                    state_next = echo_cmd;
                end
            echo_cmd: begin
                tx_data = cmd_reg;
                if (tdre) begin
                    tx_ready=1'b1;
                    state_next=wait_n;
                    end
                end         
            wait_n: if(rdrf) begin
                rdrf_clr= 1'b1;
                state_next =echo_n;
                end
            start: if(cmd_reg == cmd_padovan)
                go_pad = 1'b1;
                else if (cmd_reg == cmd_moser)
                go_moser = 1'b1;
            wait_done: if((cmd_reg ==cmd_padovan && df_pad)||(cmd_reg==cmd_moser && df_moser))
                state_next=send_h;
            send_h: begin
                tx_data =res_reg [15:8];
                if(tdre)begin
                    tx_ready=1'b1;
                    state_next_send_l;
                    end
                end             
            send_l: begin
                tx_data =res_reg [7:0];
                if(tdre)begin
                    tx_ready=1'b1;
                    state_next_send_l;
                    end
                end
                
        endcase 
    end
    
endmodule
