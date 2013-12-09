module MulDiv(input clk,reset,input [31:0] a,b,input MorD,Start,MulSelHL,MulWrite,sign,output [31:0] Cout,output ready);

reg [63:0] HILO;
wire [31:0] temp,temp1,a1,b1;
assign a1=(sign)?(a[31]?(~a+32'h00000001):a):a;//convert
assign b1=(sign)?(b[31]?(~b+32'h00000001):b):b;

assign temp=HILO[63:32]+b1;
assign Cout=(MulSelHL)?HILO[63:32]:HILO[31:0];
assign temp1=HILO[63:32]-b1;

integer i=0;
assign ready=(i<=35&&MorD)?0:(i<=33&&~MorD)?0:1;
always @(posedge clk)
if(reset)
  HILO<=0;
else
  begin
     HILO<=Start?((~MorD)?((Start&&i==0)?{32'h00000000,a1}://mul
     (Start&&i!=0&&i<=32&&~ready)?({HILO[0]?temp:HILO[63:32],HILO[31:0]}>>1'b1):
     (i==33&&sign&&(a[31]^b[31]))?(~HILO+64'h0000000000000001):HILO):
     ((Start&&i==0&&~ready)?{32'h00000000,a1}://div
      (Start&&i!=0&&i<=33&&~ready)?
      (temp1[31]?HILO<<1'b1:{{temp1[30:0],HILO[31:0]},1'b1}):
      (i==34)?
      ({HILO[63:32]>>1'b1,HILO[31:0]}):
      (i==35&&sign&&(a[31]^b[31]))?
      ({(a[31]?(~HILO[63:32]+32'h00000001):HILO[63:32]),~HILO[31:0]+32'h00000001}):
      HILO)):
      (MulWrite)?(MulSelHL?{a,HILO[31:0]}:{HILO[63:32],a}):HILO;//mtxx
       
     i=Start?((~MorD)?((i<=33)?i+1:i):(i<=35)?i+1:i):0;
        
  end
          
endmodule