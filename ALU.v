module ALU(ALUCon,DataA,DataB,Result,ALUoverflow);
    input [3:0] ALUCon;
    input signed [31:0] DataA,DataB;
    output [31:0] Result;
    output reg ALUoverflow;
    reg [31:0] Result;
    reg Zero;

    //assign Result=ResultTemp[31:0];     
    
    initial 
    begin         
        Result = 32'd0;
        ALUoverflow=0;
    end 

    always@(ALUCon,DataA,DataB)     
    begin        
        case(ALUCon)           
            4'b0000://and              
                Result <= DataA&DataB;
            4'b0001://or              
                Result <= DataA|DataB;
            4'b0010://add  
                Result <= DataA+DataB;
            
            4'b0011://multiply               
                Result <= DataA*DataB;
            4'b0100://nor               
            begin 
                Result <= ~(DataA | DataB);          
                /*       
                Result[0] <= !(DataA[0]|DataB[0]);
                Result[1] <= !(DataA[1]|DataB[1]);
                Result[2] <= !(DataA[2]|DataB[2]);
                Result[3] <= !(DataA[3]|DataB[3]);
                Result[4] <= !(DataA[4]|DataB[4]);
                Result[5] <= !(DataA[5]|DataB[5]);
                Result[6] <= !(DataA[6]|DataB[6]);
                Result[7] <= !(DataA[7]|DataB[7]);
                Result[8] <= !(DataA[8]|DataB[8]);
                Result[9] <= !(DataA[9]|DataB[9]);
                Result[10] <= !(DataA[10]|DataB[10]);
                Result[11] <= !(DataA[11]|DataB[11]);
                Result[12] <= !(DataA[12]|DataB[12]);
                Result[13] <= !(DataA[13]|DataB[13]);
                Result[14] <= !(DataA[14]|DataB[14]);
                Result[15] <= !(DataA[15]|DataB[15]);
                Result[16] <= !(DataA[16]|DataB[16]);
                Result[17] <= !(DataA[17]|DataB[17]);
                Result[18] <= !(DataA[18]|DataB[18]);
                Result[19] <= !(DataA[19]|DataB[19]);
                Result[20] <= !(DataA[20]|DataB[20]);
                Result[21] <= !(DataA[21]|DataB[21]);
                Result[22] <= !(DataA[22]|DataB[22]);
                Result[23] <= !(DataA[23]|DataB[23]);
                Result[24] <= !(DataA[24]|DataB[24]);
                Result[25] <= !(DataA[25]|DataB[25]);
                Result[26] <= !(DataA[26]|DataB[26]);
                Result[27] <= !(DataA[27]|DataB[27]);
                Result[28] <= !(DataA[28]|DataB[28]);
                Result[29] <= !(DataA[29]|DataB[29]);
                Result[30] <= !(DataA[30]|DataB[30]);
                Result[31] <= !(DataA[31]|DataB[31]);
                */
            end                          
              
            //4'b0101://divide              
            //    Result <= DataA/DataB;
            4'b0110://sub              
                Result <= DataA-DataB;
 
            4'b0111://slt              
                Result <= DataA<DataB ? 1:0;
            4'b1000://sll              
                Result <= (DataA<<DataB);
            4'b0110://srl              
                Result <= (DataA>>DataB);
            4'b1000://addu
                Result <= DataA + DataB;
            4'b1001://subu
                Result <= DataA - DataB;
            4'b1010://xor
                Result <= DataA ^ DataB;

     
        default: //error           
        begin               
            $display("ALUERROR");
            Result <= 0;
        end                  
        
        endcase     
    end  

    always@(*)
    begin   
        if(ALUCon == 4'b0010 | ALUCon == 4'b0110)
        begin
            //add and sub, check overflow
            if(DataA[31]==DataB[31 && DataA[31]!= Result[31]])
                ALUoverflow=1;
            else
                ALUoverflow=0;
        end
        else
            ALUoverflow=0;
    end

endmodule 