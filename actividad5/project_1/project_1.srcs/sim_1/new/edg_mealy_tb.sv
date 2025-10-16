module edge_mealy_tb();

    localparam T=20;
    logic clk, reset, level, tick;
    
    edge_detect_mealy uut1(.*);
    edge_detect_moore uut2(.*);
    
    always
    begin
        clk = 1'b1;
        #(T/2);
        clk = 1'b0;
        #(T/2);
     end
     
     initial   
     begin
        reset=1'b0;
        #(T/2);
        reset=1'b1;
        #(T/2);
        reset=1'b0;
     end
     
     initial   
     begin
        level=1'b0;
        #(T/2);
        level=1'b1;
        #(T/2);
        level=1'b0;
        #(T/2);
        level=1'b1;
        #(T/2);
        $stop;
     end
    
endmodule