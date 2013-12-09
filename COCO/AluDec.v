module Aludec(input [5:0] op,funct,input [3:0] Alufun,output [3:0] Aluop,
              output reg [1:0] SHTOp);//mulctrl
              
reg [4:0] controls;
assign Aluop=controls;
             
always@(*)
case (Alufun)
  4'b0000:controls<=4'b0000;//addu
  4'b0001:controls<=4'b0001;//add
  4'b0010:controls<=4'b0010;//sub
  4'b0100:controls<=4'b0100;//andi
  4'b0101:controls<=4'b0101;//ori
  4'b0111:controls<=4'b0111;//xori
  4'b1001:controls<=4'b1001;//slti
  4'b1000:controls<=4'b1000;//sltiu
  4'b1110:controls<=4'b1110;//lui
  4'b1010:controls<=4'b1010;
  4'b1011:controls<=4'b1011;
  4'b1100:controls<=4'b1100;
  4'b1101:controls<=4'b1101;
  
  /*4'b0010:controls<=4'b1000;//slti
  4'b0011:controls<=4'b0011;//lui
  4'b0100:controls<=4'b1000;//ori
  4'b0101:controls<=4'b1001;//andi*/
  default: case (funct)
    6'b100000:controls<=4'b0001;//add
    6'b100001:controls<=4'b0000;//addu
    6'b100010:controls<=4'b0011;//sub
    6'b100011:controls<=4'b0010;//subu
    6'b100100:controls<=4'b0100;//and
    6'b100101:controls<=4'b0101;//or
    6'b101010:controls<=4'b1001;//slt
    6'b101011:controls<=4'b1000;//sltu
    6'b100110:controls<=4'b0111;//xor
    6'b100111:controls<=4'b0110;//nor
    6'b000000:SHTOp<=2'b01;
    6'b000100:SHTOp<=2'b01; //sll/sllv
    6'b000010:SHTOp<=2'b10;
    6'b000110:SHTOp<=2'b10;//srl/srlv
    6'b000011:SHTOp<=2'b11;
    6'b000111:SHTOp<=2'b11;//sra/srav
    

    default controls<=4'b1111;
  endcase
endcase
      
endmodule
//alucontrol code used
            
