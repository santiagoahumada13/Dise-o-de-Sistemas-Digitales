`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.09.2025 23:59:46
// Design Name: 
// Module Name: lock
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


module lock
    #(parameter N=4)
    (
        input logic [1:0] dig1,dig2,dig3,dig4,
        input logic [N-1:0] btn,
        input logic clk, reset,
        output logic correct, incorrect
    );
    
    debounce #(.N(N)) U1 (.*);
    logic nq3;
    logic [N-1:0] debounced;
    logic [1:0] decod;
    
    
    
    typedef enum {s0,s1,s2,s3,s4,
                  err1,err2,err3,err4, inc} state_type;
                    
    state_type state_reg, state_next;
    
    always_comb
        if(debounced[3])
            decod=2'b11;
        else if(debounced[2])
            decod=2'b10;
        else if(debounced[1])
            decod=2'b01;
        else if(debounced[0])
            decod=2'b00;
        else
            decod=2'bxx;
            
    always_ff @(posedge nq3, posedge reset)
        if(reset)
            state_reg<=s0;
        else begin    
            state_reg<=state_next;
            //decod<=cod;
        end
        
    always_comb
        case(state_reg)
            s0: if(debounced !=4'b0000)
            begin
                if(decod==dig1)
                    state_next= s1;
                else
                    state_next= err1;
            end
            s1: if(debounced != 4'b0000) begin
                if(decod==dig2)
                    state_next=s2;
                else    
                    state_next=err2;
                end
            s2: if(debounced != 4'b0000) begin
                if(decod==dig3)
                    state_next=s3;
                else
                    state_next=err3;
                end
            s3: if(debounced != 4'b0000)begin
                if(decod==dig4)
                    state_next=s4;
                else
                    state_next=err4;
                end
                
            s4: if(debounced != 4'b0000)begin
                if(dig1==decod)
                    state_next=s1;
                else
                    state_next=err1;
                end
            err1: state_next=err2;
            
            err2: state_next=err3;
            
            err3: state_next=err4;
            
            err4: state_next=inc;
            
            inc:if(debounced != 4'b0000)begin 
                if(dig1==decod)
                    state_next=s1;
                 else
                    state_next=err1;
                end
            default: state_next=s0;
        endcase
        
        always_comb
            if(state_reg==s4)
                correct=1'b1;
            else if (state_reg==inc)
                incorrect=1'b1;
            else begin    
                correct=1'b0;
                incorrect=1'b0;
            end
endmodule
