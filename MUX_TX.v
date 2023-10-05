module MUX_TX# (parameter start_bit_sel=3'd1, ser_data_sel=3'd2,
par_bit_sel=3'd3, stop_bit_sel=3'd4, start_bit=1'b0, stop_bit=1'b1)(

input wire [2:0] sel,
input wire serial_data,
input wire  parity,
input wire clk,rst,
output reg tx_out
);
reg temp;


always @ (*)
  begin
   case(sel)
	start_bit_sel : begin                 
	         temp <= start_bit ;       
	        end
	ser_data_sel : begin
	         temp <= serial_data ;      
	        end	
	par_bit_sel : begin
	         temp <= parity ;       
	        end	
	stop_bit_sel : begin
	         temp <= stop_bit ;      
	        end		
	 default: begin
		       temp <= stop_bit ;
		      end
	endcase        	   
  end
 

//register mux output
always @ (posedge clk or negedge rst)
 begin
  if(!rst)
   begin
    tx_out <= 1'b0 ;
   end
  else
   begin
    tx_out <= temp ;
   end 
 end  

   endmodule

