module Dynamic_Branch_Predict(clk, pc_in, instr, pc_out, predict,PCSrc, final_PCSrc, predict_ID
                  ,branch_instr_ID  );

    input   clk, PCSrc;
    input   [31:0] instr, pc_in;
    output  reg [31:0] pc_out;
    output  reg predict, predict_ID, branch_instr_ID;
    output  reg [1:0] final_PCSrc;

    reg     [1:0] state, stateEX, next_state;
    reg     branch_instr;
    reg     jump_instr, wait_to_check, check;

    parameter TAKE = 2'b00;
    parameter WEAKLY_TAKE = 2'b01;
    parameter WEAKLY_NOTTAKE = 2'b10;
    parameter NOT_TAKE = 2'b11;

    initial 
    begin
      pc_out=0;
      state = WEAKLY_TAKE;
      stateEX = WEAKLY_TAKE;
      next_state = WEAKLY_TAKE;
      predict =0;
      branch_instr=0;
      jump_instr=0;
      wait_to_check =0;
      check=0;
      final_PCSrc =0;
      branch_instr_ID=0;
      predict_ID=0;
    end

    assign op = instr[31:26];

    always@(*)
    begin
        if((instr[31:26] == 6'd4 )| (instr[31:26] == 6'd7 )| (instr[31:26] == 6'd5))      //beq, bgtz, bne
        begin   
            branch_instr=1;
            jump_instr=0;
        end
        else if(instr[31:26] == 6'd2) //jump
        begin    
            jump_instr=1;
            branch_instr=0;
        end
        
        else
        begin
            branch_instr=0;
            jump_instr=0;
        end
    end

    always@(*)
    begin
        if(branch_instr)
        begin   
            if(state == TAKE || state == WEAKLY_TAKE)
            begin
                pc_out = pc_in + $signed({instr[15:0],2'b00});
                predict = 1;
                wait_to_check=1;
            end
            else    //predict not to branch
            begin
                predict=0;
                pc_out=pc_in;
                wait_to_check=1;
            end
        end

        else if(jump_instr)
        begin   
                pc_out = {instr[25:0],2'b00};
                predict = 1;
                wait_to_check=0;    //do not check jump
        end

        else
        begin
            pc_out = pc_in;
            predict=0;
            wait_to_check=0;
        end
    end   

    //validate module during ID
    always@(negedge clk) 
    begin
        if((check))
        begin
            if(!PCSrc & (predict_ID))  //predict to brach but actually not
            begin
                final_PCSrc <= 2'b11;   //flush and set PC to sequential value
                wait_to_check<=0;
                next_state<=state+2'b01;
            end

            else if(PCSrc & predict_ID )     //predict to branch and actually take branch
            begin
                final_PCSrc <= 2'b00;
                wait_to_check <=0;
                next_state<=TAKE;
            end

            else if(PCSrc & !predict_ID)    //predict not to take but actually take
            begin
                final_PCSrc <= 2'b10;
                wait_to_check<=0;
                next_state<=state-2'b01;
            end

            else
            begin
                final_PCSrc <= 2'b00;
                wait_to_check<=0;
                next_state<=NOT_TAKE;
            end
        end
        else
        begin   
            final_PCSrc <= 2'b00;
            //wait_to_check<=0;
        end
    end


    always@(posedge clk)
    begin
        check<=wait_to_check;
        predict_ID<=predict;
        branch_instr_ID<=branch_instr;
        //stateEX<=state;
        state<=next_state;
    end
    
        
    
    
endmodule 