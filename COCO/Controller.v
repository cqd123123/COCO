module Controller(input [5:0] op,funct,input [4:0] RT,RS,input clk,reset,input Zero,Overflow,Compare,Ready,
                  output PCEn,MemRead,MemWrite,IRWrite,RegWrite,ExtFunct,
                  output [3:0] Aluop,
                  output [1:0] SHTOp,
                  output MulSelMD,MulStart,MulSelHL,MulWrite,Sign,input mulready,//mulctrl
                  output CP0Write,input IE,input [5:0]IM,HW_Int,output PrExcEnter,output [4:0] PrExcCode,output [1:0] CP0Muxctrl,

                  output IorD,AluSrcA,SHTNumSrc,CP0Src,output[1:0] RFSource,AluSrcB,RegDst,
                  output[2:0] PCSrc,AluOutSrc,DExtFunct);
wire [3:0] Alufun;
wire PCWrite,BR,Branch;
assign PCEn=PCWrite|Branch;
//assign BR=Branch&Zero;

Mainctrl  mctrl(op,funct,RT,RS, clk,reset,Ready,
                PCWrite,MemRead,MemWrite,IRWrite,RegWrite,ExtFunct,
                CP0Write,IE,IM,HW_Int, PrExcEnter, PrExcCode, CP0Muxctrl,
                Branch,
                IorD,AluSrcA,SHTNumSrc,CP0Src,RFSource,AluSrcB,RegDst,
                PCSrc,AluOutSrc,
                Alufun,DExtFunct,
                MulSelMD,MulStart,MulSelHL,MulWrite,Sign,mulready,
                Zero,Compare);               
Aludec  aludec(op,funct,Alufun,Aluop,
               SHTOp);//mulctrl
                 
                  
endmodule
                  
