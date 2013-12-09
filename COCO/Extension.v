module Extension(input [15:0] Imm16w,input ExtFunct,output [31:0] ExtImm32);
  assign ExtImm32=(ExtFunct==0)?{16'b0000_0000_0000_0000,Imm16w}:
  (Imm16w[15]==0)?{16'b0000_0000_0000_0000,Imm16w}:
  {16'b1111_1111_1111_1111,Imm16w};
endmodule
