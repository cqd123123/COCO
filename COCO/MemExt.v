module MemExtion(input [31:0] a,input [3:0] BE,output [31:0] c);
  assign c=(BE==4'b0001)?{24'h000000,a[7:0]}:
           (BE==4'b0010)?{16'h0000,a[7:0],8'h00}:
           (BE==4'b0100)?{8'h00,a[7:0],16'h00}:
           (BE==4'b1000)?{a[7:0],24'h000000}:
           (BE==4'b0011)?{16'h0000,a[15:0]}:
           (BE==4'b1100)?{a[15:0],16'h0000}:
           a;
 endmodule
