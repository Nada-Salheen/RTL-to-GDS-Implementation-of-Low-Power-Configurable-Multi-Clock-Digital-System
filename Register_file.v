module Register_file#(parameter data_width=8, depth=16,  address_width=4, parity_type=1'b0,parity_enable=1'b1,prescale=8, 
division_ratio=8'd4)(
  
  input wire [data_width-1:0] WrData,
  input wire [address_width-1:0] Address,
  input wire WrEn,RdEn,
  input wire clk,rst,
  output wire [data_width-1:0] REG0,REG1,REG2,REG3,
  output reg [data_width-1:0] RdData,
  output reg RdData_Valid
  );

reg [data_width-1:0] regfile [depth-1:0];
integer I;

always@(posedge clk or negedge rst)
begin
  if(!rst)
    begin
      regfile[0] <= 'd0;
      regfile[1] <= 'd0;
      regfile[2] <= 8'b1000_0001;
      regfile[3] <= 'd32;

      RdData_Valid <= 'b0;
      RdData <=0;
      for (I = 4; I < 16; I = I+1)
        begin
          regfile [I] <= 0;
          
         end
      end
  else if(RdEn && (!WrEn))
    begin
      //read from register file
      RdData <= regfile[Address];
      RdData_Valid <= 'b1;
    end
  else if(WrEn && (!RdEn))
    begin
    //write in register file
      regfile[Address]<= WrData;
      RdData_Valid <= 'b0;
    end
  else
    begin
      RdData_Valid <= 'b0;
    end

end
assign REG0 = regfile[0] ;
assign REG1 = regfile[1] ;
assign REG2 = regfile[2] ;
assign REG3 = regfile[3] ;
endmodule