`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.11.2025 21:03:17
// Design Name: 
// Module Name: moser
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


module moser(
    input logic [7:0] n,
    input logic go, clk, clr,
    output logic [15:0] res, curr,
    output logic done_f
    );
    
    logic [15:0] res_buff, n_buff, count;
    
    typedef enum {start, test1, test2, n0, n1, odd, even,done} state_type;
    state_type state_reg, state_next;
    
    always_ff @(posedge clk, posedge clr)
    if(clr)
    state_reg<=start;
    else
    state_reg<=state_next;
    
    always_comb
    case(state_reg)
        start:begin
            n_buff=n;
            count=16'h2;
            if(~go)
                state_next=start;
            else
                state_next=test1;
            end         
        test1:begin
            if(n == 8'h0)
                state_next=n0;
            else if (n == 8'h1)
                state_next=n1;
            else
                state_next=test2;
            end  
        n0: begin res_buff=16'h0; state_next=done; end 
        
        n1: begin res_buff=16'h1; state_next=done; end
        test2: begin
            count=count+1;
            if(n[0])
                state_next=odd;
            else
                state_next=even;
        end
        
        odd: begin
            n_buff = ((n_buff>>1) + 1)<< 2; // 4*s(n/2)+1
            if(count<n)
                state_next=test1;
            else
                state_next=done;
            end
            
        
        even: begin
            n_buff = (n_buff >> 1) << 2; //4*s(n/2)
            if(count<n)
                state_next=test1;
            else    
                state_next=done;
                
            end
        
        done: begin
            done_f=1'b1;
            res=res_buff;
        end
    endcase
    
    
endmodule
