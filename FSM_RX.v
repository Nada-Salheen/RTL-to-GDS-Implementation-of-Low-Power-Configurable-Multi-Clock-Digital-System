module FSM_RX(
  
  input wire RX_IN,
  input wire parity_en,
  input [3:0] bit_count, edge_count,
  input wire par_error, stop_error, start_error,
  input wire clk, rst,
  output reg data_valid,
  output reg par_check_enable, start_check_enable, stop_check_enable,
  output reg deserializer_enable, counter_enable, sampler_enable
  
  );

localparam [2:0] IDLE = 3'b000,
                 Start_check = 3'b001,
                 deserializer_on = 3'b011,
                 Parity_check = 3'b010,
                 Stop_check = 3'b110;

reg [2:0] current_state;
reg [2:0] next_state;

reg data_valid_temp;
wire flag;

assign flag = (par_error || stop_error || start_error);


always@(posedge clk or negedge rst)
  begin
    if(!rst)
      begin
        current_state<=IDLE;
      end
    else
      begin
        current_state<=next_state;
      end
    end
    
    
always@(*)
  begin
    
    case(current_state)
      IDLE: begin
        
        par_check_enable='b0;
        start_check_enable='b0;
        stop_check_enable='b0;
        deserializer_enable='b0;
        counter_enable='b0;
        sampler_enable='b0;
        data_valid_temp='b0;
        
        if((RX_IN == 'b0) && !flag)
          begin
            next_state = Start_check;
          end
      end
        
      Start_check: begin
        par_check_enable='b0;
        data_valid_temp='b0;
        counter_enable = 1'b1;
        sampler_enable = 'b1;
        stop_check_enable = 'b0;
        if((edge_count=='d8) && (bit_count=='d0))
          begin
            start_check_enable = 1'b1;
            
             if(start_error)
                begin
                  next_state = IDLE;
                end
              else
                begin
                  next_state=deserializer_on;
                end
           end
        else
          begin
            next_state = Start_check;
          end

      end
      deserializer_on: begin
       
        start_check_enable = 1'b0;
        deserializer_enable=1'b1;
        if(bit_count == 'd9 && (parity_en))
          begin
            next_state=Parity_check;
          end
        else if(bit_count == 'd9 && (!parity_en))
          begin
            next_state=Stop_check;
          end
        else
          begin
            next_state=deserializer_on;
          end
        
      end 
      
      Parity_check: begin
        deserializer_enable=1'b0;

        if((edge_count=='d8))
          begin
            par_check_enable=1'b1;
            next_state=Stop_check;
          end
        else
          next_state=Parity_check;
           end
           
      
      Stop_check: begin

        if((edge_count=='d7))
          begin
            stop_check_enable = 1'b1;
            
            if(flag)
            begin
              data_valid_temp='b0;
              next_state=IDLE;
            end
          else
            begin
              data_valid_temp='b1;
              next_state=Start_check;
              
            end
            
          end
          
        else
          begin
             next_state=Stop_check;
          end          

      end
      
      default: begin
        par_check_enable='b0;
        start_check_enable='b0;
        stop_check_enable='b0;
        deserializer_enable='b0;
        counter_enable='b0;
        sampler_enable='b0;
        data_valid_temp='b0;
        next_state=IDLE;
      end
      
    endcase
    
 end


always @ (posedge clk or negedge rst)
 begin
  if(!rst)
   begin
    data_valid <= 1'b0 ;
   end
  else
   begin
    data_valid <= data_valid_temp ;
   end
 end    
    
    
    
endmodule
