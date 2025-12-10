`timescale 1ns / 1ps
module padovan(
    input logic [7:0] n,
    input logic go, clk, clr,
    output logic [63:0] res, curr,
    output logic done_f
    );
    
    typedef enum {start, test, sum, done} state_type;
    state_type state_reg, state_next;
    
    logic [63:0] p1, p2, p3, count;
    logic [63:0] p_next;
    
    logic [7:0] n_buff; 

    assign p_next = p2 + p3;
    assign curr = p1; 
    
    always_ff @(posedge clk, posedge clr) begin
        if(clr) begin
            state_reg <= start;
            p1 <= 16'h1; p2 <= 16'h1; p3 <= 16'h1;
            count <= 16'h3;
            n_buff <= 8'd0;
        end else begin
            state_reg <= state_next;
            
            case(state_reg)
                start: begin
                    done_f <= 1'b0;
                    p1 <= 16'h1; 
                    p2 <= 16'h1; 
                    p3 <= 16'h1;
                    count <= 16'h3; 
                    
                    if (go) n_buff <= n; 
                end
                
                sum: begin
                    count <= count + 1;
                    p3 <= p2;       
                    p2 <= p1;       
                    p1 <= p_next;   
                end
                
                done: begin
                    done_f <= 1'b1;
                    if (n_buff < 3) res <= 16'h1;
                    else res <= p1;
                end
            endcase
        end
    end

    always_comb begin
        state_next = state_reg;
        case(state_reg)
            start: if(go) state_next = test;
            
            test: begin
                if(n_buff < 8'd3) state_next = done;
                else state_next = sum;
            end
            
            sum: begin
                if(count > n_buff) state_next = done; 
                else state_next = sum;
            end
            
            done: begin
                if(!go) state_next = start;
                else state_next = done;
            end
            
            default: state_next = start;
        endcase
    end
endmodule