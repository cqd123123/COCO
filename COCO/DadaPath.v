module DataPath(input reset,clk,output [31:0] IR,
                //ctr sginal
                input PCWrite,MemRead,MemWrite,IRWrite,RegWrite,ExtFunct,
                input [3:0] Aluop,
                input [1:0] SHTOp,
                input MulSelMD,MulStart,MulSelHL,MulWrite,Sign,output mulready,//mulctrl
                input CP0Write,output SR_IE,output [5:0]IM,input PrExcEnter,input [4:0] PrExcCode,HW_Int,input [1:0] CP0Muxctrl,

                input IorD,AluSrcA,SHTNumSrc,CP0Src,input[1:0] RFSource,AluSrcB,RegDst,
                input [2:0] PCSrc,AluOutSrc,DExtFunct,
                output Zero,Overflow,Compare,
                //mem interact
                output WE,output [3:0] BE,output [31:0] address,writedata,
                input [31:0] readdata,
                //output [31:0] PCOut,
                input[31:0] instr);
wire [31:0] RFB,PC,PCOut,MemW;
wire [31:0] NextPC,AluOut,WData,RData1,RData2,ExtOut,RFA,aluA,aluB,Dataout,DExtout,
           SHout,MulDout,CPOut,AluIn,AluoutF,ExtVector,EPC,CPWriteData,CP0Out;
wire [4:0] RD,shift,CP0Index,ExcCode,HWInt;
wire [7:0] SR_IM;
//wire ExtFunct=1;
//wire [2:0] DExtFunct=3'b111;   
wire [1:0] A1_A0; 

assign WE=MemWrite;
assign writedata=MemW;//assign address=AluoutF;

assign address=(IRWrite)?PCOut:AluoutF;
assign A1_A0=AluoutF[1:0];
assign BE=(IR[31:26]==6'b101011)?4'b1111://sw
          (IR[31:26]==6'b101001)?(AluoutF[1]?4'b1100:4'b0011)://sh
          (IR[31:26]==6'b101000)?(//sb
          (AluoutF[0]&&AluoutF[1])?4'b1000:
          (~AluoutF[0]&&AluoutF[1])?4'b0100:
          (AluoutF[0]&&~AluoutF[1])?4'b0010:
          (~AluoutF[0]&&~AluoutF[1])?4'b0001:
          4'b0000):4'b0000;
MemExtion MExt(RFB,BE,MemW);          
MUX2 #(32) MUX1(PC,AluoutF,IorD,PCOut);          
ProgramCounter  pc(clk,reset,PCWrite,NextPC,PC); 
InstructionRegister  IRf(clk,reset,IRWrite,instr,IR);
mux3 #(32) MUX3(AluoutF,DExtout,PC,RFSource,WData);
mux3 #(5)  MUX2(IR[20:16],IR[15:11],5'b11111,RegDst,RD);

RegisterFile rf(clk,reset,RegWrite,IR[25:21],IR[20:16],RD,WData,RData1,RData2);  
Extension   Ext(IR[15:0],ExtFunct,ExtOut);  
flopr #(32) rfA(clk,reset,RData1,RFA); 
flopr #(32) rfB(clk,reset,RData2,RFB); 
MUX2  #(32) MUX4(PC,RFA,AluSrcA,aluA);
mux4  MUX5(RFB,32'b00000000000000000000000000000100,ExtOut,ExtOut<<2,AluSrcB,aluB);


DataExtension  DEt(readdata,DExtFunct,A1_A0,Dataout); 
flopr #(32) DataR(clk,reset,Dataout,DExtout);
MUX2 #(5) MUX6(RFA[4:0],IR[10:6],SHTNumSrc,shift);
Shifter shifter(SHTOp,shift,RFB,SHout);

MulDiv  muldiv(clk,reset,RFA,RFB,MulSelMD,MulStart,MulSelHL,MulWrite,Sign,MulDout,mulready);  
   
ALU alu(aluA,aluB,Aluop,AluOut,Zero,Overflow,Compare); 

mux5 MUX7(AluOut,SHout,MulDout,ExtOut,CP0Out,AluOutSrc,AluIn);
 
flopr #(32) AluFF(clk,reset,AluIn,AluoutF);
MUX2 #(5) MUX8(5'b01110,IR[15:11],CP0Src,CP0Index);
mux8 MUX9(AluOut,AluoutF,{PC[31:28],IR[27:0]<<2},RFA,ExtVector,EPC,EPC,EPC,PCSrc,NextPC);
mux3 #(32) MUX10(RFB,PC,PC,CP0Muxctrl,CPWriteData);
Vector   vect(PrExcCode,ExtVector);

CP0 cp0(clk,reset,CP0Write,PrExcEnter, CPWriteData,CP0Index,PrExcCode,HW_Int, CP0Out,EPC, SR_IM,SR_IE);
assign IM=SR_IM[6:2];
endmodule