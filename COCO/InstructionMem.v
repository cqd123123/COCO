module InsMem(input [12:2] A,output [31:0] DOut);
  reg [31:0] IM [2048:0];
initial
begin
  $readmemh("memfile.dat",IM);
end

assign DOut=IM[A]; //wordalined
endmodule