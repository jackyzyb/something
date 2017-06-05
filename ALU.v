module ALU(ALUCon,DataA,DataB,Result,ALUoverflow, Shamt);
    input [3:0] ALUCon;
    input signed [31:0] DataA,DataB;
    input [4:0] Shamt;
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
            
            4'b0011://sllv               
                Result <= DataB << DataA;
            4'b0100://nor               
            begin 
                Result <= ~(DataA | DataB);          
            end                          
              
            4'b0101://srlv              
                Result <= DataB >> DataA;
            4'b0110://sub              
                Result <= DataA-DataB;
 
            4'b0111://slt              
                Result <= DataA<DataB ? 1:0;
            4'b1000://addu
                Result <= DataA + DataB;
            4'b1001://subu
                Result <= DataA - DataB;
            4'b1010://xor
                Result <= DataA ^ DataB;
            4'b1011://sll              
                Result <= (DataB<<Shamt);
            4'b1100://srl              
                Result <= (DataB>>Shamt);
            4'b1101://sra              
                Result <= (DataB>>Shamt);    
            4'b1110://srav              
                Result <= (DataB>>DataA);  
            4'b1111://sltu              
                Result <= ($unsigned(DataA)<$unsigned(DataB))?1:0;  

     
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