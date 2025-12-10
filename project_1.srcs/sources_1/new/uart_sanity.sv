`timescale 1ns / 1ps

module uart_sanity(
    input logic clk,        // Reloj del sistema
    input logic clr,        // Botón de reset
    output logic RsTx       // Salida UART (Tx)
    );

    logic tx_ready, tx_busy;
    // Enviaremos la letra 'A' (Hex 41) constantemente
    logic [7:0] data_to_send = 8'h41; 

    // Instancia tu transmisor existente
    uart_tx U_TX (
        .clk(clk), 
        .clr(clr), 
        .ready(tx_ready), 
        .tx_data(data_to_send), 
        .TxD(RsTx), 
        .tdre(tx_busy)
    );

    // Máquina de estados simple para enviar 'A'.... 'A'.... 'A'
    typedef enum {wait_uart, send, delay} state_t;
    state_t state = wait_uart;
    logic [25:0] counter = 0; // Contador para esperar un poco entre letras

    always_ff @(posedge clk or posedge clr) begin
        if (clr) begin
            state <= wait_uart;
            tx_ready <= 0;
            counter <= 0;
        end else begin
            case (state)
                wait_uart: begin
                    tx_ready <= 0;
                    if (tx_busy) state <= send; // Si UART libre, enviar
                end
                
                send: begin
                    tx_ready <= 1; // Trigger
                    state <= delay;
                end
                
                delay: begin
                    tx_ready <= 0;
                    counter <= counter + 1;
                    // Esperar aprox 0.5 segundos (si clk=100MHz) antes de enviar la siguiente
                    // Si clk=50MHz, esperará 1 segundo.
                    if (counter > 25000000) begin 
                        counter <= 0;
                        state <= wait_uart;
                    end
                end
            endcase
        end
    end
endmodule