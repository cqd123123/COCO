`timescale 1ns/1ns
module ProgramCoutertest;
  reg clk,reset;
  wire PCWr;
  wire [31:0] NextPC,PC;
  reg [31:0] RAM[63:0];
  reg [31:0] PCw;
  
initial
begin
  $readmemh("memfile.dat",RAM);
  assign PCw=32'b10110110_11110000_00111101_10101010;
  reset<=1; #20;reset<=0;
  
end
ProgramCounter pc(clk,reset,PCw,NextPC,PC);

always
 begin
     clk<=1;
     PCw<={PCw[31],PCw[30:0]};
     RAM[0]<={RAM[0][31],RAM[0][30:0]};
     #5;clk<=0;#5;
 end
 
 assign PCwr=1;
 assign NextPC=RAM[0];

endmodule
