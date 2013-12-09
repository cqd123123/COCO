module mux8(input [31:0] In0,In1,In2,In3,In4,In5,In6,In7,input [2:0] sel,output [31:0] out);
  assign out=(sel==3'b000)?In0:
             (sel==3'b001)?In1:
             (sel==3'b010)?In2:
             (sel==3'b011)?In3:
             (sel==3'b100)?In4:
             (sel==3'b101)?In5:
             (sel==3'b110)?In6:
             (sel==3'b111)?In7:In0;
endmodule
