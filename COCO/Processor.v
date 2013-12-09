module processor(input clk,reset,
                 //output [31:0] pc,
                 //input[31:0] instr,
                 output [31:0] address,writedata,input [31:0] readdata,
                 output WE,output [3:0] BE,output Req,PrRw,input Ready,
                 input [4:0] HW_Int);
            
wire [31:0] IR,instr;
wire [3:0] Aluop;
wire [1:0] SHTOp,RFSource,AluSrcB,RegDst,CP0Muxctrl;
wire [2:0] PCSrc,AluOutSrc,DExtFunct; 
wire [5:0] IM;
wire [4:0] PrExcCode;
wire MemWrite,MemRead;
assign WE=MemWrite;  
assign instr=readdata;
assign Req=MemRead|MemWrite;
assign PrRw=(MemWrite)?0:1;

Controller ctr(IR[31:26],IR[5:0],IR[20:16],IR[25:21],clk,reset, Zero,Overflow,Compare,Ready,
                   PCWrite,MemRead,MemWrite,IRWrite,RegWrite,ExtFunct,
                   Aluop, SHTOp,
                   MulSelMD,MulStart,MulSelHL,MulWrite,Sign,mulready,//mulctrl
                   CP0Write, IE,IM,{1'b0,HW_Int}, PrExcEnter, PrExcCode, CP0Muxctrl,
                  IorD,AluSrcA,SHTNumSrc,CP0Src, RFSource,AluSrcB,RegDst,
                   PCSrc,AluOutSrc,DExtFunct);
                  
DataPath    dp(reset,clk,IR,
              //ctr sginal
              PCWrite,MemRead,MemWrite,IRWrite,RegWrite,ExtFunct,
              Aluop,SHTOp,
              MulSelMD,MulStart,MulSelHL,MulWrite,Sign,mulready,//mulctrl
              CP0Write, IE,IM,PrExcEnter,PrExcCode,HW_Int, CP0Muxctrl,
              IorD,AluSrcA,SHTNumSrc,CP0Src,RFSource,AluSrcB,RegDst,
              PCSrc,AluOutSrc,DExtFunct,
              Zero,Overflow,Compare,
              //mem interact
              WE, BE, address,writedata,
              readdata,
              //pc,
              instr);
                          
endmodule