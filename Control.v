module Control(Op,func,Out,jump,bne,imm,andi,ori,addi,bgtz,j,jr,slti);
    input [5:0] Op;
    input [5:0] func; 
    output[8:0] Out;
    output jump,bne,imm,andi,ori,addi,bgtz,j,jr, slti;
    wire regdst,alusrc,memtoreg,regwrite,memread,memwrite,branch;
    
    //determines type of instruction    
    wire r = Op==6'h0;
    wire lw = Op==6'b100011;
    wire sw = Op==6'b101011;
    wire beq = Op==6'b000100;
    wire bne = Op==6'b000101;
    wire bgtz = Op==6'b000111;
    wire j = Op==6'b000010;
    wire jr=(Op==6'h0 && func == 6'h8);
    wire andi = Op==6'b001100;
    wire ori = Op==6'b001101;
    wire addi = Op==6'b001000;
    wire slti = (Op == 6'ha);
    wire imm = andi|ori|addi|slti;
    //immediate value type       

    assign jump = j | jr; 
    
    //seperate control arrays for reference    
    wire [3:0] EXE;
    wire [2:0] M;
    wire [1:0] WB;
    
    // microcode control       
    assign regdst = r;
    assign alusrc = lw|sw|imm;
    assign memtoreg = lw;
    assign regwrite = r|lw|imm;
    assign memread = lw;
    assign memwrite = sw;
    assign branch = beq;
    // EXE control  
    assign EXE[3] = regdst;
    assign EXE[2] = alusrc;
    assign EXE[1] = r|imm;
    assign EXE[0] = beq|imm;
    //M control  
    assign M[2] = branch;
    assign M[1] = memread;
    assign M[0] = memwrite;
    //WB control  
    assign WB[1] = memtoreg;
    //not same as diagram  
    assign WB[0] = regwrite;
   //output control  
    assign Out[8:7] = WB;
    assign Out[6:4] = M;
    assign Out[3:0] = EXE;
    
endmodule