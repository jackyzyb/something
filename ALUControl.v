module ALUControl(slti, andi,ori,addi,ALUOp,funct,ALUCon);
    input [1:0] ALUOp;
    input [5:0] funct;
    input andi,ori,addi,slti;
    output [3:0] ALUCon;
    reg [3:0] ALUCon;
         
    always@(ALUOp or funct or andi or ori or addi)     
    begin       
        case(ALUOp)         
            2'b00://lw or sw            
                ALUCon = 4'b0010;
            2'b01://beq            
                ALUCon = 4'b0110;
            2'b10://R-type         
            begin            
                if(funct==6'b100100)               
                    ALUCon = 4'b0000;//and            
                if(funct==6'b100101)               
                    ALUCon = 4'b0001;//or            
                if(funct==6'b100000)               
                    ALUCon = 4'b0010;//add            
                if(funct==6'h4)               
                    ALUCon = 4'b0011;//sllv    
                if(funct==6'b100111)               
                    ALUCon = 4'b0100;//nor            
                if(funct==6'h6)               
                    ALUCon = 4'b0101;//srlv          
                if(funct==6'b100010)               
                    ALUCon = 4'b0110;//sub            
                if(funct==6'h2a)               
                    ALUCon = 4'b0111;//slt     
                if(funct==6'h21)
                    ALUCon = 4'b1000;//addu
                if(funct==6'h23)
                    ALUCon = 4'b1001;//subu
                if(funct==6'h26)
                    ALUCon = 4'b1010;//xor
                if(funct==6'h0)
                    ALUCon = 4'b1011;//sll
                if(funct==6'h2)
                    ALUCon = 4'b1100;//srl
                if(funct==6'h3)
                    ALUCon = 4'b1101;//sra
                if(funct==6'h7)
                    ALUCon = 4'b1110;//srav
                if(funct==6'h2b)
                    ALUCon = 4'b1111;//sltu
                
                
            end       
            2'b11://immediate       
            begin           
                if(andi)
                begin              
                    ALUCon = 4'b0000;//andi          
                end           
                if(ori) 
                begin              
                    ALUCon = 4'b0001;//ori          
                end           
                if(addi)              
                    ALUCon = 4'b0010;//addi      
                if(slti)              
                    ALUCon = 4'b0111;//slti    
            end     
        endcase     
    end  
endmodule   