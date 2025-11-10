`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.11.2025 19:52:37
// Design Name: 
// Module Name: padovan
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


module padovan(
    input logic [7:0] n,
    input logic go, clk, clr,
    output logic [15:0] res, curr,
    output logic done_f
    );
    
    typedef enum {start, test, sum, done} state_type;
    state_type state_reg, state_next;
    
    logic [15:0] pNext, pPrevPrev,pPrev, pCurr, count;
    
    always_ff @(posedge clk, posedge clr)
        if(clr)begin
            pPrev<=16'h1;
            pPrevPrev<=16'h1;
            pCurr<=16'h1;
            count<=16'h3;
            done_f<=1'b0;
            state_reg<=start;
        end
        else begin
            state_reg<=state_next;
            if (state_reg == sum) begin
            count <= count + 1;
            
            pNext = pPrevPrev + pPrev;
            
            pPrevPrev <= pPrev;
            pPrev     <= pCurr;
            pCurr     <= pNext;
            end
        end  
    always_comb
    case(state_reg)
        start: if(~go)
            state_next=start;
            else
            state_next=test;
            
        test: if(n<=8'h3)
            state_next=done;
            else
            state_next=sum;
            
        sum: begin
            curr=pCurr;
            if(count<n)
                state_next=sum;
            else if (count >= n)
                state_next=done;     
        end
        
        done: begin
            res=pNext;
            done_f = 1'b1;
            end    
        default: state_next=start;
    endcase
endmodule
