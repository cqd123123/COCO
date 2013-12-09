module Timer(CLK_I , RST_I, ADD_I, STB_I , WE_I , DAT_I, DAT_O, ACK_O, OUT);
    input CLK_I,RST_I , STB_I, WE_I;
    input [3:0]ADD_I;
    input [31:0]DAT_I;
    output [31:0]DAT_O;    
    output ACK_O;
    output reg [2:0]OUT;
    
    reg [31:0]TC[8:0];

    
    
    
    assign DAT_O = TC[ADD_I];
    assign ACK_O = STB_I;
    
    always@(posedge CLK_I)
    begin
        if(RST_I)begin
            TC[0]<=32'b0; //Ctrl TC0 TC1 TC2 
            TC[3]<=32'b0;
            TC[6]<=32'b0;
        end
        else  if(WE_I&&STB_I)
        case(ADD_I)
        4'd1:begin
            TC[1]<=DAT_I;
            TC[2]<=DAT_I;
        end
        4'd4:begin
            TC[4]<=DAT_I;
            TC[5]<=DAT_I;
        end
        4'd7:begin
            TC[7]<=DAT_I;
            TC[8]<=DAT_I;
        end
        default:
           TC[ADD_I]<=DAT_I;
        endcase
        
        else begin
        case (TC[0][2:1])
            2'b00: begin
                if(TC[0][0])begin
                      if(TC[2]==32'b0)  TC[0][0]<=1'b0;                          
                      else TC[2]<=TC[2]-32'b1;
                end
               
            end
            2'b01: begin
                if(TC[0][0])begin
                      if(TC[2]==32'b0)  TC[2]<=TC[1];                          
                      else TC[2]<=TC[2]-32'b1;
                end
                
            end
            2'b10: begin
                if(TC[0][0])begin
                      if(TC[2]==32'b0)  TC[2]<={TC[1][31:1],1'b0};                          
                      else TC[2]<=TC[2]-32'b1;
                end
                
            end
        endcase//Timer0 ends
        
        case (TC[3][2:1])
            2'b00: begin
                if(TC[3][0])begin
                      if(TC[5]==32'b0)  TC[3][0]<=1'b0;                          
                      else TC[5]<=TC[5]-32'b1;
                end
               
            end
            2'b01: begin
                if(TC[3][0])begin
                      if(TC[5]==32'b0)  TC[5]<=TC[4];                          
                      else TC[5]<=TC[5]-32'b1;
                end
                
            end
            2'b10: begin
                if(TC[3][0])begin
                      if(TC[5]==32'b0)  TC[5]<={TC[4][31:1],1'b0};                          
                      else TC[5]<=TC[5]-32'b1;
                end
                
            end
        endcase//Timer1 ends
        
        case (TC[6][2:1])
            2'b00: begin
                if(TC[6][0])begin
                      if(TC[8]==32'b0)  TC[6][0]<=1'b0;                          
                      else TC[8]<=TC[8]-32'b1;
                end
               
            end
            2'b01: begin
                if(TC[6][0])begin
                      if(TC[8]==32'b0)  TC[2]<=TC[7];                          
                      else TC[8]<=TC[8]-32'b1;
                end
                
            end
            2'b10: begin
                if(TC[6][0])begin
                      if(TC[8]==32'b0)  TC[8]<={TC[7][31:1],1'b0};                          
                      else TC[8]<=TC[8]-32'b1;
                end
                
            end
        endcase//Timer2 ends
        
        end//endelse
    end//Timer sequential circuit ends
        
    always@(*)begin
            case(TC[0][2:1])
                2'b00: OUT[0]=(TC[2]==32'b0)? 1'b1:1'b0;
                2'b01: OUT[0]=(TC[2]==32'b0)? 1'b1:1'b0;
                2'b10: OUT[0]=(TC[2]<{1'b0,TC[1][31:1]})? 1'b1:1'b0;
            endcase
            case(TC[3][2:1])
                2'b00: OUT[1]=(TC[5]==32'b0)? 1'b1:1'b0;
                2'b01: OUT[1]=(TC[5]==32'b0)? 1'b1:1'b0;
                2'b10: OUT[1]=(TC[5]<{1'b0,TC[4][31:1]})? 1'b1:1'b0;
            endcase
            case(TC[6][2:1])
                2'b00: OUT[2]=(TC[8]==32'b0)? 1'b1:1'b0;
                2'b01: OUT[2]=(TC[8]==32'b0)? 1'b1:1'b0;
                2'b10: OUT[2]=(TC[8]<{1'b0,TC[7][31:1]})? 1'b1:1'b0;
            endcase
    end//Timer combinational circuit ends
   
endmodule
        
