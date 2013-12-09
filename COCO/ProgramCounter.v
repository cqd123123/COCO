module ProgramCounter(input clk,reset,PCWr,input [31:0] NextPC,output reg [31:0] PC);
  always@(posedge clk)
  if(reset)
    PC<=32'b1011_1111_1100_00000000000000000000;
  else
    if(PCWr)
      PC<=NextPC;
      
endmodule
