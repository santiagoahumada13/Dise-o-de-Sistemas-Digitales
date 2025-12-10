`timescale 1ns / 1ps

module welcome_sequencer(
    input logic clk, clr,
    input logic tx_busy,       
    output logic [7:0] char_out, 
    output logic tx_trigger,   
    output logic active        
    );

    logic [6:0] idx;
    
    logic [23:0] safe_wait; 
    
    logic [7:0] current_char;

    typedef enum {START_DELAY, PREP_CHAR, CHECK_VAL, SEND_PULSE, WAIT_DELAY, NEXT, DONE} state_t;
    state_t state;

    always_comb begin
        case(idx)
            7'd0: current_char = 8'h49; // I
            7'd1: current_char = 8'h6E; // n
            7'd2: current_char = 8'h67; // g
            7'd3: current_char = 8'h72; // r
            7'd4: current_char = 8'h65; // e
            7'd5: current_char = 8'h73; // s
            7'd6: current_char = 8'h65; // e
            7'd7: current_char = 8'h20; // [espacio]
            
            7'd8: current_char = 8'h6C; // l
            7'd9: current_char = 8'h61; // a
            7'd10: current_char = 8'h20; // [espacio]
            
            7'd11: current_char = 8'h73; // s
            7'd12: current_char = 8'h65; // e
            7'd13: current_char = 8'h63; // c
            7'd14: current_char = 8'h75; // u
            7'd15: current_char = 8'h65; // e
            7'd16: current_char = 8'h6E; // n
            7'd17: current_char = 8'h63; // c
            7'd18: current_char = 8'h69; // i
            7'd19: current_char = 8'h61; // a
            7'd20: current_char = 8'h20; // [espacio]
            
            7'd21: current_char = 8'h79; // y
            7'd22: current_char = 8'h20; // [espacio]
            
            7'd23: current_char = 8'h65; // e
            7'd24: current_char = 8'h6C; // l
            7'd25: current_char = 8'h20; // [espacio]
            
            7'd26: current_char = 8'h76; // v
            7'd27: current_char = 8'h61; // a
            7'd28: current_char = 8'h6C; // l
            7'd29: current_char = 8'h6F; // o
            7'd30: current_char = 8'h72; // r
            7'd31: current_char = 8'h20; // [espacio]
            
            7'd32: current_char = 8'h64; // d
            7'd33: current_char = 8'h65; // e
            7'd34: current_char = 8'h20; // [espacio]
            
            7'd35: current_char = 8'h6E; // n
            7'd36: current_char = 8'h20; // [espacio]
            
            7'd37: current_char = 8'h28; // (
            7'd38: current_char = 8'h6D; // m
            7'd39: current_char = 8'h20; // [espacio]
            
            7'd40: current_char = 8'h70; // p
            7'd41: current_char = 8'h61; // a
            7'd42: current_char = 8'h72; // r
            7'd43: current_char = 8'h61; // a
            7'd44: current_char = 8'h20; // [espacio]
            
            7'd45: current_char = 8'h6D; // m
            7'd46: current_char = 8'h6F; // o
            7'd47: current_char = 8'h73; // s
            7'd48: current_char = 8'h65; // e
            7'd49: current_char = 8'h72; // r
            7'd50: current_char = 8'h20; // [espacio]
            
            7'd51: current_char = 8'h79; // y
            7'd52: current_char = 8'h20; // [espacio]
            
            7'd53: current_char = 8'h70; // p
            7'd54: current_char = 8'h20; // [espacio]
            
            7'd55: current_char = 8'h70; // p
            7'd56: current_char = 8'h61; // a
            7'd57: current_char = 8'h72; // r
            7'd58: current_char = 8'h61; // a
            7'd59: current_char = 8'h20; // [espacio]
            
            7'd60: current_char = 8'h70; // p
            7'd61: current_char = 8'h61; // a
            7'd62: current_char = 8'h64; // d
            7'd63: current_char = 8'h6F; // o
            7'd64: current_char = 8'h76; // v
            7'd65: current_char = 8'h61; // a
            7'd66: current_char = 8'h6E; // n
            7'd67: current_char = 8'h29; // )
            
            7'd68: current_char = 8'h0D; // CR
            7'd69: current_char = 8'h0A; // LF
            7'd70: current_char = 8'h00; // NULL (Fin)
            default: current_char = 8'h00; 
        endcase
    end

    always_ff @(posedge clk, posedge clr) begin
        if(clr) begin
            state <= START_DELAY;
            idx <= 0;
            tx_trigger <= 0;
            active <= 1;
            char_out <= 0;
            safe_wait <= 0;
        end else begin
            case(state)
                START_DELAY: begin 
                    if(safe_wait > 24'd100000) begin 
                        state <= PREP_CHAR; 
                        safe_wait <= 0;
                    end else safe_wait <= safe_wait + 1;
                end
                
                PREP_CHAR: begin
                    char_out <= current_char;
                    state <= CHECK_VAL;
                end
                
                CHECK_VAL: begin
                    if(char_out == 8'h00) state <= DONE;
                    else state <= SEND_PULSE;
                end
                
                SEND_PULSE: begin
                    if(!tx_busy) begin 
                        tx_trigger <= 1;
                        state <= WAIT_DELAY; 
                        safe_wait <= 0;
                    end
                end
                
                WAIT_DELAY: begin
                    tx_trigger <= 0; 
                    
                    if(safe_wait > 24'd1000000) begin 
                        state <= NEXT;
                        safe_wait <= 0;
                    end else begin
                        safe_wait <= safe_wait + 1;
                    end
                end
                
                NEXT: begin
                    idx <= idx + 1;
                    state <= PREP_CHAR;
                end
                
                DONE: begin
                    active <= 0; 
                    tx_trigger <= 0;
                end
            endcase
        end
    end
endmodule