module syst(input clk,reset,output [7:0] LEDOut);
  

wire [31:0] address,pc,instr,writedata,readdata,Dout,PrRData,DOut_DM;
wire [3:0] BE,PrBE;
wire [10:0] A_DM;
wire [10:0] A_IM;
wire [3:0] ADR_O;
wire [31:0] DAT_O,DAT_I_TMR,DAT_I_LED;
wire [7:0] DAT_I_UART;
wire [4:0] HW_Int;
wire [2:0]OUT;
assign HW_Int = {3'b0,OUT[2:0]};
processor mips(clk,reset, 
   address,writedata,PrRData,
   WE,BE,
   PrReq,PrRw,PrReady,HW_Int);
        
DataMem dm(A_DM,DOut_DM,PrBE,We,clk,Dout);//BE=4'b1111

InsMem  im(A_IM,instr);
Timer TC(clk , reset, ADR_O, STB_O_TMR , WE_O , DAT_O, DAT_I_TMR, ACK_I_TMR, OUT);
   
LED led(clk ,reset, STB_O_LED , WE_O , DAT_O,DAT_I_LED, ACK_I_LED,LEDOut);

             
SysBridge Bridge(address,BE,
                 writedata, PrRData,
                 PrReq,PrRw,PrReady,
                  A_IM,instr,
                  A_DM,DOut_DM,
                  PrBE, We,Dout,
                 //Ws
                ADR_O, DAT_O, WE_O,ACK_I_UART, STB_O_UART, DAT_I_UART,
                ACK_I_TMR, STB_O_TMR,DAT_I_TMR,  
                ACK_I_LED, STB_O_LED,DAT_I_LED);
endmodule


//instruction supported: addi/or/and//add/beq/slt/sub/lw/sw/j
//instruction tested: addi/or/and//add/beq/slt/sub/lw/sw/j
               
// module DataMem(input [12:2] A,input [31:0] Din,input [3:0] BE,input WE,Clk,output [31:0] Dout);


/*module SysBridge(input [31:0] PrWData,output [31:0] PrRData,
                 input 
                 PrReq,PrRW,output PrReady,
                 output [12:2] A_IM,input [31:0] Din_IM,//im
                 output [14:2] A_DM,output [31:0] DOut_DM,//dm
                 output[3:0] BE,output We,input [31:0] Din_DM,
                 //Ws*/
                       