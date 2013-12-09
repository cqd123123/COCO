
module Mainctrl(input [5:0] op,funct,input [4:0] RT,RS,input clk,reset,Ready,
                output PCWrite,MemRead,MemWrite,IRWrite,RegWrite,ExtFunct,
                //Breakcontrol
                output CP0Write,input IE,input [5:0]IM,HW_Int,output PrExcEnter,output [4:0] PrExcCode,output [1:0] CP0Muxctrl,
                output BrEn,
                output IorD,AluSrcA,SHTNumSrc,CP0Src,output[1:0] RFSource,AluSrcB,RegDst,
                output[2:0] PCSrc,AluOutSrc,
                output [3:0] Alufun,output [2:0] DExtFunct,
                output MulMode,MulStart,MulSelHL,MulWrite,Sign,input mulready,//mulctrl);
                input Zero,Compare);
                
parameter FetchMuxC=16'b0000_0001_000_00_000,DecMuxC=16'b0000_0011_000_00_000,
          FetchMctr=11'b1101_000_0000,DecMctr=11'b0000_000_0000,
          MemAdrMuxc=16'b0100_0010_000_00_000,MemAdrctr=11'b0000_000_0000,
          RTExeMuxc=16'b0100_0000_000_00_000,RTExectrl=11'b0000_000_1111,
          BEQMuxc=16'b0100_0000_000_00_001,BEQctrl=11'b0000_001_0010,//
          JMuxc=16'b0000_0000_000_00_010,Jctrl=11'b1000_000_0000,
          MemWBmc=16'b0000_0100_000_00_000,MemWBc=11'b0000_100_0000,
          Fetch=8'h00,
          Dec=8'h01,
          MemAdr=8'h02,
          
         Exe=8'h05,ADDIE=8'h06,BEQ=8'h08,Jump=8'h09,MemRB=8'h03,
         SaveM=8'h0d,RFinsh=8'h0f,IRFinsh=8'h10,MemRx=8'h11,Interupt=8'h12,SC=8'h13,BP=8'h14;
wire Breq,Brne,Brbgtz,Brbgez,Brblez,Brbltz,Inrupt;                   
reg [7:0] state;  
wire [4:0] Brctl;        
wire [10:0] Mctrl;
wire [15:0] Muxctrl;
wire [4:0] mulctrl;
reg [26:0] ctrl;
assign BrEn=(Breq&Zero)|(Brne&~Zero)|((Brbgtz|Brbgez|Brblez|Brbltz)&Compare);
assign {PCWrite,MemRead,MemWrite,IRWrite,RegWrite,CP0Write,Breq,Alufun}=Mctrl;
assign {IorD,AluSrcA,SHTNumSrc,CP0Src,RFSource,AluSrcB,AluOutSrc,RegDst,PCSrc}=Muxctrl;
assign {MulMode,MulStart,MulSelHL,MulWrite,Sign}=mulctrl;
assign {Brne,Brbgtz,Brbgez,Brblez,Brbltz}=Brctl;
assign {Mctrl,Muxctrl}=ctrl;
assign Inrupt=IE&
((HW_Int[5]&IM[5])|(HW_Int[4]&IM[4])|(HW_Int[3]&IM[3])|(HW_Int[2]&IM[2])|(HW_Int[1]&IM[1])|(HW_Int[0]&IM[0]));
always @(posedge clk or posedge reset)
 if(reset)
   begin
   state<=Fetch;
   end
 else
   case(state)
     Fetch:
     if(Ready)
     state<=Dec;
     else state<=Fetch;
     Dec:
     begin
     if(op==6'b100011||op==6'b101011||op==6'b100100||op==6'b100000||op==6'b100101||op==6'b100001||op==6'b101000||op==6'b101001)
     //lw,sw,lbu,lb,lhu,lh,sb,sh
         state<=MemAdr;
     if(op==6'b000000&&funct!=6'b001000&&funct!=6'b001001&&funct!=6'b001101&&funct!=6'b001100)//arthimetic/mfc0/mtc0lnclude mfhi../
         state<=Exe;
     if(op==6'b000100||op==6'b000001||op==6'b000111||op==6'b000110||op==6'b000101)//beq,bgez/bltz,bgtz,blez,bne
        state<=BEQ;
     if(op==6'b001000||op==6'b001100||op==6'b001101||op==6'b001110||op==6'b001010||op==6'b001011||op==6'b001001
        ||op==6'b001111||(op==6'b010000&&RS==5'b00000)||(op==6'b010000&&RS==5'b00100))
     //addi/andi/ori/xori/slti/sltiu/lui/mxc0
       state<=ADDIE;
     if(op==6'b000010||op==6'b000011||(op==6'b000000&&funct==6'b001000)||(op==6'b000000&&funct==6'b001001)||(op==6'b010000&&RS==5'b10000))//J/jal//jr//jalr/eret
         state<=Jump;
     if(op==6'b000000&&funct==6'b001101)//breakpoint
       state<=BP;
     if(op==6'b000000&&funct==6'b001100)//sc
       state<=SC;
       
     
     end
    MemAdr:
      if(op==6'b100011||op==6'b100100||op==6'b100000||op==6'b100101||op==6'b100001)//lw,lbu,lb,lhu,lh
        state<=MemRx;
      else
      state<=SaveM;
    MemRx:
    if(Ready)
      state<=MemRB;
    else state<=MemRx;
    Exe:
    state<=((funct==6'b011010||funct==6'b011011||funct==6'b011000||funct==6'b011001)&&~mulready)?state:RFinsh;
    ADDIE:
    state<=IRFinsh;
      
  MemRB:
  if(Inrupt)
    state<=Interupt;
  else
  state<=Fetch;
  SaveM:
  if(Ready)
    begin
      if(Inrupt)
        state<=Interupt;
      else
        state<=Fetch;
      end
  else
  state<=SaveM;
  RFinsh:
  if(Inrupt)
    state<=Interupt;
  else
  state<=Fetch;
  IRFinsh:
  if(Inrupt)
    state<=Interupt;
  else
  state<=Fetch;
  BEQ:
  if(Inrupt)
    state<=Interupt;
  else
  state<=Fetch;
  Jump:
  if(Inrupt)
    state<=Interupt;
  else
  state<=Fetch;
  default: state<=Fetch;
  endcase

  always @(*)
  case (state)
    Fetch:
    ctrl<={FetchMctr,FetchMuxC};
    Dec:
    ctrl<={DecMctr,DecMuxC};
    MemAdr:
    ctrl<={MemAdrctr,MemAdrMuxc};
    RFinsh:
    case(funct)
      6'b010000:ctrl<={11'b0000_100_0000,16'b0000_0000_000_01_000};//mfhi
      6'b010010:ctrl<={11'b0000_100_0000,16'b0000_0000_000_01_000};//mfho
      6'b010001:ctrl<={11'b0000_000_0000,16'b0000_0000_000_00_000};//mthi
      6'b010011:ctrl<={11'b0000_000_0000,16'b0000_0000_000_00_000};//mtho
    default:
    ctrl<={11'b0000_100_0000,16'b0000_0000_000_01_000};
    endcase
    IRFinsh:
    if(op==6'b010000&&RS==5'b00000)  ctrl<={11'b0000_100_0000,16'b0001_0000_000_00_000};//mfc0
    else if(op==6'b010000&&RS==5'b00100) ctrl<={11'b0000_010_0000,16'b0001_0000_000_00_000};//mtc0
    else
    ctrl<={11'b0000_100_0000,16'b0000_0000_000_00_000};
    Jump:
    case(op)
      6'b000011: ctrl<={11'b1000_100_0000,16'b0000_1000_000_10_010};//jal
      6'b000010: ctrl<={Jctrl,JMuxc};
      default:
      if(funct==6'b001000)
        ctrl<={11'b1000_000_0000,16'b0000_0000_000_00_011};//jr
      else if(funct==6'b001001)
        ctrl<={11'b1000_100_0000,16'b0000_1000_000_10_011};//jalr
      else if((op==6'b010000&&RS==5'b10000))
        ctrl<={11'b1000_000_0000,16'b0000_0000_000_00_111};//eret
      else
       ctrl<={Jctrl,JMuxc};
    endcase
    ADDIE:
    case(op)
      6'b001100: ctrl<={11'b0000_000_0100,16'b0100_0010_000_00_000};//andi
      6'b001101: ctrl<={11'b0000_000_0101,16'b0100_0010_000_00_000};//ori
      6'b001110: ctrl<={11'b0000_000_0111,16'b0100_0010_000_00_000};//xori
      6'b001010: ctrl<={11'b0000_000_1001,16'b0100_0010_000_00_000};//slti
      6'b001011: ctrl<={11'b0000_000_1000,16'b0100_0010_000_00_000};//sltiu
      6'b001001: ctrl<={11'b0000_000_0000,16'b0100_0010_000_00_000};//addiu
      6'b001111: ctrl<={11'b0000_000_1110,16'b0100_0010_000_00_000};//lui
      6'b010000: if(RS==5'b00000) ctrl<={11'b0000_000_0000,16'b0001_0000_100_00_000};//mfc0
      else ctrl<={11'b0000_000_0000,16'b0001_0000_100_00_000};
      default:
    ctrl<={11'b0000_000_0001,16'b0100_0010_000_00_000};//addi
    endcase
    BEQ:
    case(op)
      6'b000001: ctrl<=(RT==5'b00001)?{11'b0000_000_1101,BEQMuxc}:{11'b0000_000_1010,BEQMuxc};//bgez,bltz
      6'b000111: ctrl<={11'b0000_000_1100,BEQMuxc};
      6'b000110: ctrl<={11'b0000_000_1011,BEQMuxc};
      6'b000101: ctrl<={11'b0000_000_0010,BEQMuxc};
    default:
           ctrl<={BEQctrl,BEQMuxc};
    endcase
    Exe:
    case(funct)
    6'b000000: ctrl<={11'b0000_000_1111,16'b0010_0000_001_00_000};
    6'b000010: ctrl<={11'b0000_000_1111,16'b0010_0000_001_00_000};
    6'b000011: ctrl<={11'b0000_000_1111,16'b0010_0000_001_00_000};//sll//SRL//sra
    6'b000110: ctrl<={11'b0000_000_1111,16'b0000_0000_001_00_000};
    6'b000111: ctrl<={11'b0000_000_1111,16'b0000_0000_001_00_000};
    6'b000100: ctrl<={11'b0000_000_1111,16'b0000_0000_001_00_000};
    6'b010001: ctrl<={11'b0000_000_1111,16'b0000_0000_001_00_000};//mthi
    6'b010011: ctrl<={11'b0000_000_1111,16'b0000_0000_001_00_000};//mtlo
    6'b010010: ctrl<={11'b0000_000_1111,16'b0000_0000_010_00_000};//mflo
    6'b010000: ctrl<={11'b0000_000_1111,16'b0000_0000_010_00_000};//mfhi
    6'b011010: ctrl<={11'b0000_000_1111,16'b0000_0000_000_00_000};//div
    6'b011011: ctrl<={11'b0000_000_1111,16'b0000_0000_000_00_000};//divu
    6'b011000: ctrl<={11'b0000_000_1111,16'b0000_0000_000_00_000};//mult
    6'b011001: ctrl<={11'b0000_000_1111,16'b0000_0000_000_00_000};//multu
    default:
    
    ctrl<={RTExectrl,RTExeMuxc};
    endcase
    MemAdr:
    ctrl<={MemAdrctr,MemAdrMuxc};
    MemRB:
    ctrl<={MemWBc,MemWBmc}; 
    MemRx:
    case(op)     
     /*6'b100100:
     6'b100000:
     6'b100101:
     6'b100001: */
     default
     ctrl<={11'b0100_000_0000,16'b1000_0000_0000_0000};
    endcase
    SaveM:
    ctrl<={11'b0010_000_0000,16'b1000_0000_0000_0000};
    Interupt:
    ctrl<={Jctrl,16'b0000_0000_000_00_100};
    BP:
    ctrl<={Jctrl,16'b0000_0000_000_00_100};
    SC:
    ctrl<={Jctrl,16'b0000_0000_000_00_100};
    default:
    ctrl<={FetchMctr,FetchMuxC};
  
    endcase 
    
    
    assign DExtFunct=(state==MemRx)?((op==6'b100100)?3'b001:
                                (op==6'b100000)?3'b011:
                                (op==6'b100101)?3'b010:
                                (op==6'b100001)?3'b100:3'b111):3'b111;
    assign ExtFunct=(op==6'b001100||op==6'b001101||op==6'b001110)?0:1;
    assign mulctrl=(state==Exe)?((funct==6'b011010)?5'b11001://div
                                 (funct==6'b011011)?5'b11000://divu
                                 (funct==6'b011000)?5'b01001://mult
                                 (funct==6'b011001)?5'b01000://multu
                                 (funct==6'b010000)?5'b00100://mfhi
                                 5'b00000)://hflo(funct==6'b010010)?5'b00000:
                                 (state==RFinsh)?(
                                 (funct==6'b010001)?5'b00110://mthi
                                 (funct==6'b010011)?5'b00010:5'b00000):5'b00000;//mtlo
    //assign  CP0Write=(state==IRFinsh&&op==6'b010000&&RS==5'b00100)?1'b1:1'b0;//probably require modification
    assign  CP0Muxctrl=(state==IRFinsh&&op==6'b010000&&RS==5'b00100)?2'b00:2'b01;//break
    assign  PrExcEnter=(state==Interupt||state==SC||state==BP)?1:0;// 
    assign  PrExcCode=(state==Interupt)?5'b00000:(state==BP)?5'b01001:(state==SC)?5'b01000:5'b00000;
                       
    assign Brctl=(state==BEQ)?((op==6'b000001)?((RT==5'b00001)?5'b00100:(RT==5'b00000)?5'b00001:5'b00000):
                               (op==6'b000111)?5'b01000:
                               (op==6'b000110)?5'b00010:
                               (op==6'b000101)?5'b10000:5'b00000):5'b00000;
                               
endmodule

                                