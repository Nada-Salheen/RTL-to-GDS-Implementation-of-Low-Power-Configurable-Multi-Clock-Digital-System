module deserializer# (parameter pre_scalar=8, data_width=8)(
  
  input wire des_en,
  input wire sampled_bit,
  input wire [3:0] edge_counter,
  input wire clk, rst,
  output reg [data_width-1:0] p_data
  );
  
reg [data_width-1:0] data;
reg [3:0] count;
      
 always@(posedge clk or negedge rst)
    begin     
      if(!rst)
        begin
          data<='b0;
          count<='b0;
        end
      else
        begin
          if(des_en && (edge_counter == 'd7))
            begin
              data[count] <= sampled_bit;
              count<=count+1;
          end
        else
          begin
            if(des_en)
              begin
                count<=count;
              end
            else
              begin
                count<='b0;
              end
          end
        end
    end
   
always@(*)
  begin
  p_data = data;
end   
    
// always@(posedge clk or negedge rst)
//    begin     
//      if(!rst)
//        begin
//          p_data<='b0;
//        end
//      else
//        begin
//            p_data<= data;
//        end
//      end
      
endmodule

