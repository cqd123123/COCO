
module t;
   reg clk;
   reg reset;
   
   
   //instan
   MulDiv mf(clk,reset,32'hfffffff1,32'hfffffffc,0,1,1,0,1,Cout,re);
   
   //initialize test
   initial
   begin
     reset<=1; #22;reset<=0;
   end
   
   //clock signal
   always
   begin
     clk<=1;#5;clk<=0;#5;
   end
 
     endmodule


/*module t;  //DataExtension(input [31:0] Din,input [2:0] ExtFunct,input [1:0] A1_A0,output [31:0] ExtDout);
  integer FID;
  reg [2:0] Extfunct;
  reg [31:0] Din;
  reg [1:0] A1_A0;
  wire [31:0] ExtDout;
  
  reg [31:0] RAM1 [63:0];
  reg [2:0] RAM2 [63:0];
  reg [1:0] RAM3 [63:0];
  reg [31:0] i=0;
initial
begin 
  FID=$fopen("memw.txt","w");
  $readmemh("memfile.dat",RAM1);//Din
  $readmemb("memfile1.dat",RAM2);//Extfunct
  $readmemb("memfile2.dat",RAM3);//A1_A0
end
DataExtension dt(Din,Extfunct,A1_A0,ExtDout);
always
 begin
     Din<=RAM1[i];
     Extfunct<=RAM2[i];
     A1_A0<=RAM3[i];
     #5;i=i+1;
    $fwrite(FID,"%h %b %b %h\n",Din,Extfunct,A1_A0,ExtDout);#5;
 end
endmodule*/


/*module t;  // ALU(input [31:0] A,B,input [3:0] Ctrl,output [31:0] C,output Zero,Overflow,Compare);
  integer FID;

  reg [3:0] Ctrl;
  reg [31:0] A,B;
  wire [31:0] C;
  wire Zero,Overflow,Compare;
  reg [31:0] RAM1 [63:0];
  reg [31:0] RAM2 [63:0];
  reg [3:0] RAM3 [63:0];
  reg [31:0] i=0;
initial
begin 
  FID=$fopen("memw.txt","w");
  $readmemh("memfile.dat",RAM1);//a
  $readmemh("memfile1.dat",RAM2);//b
  $readmemb("memfile2.dat",RAM3);//ctrl binary
end
ALU alu(A,B,Ctrl,C,Zero,Overflow,Compare);
always
 begin
     A<=RAM1[i];
     B<=RAM2[i];
     Ctrl<=RAM3[i];
     #5;i=i+1;
    $fwrite(FID,"%h %h %b %h %b %b %b\n",A,B,Ctrl,C,Zero,Overflow,Compare);#5;
 end
endmodule*/



/*module t;//PCtest
reg clk,reset;
  reg PCwr;
  reg [31:0] NextPC;
  wire [31:0] PC;
  reg [31:0] RAM[63:0];
  reg [31:0] PCw;
  reg [31:0] i=0;
initial
begin
  $readmemh("memfile.dat",RAM);
   PCw<=32'b10110110_11110000_00111101_10101010;
  reset<=1; #20;reset<=0;
  
end
ProgramCounter pc(clk,reset,PCwr,NextPC,PC);

always
 begin
     clk<=1;
     PCwr<=PCw[i];
     NextPC<=RAM[i];
     #5;clk<=0;i=i+1;#5;
 end
 

endmodule*/
