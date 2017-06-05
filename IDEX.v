module IDEX(clock,WB,M,EX,DataA,DataB,imm_value,RegRs,RegRt,RegRd,WBreg,Mreg,
            EXreg,DataAreg, DataBreg,imm_valuereg,RegRsreg,RegRtreg,RegRdreg, IDShamt, EXShamt);
    input clock;
    input [1:0] WB;
    input [2:0] M;
    input [3:0] EX;
    input [4:0] RegRs,RegRt,RegRd;
    input [31:0] DataA,DataB,imm_value;
    input   [4:0]   IDShamt;
    output [1:0] WBreg;
    output [2:0] Mreg;
    output [3:0] EXreg;
    output [4:0] RegRsreg,RegRtreg,RegRdreg;
    output [31:0] DataAreg,DataBreg,imm_valuereg;
    output  reg [4:0]   EXShamt;
      
    reg [1:0] WBreg;
    reg [2:0] Mreg;
    reg [3:0] EXreg;
    reg [31:0] DataAreg,DataBreg,imm_valuereg;
    reg [4:0] RegRsreg,RegRtreg,RegRdreg;
    
    initial 
    begin         
        WBreg = 0;
        Mreg = 0;
        EXreg = 0;
        DataAreg = 0;
        DataBreg = 0;
        imm_valuereg = 0;
        RegRsreg = 0;
        RegRtreg = 0;
        RegRdreg = 0;
        EXShamt=0;
    end          
    
    always@(posedge clock)     
    begin         
        WBreg <= WB;
        Mreg <= M;
        EXreg <= EX;
        DataAreg <= DataA;
        DataBreg <= DataB;
        imm_valuereg <= imm_value;
        RegRsreg <= RegRs;
        RegRtreg <= RegRt;
        RegRdreg <= RegRd;
        EXShamt <= IDShamt;
    end      

endmodule 