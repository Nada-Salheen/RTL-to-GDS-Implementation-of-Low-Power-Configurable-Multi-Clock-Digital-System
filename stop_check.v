module stop_check# (parameter pre_scalar=8, data_width=8, stop_bit=1)(
  
  input wire stop_check_en, with_parity,
  input wire sampled_bit,
  input wire clk, rst,
  output reg stop_error
  );
  
always@(*)
    begin
      if(stop_check_en)
        begin
          if(with_parity)
            begin
              if(stop_bit == sampled_bit)
                begin
                  stop_error=1'b0;
                end
              else
                begin
                  stop_error=1'b1;
                end
              end
          else
            begin
              if(stop_bit == sampled_bit)
                begin
                  stop_error=1'b0;
                end
              else
                begin
                  stop_error=1'b1;
                end
            end
          end
        else
          begin
            stop_error=1'b0;
          end
      end
      
endmodule

