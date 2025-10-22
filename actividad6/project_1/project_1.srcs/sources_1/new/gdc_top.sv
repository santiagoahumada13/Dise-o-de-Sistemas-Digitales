`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2025 20:29:14
// Design Name: 
// Module Name: gdc_top
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


module gdc_top(
        input logic go_in, clk, clr,
        input logic [7:0] xin, yin,
        output logic [7:0] seg,
        output logic [3:0] an
    );
    
     //Señales internas
    logic [3:0] hex0, hex1, hex2, hex3, dp_in;
    logic [7:0] x1, y1, x, y, xr, yr, gcd;
    logic eq, lt,xld, yld, gld, xsel, ysel,go,go_deb,reset;
    
    //Instanciacion
    control_unit c_u(.*);
    comp #(.N(8)) comp (.*);   
    register xreg(.d(x1),.clk(clk),.clr(clr),.q(x),.ld(xld));
    register yreg(.d(y1),.clk(clk),.clr(clr),.q(y),.ld(yld));
    register greg(.d(x),.clk(clk),.clr(clr),.q(gcd),.ld(gld));
    subs #(.N(8)) xsubs (.A(x), .B(y), .R(xr));
    subs #(.N(8)) ysubs(.A(y), .B(x), .R(yr));
    disp_mux u1(.*);
    debouncing u2(.clk(clk),.reset(clr),.sw_inp(go_in),.debounced_out(go_deb));
    edge_detect_mealy u3(.clk(clk),.reset(clr),.level(go_deb),.tick(go));
    
    assign hex0 = gcd[3:0];
    assign hex1 = gcd[7:4];
    assign reset = clr;
    
    
    always_comb
        if(~xsel)
            x1=xr;
       else
            x1=xin;
            
    always_comb
        if(~ysel)
            y1=yr;
        else
            y1=yin;
endmodule
