module System_FSM # ( parameter data_width = 16, frame_data_width =8 , function_width=4 , addr_width=4 ,
register_file_write_command = 8'hAA ,register_file_read_command = 8'hBB ,ALU_with_op_command = 8'hCC ,
ALU_without_op_command = 8'hDD)(
  
  input [data_width-1:0] ALU_OUT,
  input wire OUT_VALID , RX_D_VLD , Rd_Data_Valid,
  input wire [frame_data_width-1:0] RX_P_DATA , Rd_Data ,
  input wire CLK,RST,
  input wire FIFO_FULL,
  
  output reg ALU_EN , CLK_EN , WrEn , RdEn , TX_D_VLD , clk_div_en,
  output reg [frame_data_width-1:0] WrData , TX_P_DATA ,
  output reg [function_width-1:0] ALU_FUN,
  output reg [addr_width-1:0] address
  );
  
  localparam [3:0] IDLE = 'b0000,
                   RX_Recieve = 'b0001,
                   ALU_Operation = 'b0011 ,
                   Operand_A = 'b0010,
                   Operand_B = 'b0110,
                   ALU_fun = 'b0111 ,
                   ALU_Done = 'b0101,
                   Reg_file_write_address = 'b0100 ,
                   Reg_file_write_data = 'b1100 ,
                   Reg_file_read_address = 'b1101 ,
                   Register_file_read = 'b1111,
                   FIFO_PUSH = 'b1110 ,
                   FIFO_PUSH_ALU = 'b1010 ;

                   
                   
reg [3:0] current_state , next_state;
reg [frame_data_width-1:0] recieved_data;
reg [frame_data_width-1:0] recieved_address;
reg [addr_width-1:0] read_address;
reg [frame_data_width-1:0] read_data;

reg [frame_data_width-1:0] Operand1;
reg [frame_data_width-1:0] Operand2;
reg [data_width-1:0] alu_output;

reg [1:0] count ;

always@(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        current_state <= IDLE;
      end
    else
      begin
      current_state <= next_state;
      end
  end


always@(*)
  begin
    case(current_state)

      IDLE: begin
        ALU_EN = 'b0;
        CLK_EN = 'b1;
        WrEn = 'b0;
        RdEn = 'b0;
        TX_D_VLD = 'b0;
        clk_div_en = 'b1;
        ALU_FUN = 'b0;
        WrData = 'b0;
        TX_P_DATA = 'hFF;
        address = 'b0;
        count = 'd0;
        if(RX_D_VLD)
          begin
            next_state = RX_Recieve;
          end
        else
          begin
            next_state = IDLE;
          end
        
      end
      
      RX_Recieve: begin
        
        case(RX_P_DATA)
          
          register_file_write_command: begin
            
            next_state = Reg_file_write_address;
          end
          
          register_file_read_command: begin
            
            next_state = Reg_file_read_address;
          end
          
          ALU_with_op_command: begin
            CLK_EN = 'b1;
            next_state = ALU_Operation;
          end
          
          ALU_without_op_command: begin
            next_state = ALU_fun;
          end
          
      endcase
    end
    
      Reg_file_write_address: begin
        if(RX_D_VLD)
          begin
            recieved_address = RX_P_DATA;
            next_state = Reg_file_write_data;
          end
        else
          begin
            next_state = Reg_file_write_address;
          end  
      end
      
      Reg_file_write_data: begin
        
        if(RX_D_VLD)
          begin
            recieved_data = RX_P_DATA;
            WrEn = 'b1;
            address = recieved_address;
            WrData = recieved_data;
            next_state = IDLE;
          end
        else
          begin
            next_state = Reg_file_write_data;
          end 
      end
      
      Reg_file_read_address: begin
        
        if(RX_D_VLD)
          begin
            read_address = RX_P_DATA;
            RdEn = 'b1;
            next_state = Register_file_read;
          end
        else
          begin
            next_state = Reg_file_read_address;
          end 
      end
      
      Register_file_read: begin
        CLK_EN = 'b1;
        if(Rd_Data_Valid)
          begin
            RdEn = 'b0;
            
            read_data = Rd_Data;
            TX_P_DATA = read_data;
            next_state= FIFO_PUSH;
            
          end
          
        else
          begin
            next_state = Register_file_read;
          end
        
      end
      
      FIFO_PUSH: begin
          if(!FIFO_FULL)
              begin
                TX_D_VLD = 'b1;
                next_state= IDLE;
              end
            else
              begin
                next_state = FIFO_PUSH ;
              end
     
      end
      
      ALU_Operation: begin
        
        next_state = Operand_A;

      end
      
      Operand_A: begin
        
        if(RX_D_VLD)
          begin
            Operand1 = RX_P_DATA;
            address = 'd0;
            WrData = Operand1;
            WrEn = 'b1;
            next_state = Operand_B;
          end
        else
          begin
            next_state = Operand_A;
          end 
      end
      
      Operand_B: begin

        if(RX_D_VLD)
          begin
            Operand2 = RX_P_DATA;
            address = 'd1;
            WrData = Operand2;
            WrEn = 'b1;
            next_state = ALU_fun;
          end
        else
          begin
            next_state = Operand_B;
          end
      end

      
      ALU_fun: begin
        if(RX_D_VLD)
          begin
            ALU_FUN = RX_P_DATA;
            WrEn = 'b0;
            ALU_EN ='b1;
            next_state = ALU_Done;
          end
        else
          begin
            next_state = Operand_B;
          end
      end
      
      ALU_Done: begin
        
        if(OUT_VALID)
          begin
            alu_output = ALU_OUT;
            if(count == 'b0)
              begin
                TX_P_DATA = alu_output[7:0];
                next_state = FIFO_PUSH_ALU;
                count = count+1;
              end
            else if(count == 'b1)
              begin
                TX_P_DATA = alu_output[15:7];
                next_state = FIFO_PUSH_ALU;
                count = count+1;
              end
            else
              begin
                next_state = IDLE;
                count ='d0;
              end
          end
          
        else
          begin
            next_state = ALU_Done;
          end
      end

      FIFO_PUSH_ALU: begin
          if(!FIFO_FULL)
              begin
                TX_D_VLD = 'b1;
                if(count < 'd2)
                  begin
                    next_state= ALU_Done;
                  end
                else
                  begin
                    next_state= IDLE;
                    count ='d0;
                  end
              end
            else
              begin
                next_state = FIFO_PUSH_ALU ;
              end
     
      end
      default: begin
        
        ALU_EN = 'b0;
        CLK_EN = 'b0;
        WrEn = 'b0;
        RdEn = 'b0;
        TX_D_VLD = 'b0;
        clk_div_en = 'b0;
        ALU_FUN = 'b0;
        WrData = 'b0;
        TX_P_DATA = 'b0;
        address = 'b0;
        count = 'd0;
        next_state = IDLE;
      end
      
  endcase
end
  
  
endmodule
