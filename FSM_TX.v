module FSM_TX# (parameter start_bit_sel=3'd1, ser_data_sel=3'd2,
par_bit_sel=3'd3,stop_bit_sel=3'd4)(

  input wire data_valid, par_en, ser_done,
  input wire clk, rst,
  output reg ser_en, busy, 
  output reg [2:0] mux_sel
  );

localparam [2:0] IDLE = 3'b000,
                 Start_bit = 3'b001,
                 Data_send = 3'b011,
                 Parity_bit = 3'b010,
                 Stop_bit = 3'b110;

reg [2:0] current_state;
reg [2:0] next_state;
reg busy_temp;

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
        ser_en=1'b0;
        busy_temp=1'b0;
        mux_sel=stop_bit_sel;
    case(current_state)
      IDLE: begin
        ser_en=1'b0;
        busy_temp=1'b0; 
        mux_sel=stop_bit_sel;

        //we wait for the vaild signal and for the data to be ready from the sernding when it is done after processing
        if((data_valid == 1'b1))
          begin
            next_state=Start_bit;
          end
        else
          begin
            
            next_state=IDLE;
          end
      end
        
      Start_bit: begin

        busy_temp=1'b1;
        mux_sel=start_bit_sel;
        next_state=Data_send;
      end
      
      Data_send: begin
        busy_temp=1'b1;
        mux_sel=ser_data_sel;
        if(ser_done)
          begin
            if(par_en)
              begin
              	next_state=Parity_bit;
             end
           else
             begin
               next_state=Stop_bit;
             end
            ser_en=1'b0;
          end
        else
          begin
            ser_en=1'b1;
            
            next_state=Data_send;
          end
      end
      
      Parity_bit: begin
             busy_temp=1'b1;
             mux_sel=par_bit_sel;
             next_state=Stop_bit;
           end
      
      Stop_bit: begin
            busy_temp=1'b1;
            mux_sel=stop_bit_sel;
            if((data_valid == 1'b1))
              begin
                next_state=Start_bit;
              end
            else
              begin
               next_state=IDLE; 
              end
      end
      
      default: begin
        ser_en=1'b0;
        busy_temp=1'b0; 
        mux_sel=stop_bit_sel;
        next_state=IDLE;
      end
      
    endcase
    
 end
//register output 
always @ (posedge clk or negedge rst)
 begin
  if(!rst)
   begin
    busy <= 1'b0 ;
   end
  else
   begin
    busy <= busy_temp ;
   end
 end
endmodule
    


