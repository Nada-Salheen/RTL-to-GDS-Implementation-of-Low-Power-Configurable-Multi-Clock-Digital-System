module start_check(
  
  input wire start_check_en,
  input wire sampled_bit,
  output reg start_glitch
  );
  
  always@(*)
    begin
      if(start_check_en)
        begin
          if(( sampled_bit == 1'b0 ))
            begin
              start_glitch =1'b0;
            end
          else
            begin
              start_glitch =1'b1;
            end
          end
        else
          begin
            start_glitch =1'b0;
          end
          
      end
      
endmodule






