`timescale 1ns / 1ps

module rx_cmd_parser(
    input logic clk, clr,
    input logic rdrf,           
    input logic [7:0] rx_data,  
    output logic rdrf_clr,      
    output logic [7:0] n_out,   
    output logic op_sel_out,    
    output logic start_calc     
    );

    typedef enum {IDLE, GET_HUND, GET_TENS, GET_ONES, CALC} state_t;
    state_t state_reg, state_next;

    logic op_reg;
    logic [31:0] n_acc; 
    
    localparam ASCII_0 = 8'h30;

    always_ff @(posedge clk, posedge clr) begin
        if(clr) begin
            state_reg  <= IDLE;
            n_out      <= 8'd0;
            op_sel_out <= 1'b0;
            start_calc <= 1'b0;
            n_acc      <= 0;
            op_reg     <= 0;
        end else begin
            state_reg <= state_next;
            
            if(state_reg == CALC) begin
                start_calc <= 1'b1; 
                n_out      <= n_acc[7:0]; 
                op_sel_out <= op_reg;
            end else begin
                start_calc <= 1'b0;
            end

            if(rdrf) begin
                case(state_reg)
                    IDLE: begin 
                        if(rx_data == "M" || rx_data == "m") op_reg <= 1'b1;
                        if(rx_data == "P" || rx_data == "p") op_reg <= 1'b0;
                        n_acc <= 0; 
                    end
                    GET_HUND: n_acc <= (rx_data - ASCII_0); 
                    GET_TENS: n_acc <= (n_acc * 10) + (rx_data - ASCII_0);
                    GET_ONES: n_acc <= (n_acc * 10) + (rx_data - ASCII_0);
                endcase
            end
        end
    end

    always_comb begin
        state_next = state_reg;
        rdrf_clr = 1'b0; 

        case(state_reg)
            IDLE: if(rdrf) begin
                if(rx_data == "M" || rx_data == "m" || rx_data == "P" || rx_data == "p") begin
                    state_next = GET_HUND;
                    rdrf_clr = 1'b1; 
                end else rdrf_clr = 1'b1; 
            end

            GET_HUND: if(rdrf) begin
                if(rx_data >= "0" && rx_data <= "9") begin
                    state_next = GET_TENS;
                    rdrf_clr = 1'b1;
                end else begin
                    state_next = IDLE; 
                    rdrf_clr = 1'b1;
                end
            end

            GET_TENS: if(rdrf) begin
                if(rx_data >= "0" && rx_data <= "9") begin
                    state_next = GET_ONES;
                    rdrf_clr = 1'b1;
                end else begin
                    state_next = IDLE;
                    rdrf_clr = 1'b1;
                end
            end

            GET_ONES: if(rdrf) begin
                if(rx_data >= "0" && rx_data <= "9") begin
                    state_next = CALC;
                    rdrf_clr = 1'b1;
                end else begin
                    state_next = IDLE;
                    rdrf_clr = 1'b1;
                end
            end

            CALC: state_next = IDLE; 
            
            default: state_next = IDLE;
        endcase
    end
endmodule