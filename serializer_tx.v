
module serializer_tx# (parameter data_width= 8)(
  
  input wire [data_width-1:0] parallel_data,
  input wire ser_enable,data_valid,busy,
  input wire clk,rst,
  output wire ser_done,
  output wire serial_data
  );
reg [2:0] count;
reg [data_width-1:0] data;

//isolate input 
always @ (posedge clk or negedge rst)
 begin
  if(!rst)
   begin
    data <= 'b0 ;
   end
  else if(data_valid && (!busy))
   begin
    data <= parallel_data ;
   end	
  else if(ser_enable)
   begin
    data <= data >> 1 ;         // shift register
   end
 end
 

//counter
always @ (posedge clk or negedge rst)
 begin
  if(!rst)
   begin
    count <= 'b0 ;
   end
  else
   begin
    if (ser_enable)
	 begin
      count <= count + 3'b1 ;		 
	 end
	else 
	 begin
      count <= 3'b0 ;		 
	 end	
   end
 end 

assign ser_done = (count == 3'b111) ? 1'b1 : 1'b0 ;

assign serial_data = data[0] ;
		
	endmodule 
        
        
