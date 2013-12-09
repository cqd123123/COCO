module RegisterFile(input clk,reset,regwrite,input [4:0] RS1,RS2,RD,
                  input [31:0] WData,output [31:0] RData1,RData2);
reg [31:0] rf[31:0];
integer i;
always @(posedge clk)
begin
if(reset)
  for(i=0;i<32;i=i+1)
  rf[i]<=0;
else
if(regwrite)
  rf[RD]<=WData;
end

assign RData1=(RS1!=0)?rf[RS1]:0;
assign RData2=(RS2!=0)?rf[RS2]:0;
endmodule