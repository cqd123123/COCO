
module Ptest;
   reg clk;
   reg reset;
   wire [7:0] Ledout;
   
   //instant
   syst dut(clk,reset,Ledout);
   
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
     