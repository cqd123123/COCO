module CP0(input clk,reset,we,ExcEnter,input [31:0] Din,input [4:0] CP0Index,ExcCode,HWInt,
          output [31:0] DOut,EPC,output [7:0] SR_IM,output SR_IE);
reg [31:0] SR,cause,EPCreg,PRId;
assign SR_IM={SR[15:10] ,SR[1],SR[0]}; //hardware shelter bits
assign SR_IE=SR[0];    
assign EPC=EPCreg;
assign DOut=(CP0Index==5'b01100)?{16'h0000,SR[15:10],8'b00000000,SR[1:0]}:
            (CP0Index==5'b01101)?{16'h0000,cause[15:10],3'b000,cause[6:2],2'b00}:
            (CP0Index==5'b01110)?EPC:
            (CP0Index==5'b01111)?PRId:32'h11111111;
always @(posedge clk)
if(reset)
  begin
  PRId<=32'h00000000;
  SR<=32'h0000ffff;
  end
else
  if(we)  //mtc0
    case(CP0Index)
      5'b01100: SR<=Din;
      5'b01101: cause<=Din;
      5'b01110: EPCreg<=Din;
      5'b01111: PRId<=Din;
    endcase
  else if(ExcEnter)
    begin
      cause[6:2]<=ExcCode;//save 
      SR[0]<=0;//IE = 0 
       if(ExcCode!=5'd0) SR[1]<=1;//EXL = 1
         else SR[1]<=0;//EXL = 0 
      cause[14:10]<=HWInt;//save pending breakcodes/
      EPCreg<=Din;           //savepc
    end
    
       
   

endmodule
