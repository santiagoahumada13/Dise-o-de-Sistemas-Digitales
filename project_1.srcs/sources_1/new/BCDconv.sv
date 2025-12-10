`timescale 1ns / 1ps

module BCDconv(
    input logic clk, clr,
    input logic en,
    input logic [63:0] bin_in,  
    output logic [79:0] bin_out,
    output logic rdy
    );
    
    typedef enum {idle, setup, add, shift, done} state_type;
    state_type state_next, state_reg;
    
    logic [143:0] bcd_data, bcd_next; 
    logic [6:0] sh_counter, sh_next; 
    
    integer i;
    
    assign bin_out = bcd_data[143:64];

    always_ff @(posedge clk) begin
        if(clr) begin
            state_reg   <= idle;
            bcd_data    <= '0;
            sh_counter  <= '0;
        end else begin
            state_reg   <= state_next;
            bcd_data    <= bcd_next;
            sh_counter  <= sh_next;
        end
    end

    always_comb begin
        state_next  = state_reg;
        bcd_next    = bcd_data;
        sh_next     = sh_counter;
        rdy         = 1'b0;

        case(state_reg)
            idle: begin
                if(en) begin
                    bcd_next = {80'b0, bin_in}; 
                    state_next = setup;
                end
            end
            
            setup: state_next = add;
            
            add: begin
                for(i = 0; i < 20; i = i + 1) begin
                    if(bcd_data[64 + (4*i) +: 4] > 4) begin
                        bcd_next[64 + (4*i) +: 4] = bcd_data[64 + (4*i) +: 4] + 3;
                    end
                end
                state_next = shift;
            end
            
            shift: begin
                bcd_next = bcd_data << 1;
                sh_next = sh_counter + 1;
                
                if(sh_counter == 63) begin
                    sh_next = 0;
                    state_next = done;
                end else begin
                    state_next = add;
                end
            end
            
            done: begin
                rdy = 1'b1;
                state_next = idle; 
            end
            
            default: state_next = idle;
        endcase
    end
endmodule