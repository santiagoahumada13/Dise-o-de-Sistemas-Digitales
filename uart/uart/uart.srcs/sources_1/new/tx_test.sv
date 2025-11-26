`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.11.2025 17:20:01
// Design Name: 
// Module Name: tx_test
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


module tx_test(
    input logic clr, go, clk, tdre,
    output logic ready
    );
    
    typedef enum {wtgo, wtdre, load, wtngo} state_type;
    state_type state_reg, state_next;
    
    always_ff @(posedge clk, posedge clr)
    begin
    ready<=1'b0;
    if(clr)
        state_reg<=wtgo;
    else begin
        state_reg<=state_next;
        case(state_reg)
            load: ready<=1'b1;
        endcase
        end        
    end
        
    always_comb
    begin
    state_next=state_reg;
        case(state_reg)
            wtgo: if(go)
                state_next=wtdre;
                else
                state_next=wtgo;
            wtdre: if(tdre)
                state_next=load;
                else
                state_next=wtdre;
            load: state_next=wtngo;
            wtngo: if (~go)
                state_next=wtgo;
                else
                state_next=wtngo;  
            default: state_next=wtgo;       
        endcase
    end 
    
endmodule
