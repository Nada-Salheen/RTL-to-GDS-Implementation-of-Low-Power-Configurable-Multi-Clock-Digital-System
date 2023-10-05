module parity_check# (parameter pre_scalar=8, data_width=8, even_parity=0, odd_parity=1)(
  
  input wire parity_type, parity_check_en,
  input wire sampled_bit, parity_enable,
  input wire [3:0] edge_num, bit_num,
  input wire clk, rst,
  output reg parity_error
  );
  
  reg temp;
  reg [data_width+1:0] data;
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
           if(parity_enable && (edge_num == 'd7)&& (bit_num<=9))
            begin
              data[count] <= sampled_bit;
              count<=count+1;
            end
        else
          begin
            if(parity_enable && (bit_num<=9))
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
      if(parity_check_en)
        begin
          if(parity_type == even_parity)
            begin
              temp = ^data[8:1];
            end
          else
            begin
              temp = ~^data[8:1];
            end
          end
        else
          begin
            temp = 'b0;
          end
        end
  
  always@(*)
    begin
      if(parity_check_en && ((bit_num == 'd9)||(bit_num == 'd10)))
        begin
          if(temp == data[9])
            begin
              parity_error=1'b0;
            end
          else
            begin
             parity_error=1'b1;
            end
        end
      else
        begin
          parity_error='b0;
        end
      end
      
endmodule



