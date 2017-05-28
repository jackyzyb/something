module Registers(clock,WE,InData,WrReg,ReadA,ReadB,OutA,OutB);
    input [4:0] WrReg, ReadA, ReadB;
    input WE,clock;
    input [31:0] InData;
    output [31:0] OutA,OutB;
    reg [31:0] OutA, OutB;
    
    //2 32-bit output reg     
    reg [31:0] regfile[31:0];
    
    //32 32-bit registers          
    
    initial 
    begin         
    OutA = -20572;
    //random values for initial         
    OutB = -398567;
    end          
    
    always@(clock,InData,WrReg,WE)     
    begin       
        if(WE && clock)         
        begin          
            regfile[WrReg]<=InData;//write to register          
            $display("Does WrReg: %d Data: %d",WrReg,InData);
        end 
    end          
    
    always @ (clock,ReadA,ReadB,WrReg)     
    begin         
        if(~clock)         
        begin       
            OutA <= regfile[ReadA];
            //read values from registers       
            OutB <= regfile[ReadB];
            $monitor ("R3: %d R4: %d R5 %d R6: %d R7: %d R8 %d R9: %d R10: %d R11 %d R12: %d R13: %d R14 %d",regfile[3],regfile[4],regfile[5],regfile[6],regfile[7],regfile[8],regfile[9],regfile[10],regfile[11],regfile[12],regfile[13],regfile[14]);
        end     
    end   
endmodule  