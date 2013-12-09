module DataMem(input [12:2] A,input [31:0] Din,input [3:0] BE,input WE,Clk,output [31:0] Dout);
  reg [31:0] Dm[2048:0];
  assign Dout=Dm[A];
  always  @(posedge Clk)
    if(WE)
      begin
      if(BE[3])
        Dm[A][31:24]<=Din[31:24];

       if(BE[2])
        Dm[A][23:16]<=Din[23:16];
      
        if(BE[1])
          Dm[A][15:8]<=Din[15:8];

        if(BE[0])
          Dm[A][7:0]<=Din[7:0];
        end  
endmodule    
   
