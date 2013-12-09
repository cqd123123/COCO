module LED(CLK_I ,RST_I,  STB_I , WE_I , DAT_I, DAT_O, ACK_O, LED_Out);
    input [31:0]DAT_I;
    input CLK_I,RST_I,WE_I,STB_I;
    output ACK_O;
    output reg [31:0]DAT_O;
    output [7:0]LED_Out;
    always@(posedge CLK_I)
    if(RST_I)
       DAT_O<=32'b0;
    else if (WE_I&&STB_I)
       DAT_O<=DAT_I;
    assign ACK_O= STB_I;
    assign LED_Out= DAT_O[7:0];
endmodule
