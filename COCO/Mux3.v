module mux3 #(parameter WIDTH=8)
            (input [WIDTH-1:0] In0,In1,In2,
             input [1:0]  sel,output [WIDTH-1:0] Out);
  assign Out=(sel==2'b00)?In0:
             (sel==2'b01)?In1:
             (sel==2'b10)?In2:In0;
  endmodule

