module edge_bit_counter#( parameter width=8)(
  
  input wire enable,
  input wire parity_en,
  input wire clk, rst,
  output reg [3:0] bit_count, edge_count

  );
 
 reg flag;
 
 always@(posedge clk or negedge rst)
    begin
      if(!rst)
        begin
          edge_count <= 'b1;
          bit_count <= 'b0;
        end
      else
        begin
          if(enable)
            begin
              if(flag == 'b0)
                begin
                  edge_count <= edge_count + 'b1;
                end
              else
                begin
                  edge_count <= 1;
                  bit_count <= bit_count + 'b1;
                  if(parity_en)
                    begin
                      if(bit_count == 'd10)
                        begin
                          bit_count <= 'd0;
                        end
                    end
                  else
                    begin
                      if(bit_count == 'd9)
                        begin
                          bit_count <= 'd0;
                        end
                    end

                    
                end 
            end

        else
          begin
             edge_count <= 'b1;
          end
    end 
end

always@(*)
    begin
      if(edge_count == 4'd8)
        begin
            flag='b1;
        end
      else
        begin
           flag='b0;
         end
    end

endmodule
