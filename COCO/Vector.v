module Vector(input [4:0] ExcCode,output [31:0] ExtVector);
  assign ExtVector=(ExcCode==5'b00000)?32'hbfc00400:
                   (ExcCode==5'b01000||ExcCode==5'b01001||ExcCode==5'b01010)?32'hbfc00380:
                   32'hbfc00380;
                   
endmodule