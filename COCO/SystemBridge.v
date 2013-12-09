module SysBridge(input [31:0] PrA, input [3:0] PrBE,input [31:0] PrWData,output [31:0] PrRData,
                 input PrReq,PrRW,output PrReady,
                 output [10:0] A_IM,input [31:0] Din_IM,//im
                 output [10:0] A_DM,output [31:0] DOut_DM,//dm
                 output[3:0] BE,output We,input [31:0] Din_DM,
                 //Ws
                 output [3:0]ADR_O ,output [31:0] DAT_O,//timer
                 output WE_O,input ACK_I_UART,
                 output STB_O_UART,input [7:0] DAT_I_UART,
                 input ACK_I_TMR,output STB_O_TMR,input [31:0] DAT_I_TMR, 
                 input ACK_I_LED,output STB_O_LED,input [31:0]DAT_I_LED);
                 //1011_1111_11
                 //1001_0000_00
                 
  assign A_IM = PrA[12:2];
  assign A_DM = PrA[14:2];                 


assign PrRData=((PrA&32'hFFFF_0000)==32'hBFC0_0000)?Din_IM:
               ((PrA&32'hFFFF_0000)==32'h9000_0000)?Din_DM: 
               ((PrA&32'hFFFF_0000)==32'hA000_0000&&ACK_I_TMR)?DAT_I_TMR:
               ((PrA&32'hFFFF_0000)==32'hA000_0000&&ACK_I_LED)?DAT_I_LED:32'b0;
                                          
assign DAT_O=ACK_I_TMR?PrWData:ACK_I_LED?PrWData:2'b0;
                            
assign ADR_O=(PrA==32'hA000_0200)?4'd0:
                (PrA==32'hA000_0204)?4'd1:
                (PrA==32'hA000_0208)?4'd2:
                (PrA==32'hA000_0300)?4'd3:
                (PrA==32'hA000_0304)?4'd4:
                (PrA==32'hA000_0308)?4'd5:
                (PrA==32'hA000_0400)?4'd6:
                (PrA==32'hA000_0404)?4'd7:
                (PrA==32'hA000_0408)?4'd8:
                4'd0;
                
assign WE_O=(((PrA&32'hFFFF_0000)==32'hA000_0000)&&PrReq&&!PrRW)?1'b1:1'b0;

assign STB_O_TMR=((PrA&32'hFFFF_FF00)==32'hA000_0200)?1'b1:
                       ((PrA&32'hFFFF_FF00)==32'hA000_0300)?1'b1:
                       ((PrA&32'hFFFF_FF00)==32'hA000_0400)?1'b1:
                       1'b0;
assign STB_O_LED=((PrA&32'hFFFF_FF00)==32'hA000_0700)?1'b1:1'b0;

                 
assign BE=PrBE;
assign PrReady=PrReq;
assign DOut_DM= PrWData;
assign We=~PrRW;
/*   
90000000H~90007FFFH	DM
BFC00000H~BFC01FFFH	IM
A0000200H~A00002FFH	Timer/Counter0
A0000300H~A00003FFH	Timer/Counter1
A0000400H~A00004FFH	Timer/Counter2
*/               
endmodule
  

