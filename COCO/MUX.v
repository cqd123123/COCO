module MUX2 #(parameter WIDTH=8)
            (input [WIDTH-1:0] In0,In1,
             input sel,output [WIDTH-1:0] Out);
assign Out=sel ? In1:In0;
endmodule