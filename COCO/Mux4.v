module mux4(input [31:0] In0,In1,In2,In3,input [1:0] sel,output [31:0] out);
  assign out=(sel==2'b00)?In0:
             (sel==2'b01)?In1:
             (sel==2'b10)?In2:
             (sel==2'b11)?In3:In0;
  endmodule
