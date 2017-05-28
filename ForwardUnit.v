module ForwardUnit(IDRegRs, IDRegRt, EXRegRd, EXWB, MEMRegRd,WBRegRd,EXRegRs,EXRegRt, MEM_RegWrite, WB_RegWrite, 
            ForwardA, ForwardB,ForwardBranchA, ForwardBranchB, immE);
    input[4:0] MEMRegRd,WBRegRd,EXRegRs,EXRegRt,IDRegRs, IDRegRt, EXRegRd;
    input MEM_RegWrite, WB_RegWrite, immE;
    input [1:0] EXWB;
    output[1:0] ForwardA, ForwardB, ForwardBranchA, ForwardBranchB;
 
    reg[1:0] ForwardA, ForwardB, ForwardBranchA, ForwardBranchB;
    
    //Forward A    
    
    always@(MEM_RegWrite or MEMRegRd or EXRegRs or WB_RegWrite or WBRegRd)    
    begin       
        if((MEM_RegWrite)&&(MEMRegRd != 0)&&(MEMRegRd == EXRegRs))          
            ForwardA = 2'b10;
        else if((WB_RegWrite)&&(WBRegRd != 0)&&(WBRegRd == EXRegRs)&&(MEMRegRd != EXRegRs) )          
            ForwardA = 2'b01;
        else          
            ForwardA = 2'b00;
    end  


    //Forward B    
    always@(WB_RegWrite or WBRegRd or EXRegRt or MEMRegRd or MEM_RegWrite)    
    begin       
        if((WB_RegWrite)&&(WBRegRd != 0)&&(WBRegRd == EXRegRt)&&(MEMRegRd != EXRegRt) ) 
            ForwardB = 2'b01;
        else if((MEM_RegWrite)&&(MEMRegRd != 0)&&(MEMRegRd == EXRegRt))          
            ForwardB = 2'b10;
        else           
            ForwardB = 2'b00;
    end  
    
    assign EX_RegWrite = EXWB[0] && (~EXWB[1]);

    //ForwardBranchA
    always@(*)
    begin
        if(EX_RegWrite && ((!immE && (EXRegRd == IDRegRs)) | (immE && (EXRegRt == IDRegRs))) )
            ForwardBranchA = 2'b01;
        else    
            ForwardBranchA = 2'b00;
    end

    //ForwardBranchB
    always@(*)
    begin
        if(EX_RegWrite && ((!immE && (EXRegRd == IDRegRt)) | (immE && (EXRegRt == IDRegRt))) )
            ForwardBranchB = 2'b01;
        else    
            ForwardBranchB = 2'b00;
    end


endmodule 