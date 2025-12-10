`timescale 1ns / 1ps

module top_system(
    input logic clk,         
    input logic clr,         
    input logic RsRx,        
    output logic RsTx,       
    output logic [15:0] led  
    );
    
    logic rx_rdrf, rx_fe, parser_rdrf_clr;
    logic [7:0] rx_data_raw;
    logic [7:0] n_val_uart; 
    logic op_sel_uart;
    logic go_pulse;
    
    logic go_moser, go_padovan;
    logic done_moser, done_padovan, done_any, done_prev, res_ld_pulse;
    logic [63:0] res_moser, res_padovan, res_mux, res_reg_out; 
    logic [79:0] bcd_out;       
    logic bcd_rdy, bcd_start_delayed;
    
    logic main_tx_start; 
    logic [7:0] main_tx_data;
    logic [79:0] bcd_captured;  
    logic [3:0]  current_nibble; 
    
    logic [5:0] digit_idx;      
    logic [23:0] delay_counter;  
    logic [7:0] echo_char;      
    logic echo_pending;         
    logic tx_mode_echo;         
    logic result_pending;
    
    logic leading_zeros; 

    typedef enum {tx_idle, tx_capture, tx_prepare, tx_check_busy, tx_send, tx_wait_sent, tx_delay_byte} tx_state_t;
    tx_state_t tx_state, tx_next_state;

    logic welcome_active, welcome_trigger;
    logic [7:0] welcome_data;
    logic final_tx_start;
    logic [7:0] final_tx_data;
    logic tx_busy_raw, uart_is_busy;

    assign uart_is_busy = ~tx_busy_raw; 

    welcome_sequencer U_WELCOME (.clk(clk), .clr(clr), .tx_busy(uart_is_busy), .char_out(welcome_data), .tx_trigger(welcome_trigger), .active(welcome_active));

    uart_rx U_RX (.clk(clk), .clr(clr), .RxD(RsRx), .rdrf_clr(parser_rdrf_clr), .rdrf(rx_rdrf), .FE(rx_fe), .rx_data(rx_data_raw));
    
    rx_cmd_parser U_PARSER (.clk(clk), .clr(clr), .rdrf(rx_rdrf), .rx_data(rx_data_raw), .rdrf_clr(parser_rdrf_clr), .n_out(n_val_uart), .op_sel_out(op_sel_uart), .start_calc(go_pulse));

    always_ff @(posedge clk, posedge clr) begin
        if (clr) begin echo_pending <= 0; echo_char <= 0; end 
        else if (rx_rdrf && !echo_pending) begin echo_char <= rx_data_raw; echo_pending <= 1; end
        else if (tx_state == tx_capture && tx_mode_echo) echo_pending <= 0;
    end

    always_comb begin
        go_moser = 0; go_padovan = 0;
        if(~op_sel_uart) begin res_mux = res_padovan; if(go_pulse) go_padovan = 1; end 
        else             begin res_mux = res_moser;   if(go_pulse) go_moser = 1;   end 
    end

    moser   U_MOSER   (.clk(clk), .clr(clr), .n(n_val_uart), .go(go_moser), .res(res_moser), .done_f(done_moser), .curr());
    padovan U_PADOVAN (.clk(clk), .clr(clr), .n(n_val_uart), .go(go_padovan), .res(res_padovan), .done_f(done_padovan), .curr());

    assign done_any = done_moser || done_padovan;
    always_ff @(posedge clk) done_prev <= done_any;
    assign res_ld_pulse = done_any && !done_prev; 

    register U_REG (.d(res_mux), .clk(clk), .clr(clr), .q(res_reg_out), .ld(res_ld_pulse));
    
    always_ff @(posedge clk) if(clr) bcd_start_delayed <= 0; else bcd_start_delayed <= res_ld_pulse;
    
    BCDconv U_BCDCONV (.clk(clk), .en(bcd_start_delayed), .clr(clr), .bin_in(res_reg_out), .bin_out(bcd_out), .rdy(bcd_rdy));
    
    assign led = {8'b0, n_val_uart}; 

    always_ff @(posedge clk, posedge clr) begin
        if(clr) result_pending <= 0;
        else begin
            if(bcd_rdy) result_pending <= 1; 
            else if(tx_state == tx_capture && !tx_mode_echo) result_pending <= 0; 
        end
    end

    assign final_tx_start = (welcome_active) ? welcome_trigger : main_tx_start;
    assign final_tx_data  = (welcome_active) ? welcome_data    : main_tx_data;
    
    uart_tx U_TX (.clk(clk), .clr(clr), .ready(final_tx_start), .tx_data(final_tx_data), .TxD(RsTx), .tdre(tx_busy_raw));

    always_comb begin
        if (digit_idx <= 21)
            current_nibble = bcd_captured[(21 - digit_idx) * 4 +: 4];
        else
            current_nibble = 4'h0;
    end

    always_comb begin
        if (tx_mode_echo) begin
            main_tx_data = echo_char;
        end else begin
            case (digit_idx)
                6'd0: main_tx_data = 8'h0D; // CR
                6'd1: main_tx_data = 8'h0A; // LF
                default: begin
                    main_tx_data = {4'h3, current_nibble}; 
                end
            endcase
        end
    end

    always_ff @(posedge clk, posedge clr) begin
        if(clr) begin
            tx_state <= tx_idle; 
            digit_idx <= 0; 
            main_tx_start <= 0; 
            bcd_captured <= 0; 
            delay_counter <= 0; 
            tx_mode_echo <= 0;
            leading_zeros <= 1; 
        end else begin
            tx_state <= tx_next_state;
            case(tx_state)
                tx_idle: begin
                    digit_idx <= 0; 
                    main_tx_start <= 0;
                    leading_zeros <= 1; 
                    
                    if(!welcome_active) begin
                        if(result_pending || bcd_rdy) tx_mode_echo <= 0; 
                        else if(echo_pending) tx_mode_echo <= 1; 
                    end
                end
                
                tx_capture: begin
                    if (!tx_mode_echo) bcd_captured <= bcd_out; 
                end
                
                tx_prepare: begin
                    if(tx_mode_echo) begin
                    end else begin
                        if (digit_idx < 2) begin
                        end 
                        else if (digit_idx > 21) begin
                        end 
                        else begin
                            if (current_nibble != 0) begin
                                leading_zeros <= 0; 
                            end 
                            else if (current_nibble == 0 && leading_zeros) begin
                                if (digit_idx != 21) begin 
                                    digit_idx <= digit_idx + 1; 
                                end
                            end
                        end
                    end
                end
                
                tx_send: main_tx_start <= 1; 
                tx_wait_sent: main_tx_start <= 0; 
                tx_delay_byte: delay_counter <= delay_counter + 1;
                
            endcase
            
            if (tx_state == tx_prepare && !tx_mode_echo && digit_idx >= 2 && digit_idx <= 21) begin
                 if (current_nibble == 0 && leading_zeros && digit_idx != 21) begin
                     digit_idx <= digit_idx + 1; 
                 end
            end 
            else if (tx_state == tx_delay_byte && delay_counter > 24'd1000000) begin
                 delay_counter <= 0;
                 digit_idx <= digit_idx + 1;
            end
        end
    end

    always_comb begin
        tx_next_state = tx_state;
        case(tx_state)
            tx_idle: begin
                if(!welcome_active && (result_pending || bcd_rdy || echo_pending)) tx_next_state = tx_capture;
            end
            
            tx_capture: tx_next_state = tx_prepare;
            
            tx_prepare: begin
                if(tx_mode_echo) begin
                    tx_next_state = tx_check_busy;
                end else begin
                    if (digit_idx > 21) begin
                        tx_next_state = tx_idle;
                    end else if (digit_idx < 2) begin
                        tx_next_state = tx_check_busy; 
                    end else begin
                        if (current_nibble == 0 && leading_zeros && digit_idx != 21) begin
                            tx_next_state = tx_prepare; 
                        end else begin
                            tx_next_state = tx_check_busy; 
                        end
                    end
                end
            end
            
            tx_check_busy: if(!uart_is_busy) tx_next_state = tx_send; else tx_next_state = tx_check_busy;
            tx_send: tx_next_state = tx_wait_sent;
            tx_wait_sent: if(uart_is_busy) tx_next_state = tx_delay_byte; 
            
            tx_delay_byte: begin
                if(delay_counter > 24'd1000000) begin
                    if(tx_mode_echo) tx_next_state = tx_idle;
                    else             tx_next_state = tx_prepare;
                end else begin
                    tx_next_state = tx_delay_byte;
                end
            end
            
            default: tx_next_state = tx_idle;
        endcase
    end
endmodule