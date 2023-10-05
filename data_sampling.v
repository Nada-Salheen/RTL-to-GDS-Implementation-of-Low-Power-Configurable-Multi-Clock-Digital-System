module data_sampling#(parameter pre_scalar=8, data_width=8)(
  
  input wire RX_in,
  input wire [5:0] prescalar,
  input wire data_sampling_en , 
  input wire [3:0] edge_count,
  input wire clk, rst,
  output reg sampled_bit

  );
  
  reg first_sample;
  reg second_sample;
  reg third_sample;
  
  reg temp;
  
  always@(*)
    begin
      if(data_sampling_en)
        begin
          if(edge_count == ((prescalar/2)-1))
            begin
              first_sample=RX_in;
            end
          else if(edge_count == (prescalar/2))
              begin
              second_sample=RX_in;
            end
          else if(edge_count == ((prescalar/2)+1))
              begin
              third_sample=RX_in;
            end
          else
            begin
              first_sample = first_sample;
              second_sample = second_sample;
              third_sample = third_sample;
            end
      end
    else
      begin
        first_sample='b0;
        second_sample='b0;
        third_sample='b0;
    end
  end
  
  always@(*)
    begin
      if((first_sample=='b0)&&(second_sample=='b0)&&(third_sample=='b0))
        begin
          temp='b0;
        end
      else if((first_sample=='b0)&&(second_sample=='b1)&&(third_sample=='b0))
        begin
          temp='b1;
        end
      else if((first_sample=='b1)&&(second_sample=='b0)&&(third_sample=='b0))
        begin
          temp='b0;
        end 
      else if((first_sample=='b1)&&(second_sample=='b0)&&(third_sample=='b1))
        begin
          temp='b0;
        end  
      else if((first_sample=='b1)&&(second_sample=='b1)&&(third_sample=='b1))
        begin
          temp='b1;
        end   
      else if((first_sample=='b0)&&(second_sample=='b0)&&(third_sample=='b1))
        begin
          temp='b0;
        end   
      else if((first_sample=='b0)&&(second_sample=='b1)&&(third_sample=='b1))
        begin
          temp='b1;
        end   
      else if((first_sample=='b1)&&(second_sample=='b1)&&(third_sample=='b0))
        begin
          temp='b1;
        end
      else
        begin
          temp='b0;
        end
        
      end 

always@(posedge clk or negedge rst)
    begin
    if(!rst)
      begin
       sampled_bit<='b0;
     end
   else
     begin
      sampled_bit<=temp;
    end
 end

endmodule
