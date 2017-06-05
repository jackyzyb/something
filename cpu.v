module cpu(
    input clock,
         //debugging vars    
    output reg [31:0] cycle,
         //IF vars     
    output   [31:0] nextpc,IFpc_plus_4,IFinst,
    output   [31:0] pc,
         //ID vars     
    output   PCSrc,
    output   [4:0] IDRegRs,IDRegRt,IDRegRd,
    output   [31:0] IDpc_plus_4,IDinst,
    output   [31:0] IDRegAout, IDRegBout,
    output   [31:0] IDimm_value,BranchAddr,PCMuxOut,JumpTarget,J_Target, Jr_Target,
         //control vars in ID stage     
    output   PCWrite,IFIDWrite,HazMuxCon,jump,bne,imm,andi,ori,addi,bgtz,j,jr,slti,
    output   reg  addiE,oriE,andiE,immE,
    output   ALUoverflow,
    output   [8:0] IDcontrol,ConOut,
             //EX vars     
    output   [1:0] EXWB,EXWB2MEM,ForwardA,ForwardB,aluop,ForwardBranchA, ForwardBranchB,
    output   [2:0] EXM,EXM2MEM,
    output   [3:0] EXEX,ALUCon,
    output   [4:0] EXRegRs,EXRegRt,EXRegRd,regtopass,
    output   [31:0] EXRegAout,EXRegBout,EXimm_value, b_value,
    output   [31:0] EXALUOut,ALUSrcA,ALUSrcB,
         //MEM vars     
    output   [1:0] MEMWB,
    output   [2:0] MEMM,
    output   [4:0] MEMRegRd,
    output   [31:0] MEMALUOut,MEMWriteData,MEMReadData,
         //WB vars     
    output   [1:0] WBWB,
    output   [4:0] WBRegRd,
    output   [31:0] datatowrite,WBReadData,WBALUOut,
    output   IFFlush, IDFlush, EXFlush,
    output   [31:0] cmpA,cmpB,
    output  [31:0]  nextpc_predicted,
    output  [31:0]  final_next_pc,
    output      Branch_predict, predict_ID, 
    output  [1:0] final_PCSrc,
    output  [4:0] IDShamt, EXShamt

    );

    wire branch_instr_ID;
            //initial conditions     
    initial
    begin
        cycle = 0;
        //Branch_predict=0;
        //nextpc_predicted=0;

    end  
            //debugging variable     
    always@(posedge clock)
    begin
            cycle = cycle + 1;
    end          

    //branch PC source compariosn module
    BIGMUX2 CMPA_MUX(ForwardBranchA, IDRegAout, EXALUOut, MEMALUOut, 0, cmpA);
    BIGMUX2 CMPB_MUX(ForwardBranchB, IDRegBout, EXALUOut, 0, 0, cmpB);
    //assign PCSrc = ((IDRegAout==IDRegBout)&IDcontrol[6])|((IDRegAout!=IDRegBout)&bne)
    //                | (($signed(IDRegAout)>0)&bgtz);
    assign PCSrc = ((cmpA==cmpB)&IDcontrol[6])|((cmpA!=cmpB)&bne)
                    | (($signed(cmpA)>0)&bgtz);


    //Dynamic Branch Predict
    Dynamic_Branch_Predict  uDynamic_Branch_Predict(clock, IFpc_plus_4, IFinst,nextpc_predicted, Branch_predict
                ,PCSrc, final_PCSrc, predict_ID, branch_instr_ID);

    assign final_next_pc = (Branch_predict & !(!predict_ID & PCSrc))?nextpc_predicted:nextpc;
    


    
    assign IFFlush = ((predict_ID == PCSrc ? 0: 1)& !jump & branch_instr_ID)|jr;//PCSrc|jump;
    assign IDFlush = ((predict_ID == PCSrc ? 0: 1)& !jump & branch_instr_ID)|jr;
    assign EXFlush = 0;
    assign IFpc_plus_4 = pc + 4;

 
    //assign nextpc = BranchAddr : PCMuxOut;
    BIGMUX2 mux_nextpc(final_PCSrc, PCMuxOut, 32'h0/*interupt*/, BranchAddr, IDpc_plus_4,nextpc);
    
    //PC module
    PC_Module   PCM(clock, final_next_pc, PCWrite, pc);           
    
    // IF //
    InstructMem IM({2'b00,pc[31:2]},IFinst);
    IFID IFIDreg(IFFlush,clock,IFIDWrite,IFpc_plus_4,IFinst,IDinst,IDpc_plus_4);

    //ID
    assign IDRegRs[4:0]=IDinst[25:21];
    assign IDRegRt[4:0]=IDinst[20:16];
    assign IDRegRd[4:0]=IDinst[15:11];
    assign IDShamt[4:0]=IDinst[10:6];
    assign IDimm_value = {IDinst[15],IDinst[15],IDinst[15],IDinst[15],IDinst[15],IDinst[15],IDinst[15],IDinst[15],IDinst[15],IDinst[15],IDinst[15],IDinst[15],IDinst[15],IDinst[15],IDinst[15],IDinst[15],IDinst[15:0]};
    assign BranchAddr = $signed(IDimm_value << 2) + $signed( IDpc_plus_4);

    assign J_Target[31:28] = IFpc_plus_4[31:28];
    assign J_Target[27:2] = IDinst[25:0];
    assign J_Target[1:0] = 0;

    assign Jr_Target = cmpA;

    assign JumpTarget=j?J_Target:Jr_Target;

    //about flush
    assign IDcontrol = (HazMuxCon & !IDFlush) ? ConOut : 0;
    assign PCMuxOut = jump ? (jr?JumpTarget:IFpc_plus_4) : IFpc_plus_4;
    assign EXM2MEM = EXFlush?3'h0:EXM;
    assign EXWB2MEM = EXFlush?2'h0:EXWB;

    HazardUnit HU(IDRegRs,IDRegRt,EXRegRt,EXM[1],PCWrite,IFIDWrite,HazMuxCon);
    Control thecontrol(IDinst[31:26],IDinst[5:0],ConOut,jump,bne,imm,andi,ori,addi,bgtz,j,jr,slti);


    //ID to EX signal passing
    //reg andiE,addiE, oriE, immE, immMEM;
    always@(posedge clock)
    begin
        andiE<=andi;
        addiE<=addi;
        oriE<=ori;
        immE<=imm;
    end



    Registers piperegs(clock,WBWB[0],datatowrite,WBRegRd,IDRegRs,IDRegRt,IDRegAout,IDRegBout);
    IDEX IDEXreg(clock,IDcontrol[8:7],IDcontrol[6:4],IDcontrol[3:0],IDRegAout,IDRegBout,IDimm_value,IDRegRs,IDRegRt,IDRegRd,EXWB,
            EXM,EXEX,EXRegAout,EXRegBout,EXimm_value,EXRegRs,EXRegRt,EXRegRd, IDShamt, EXShamt );
    /**      * Execution (EX)      */     
    assign regtopass = EXEX[3] ? EXRegRd : EXRegRt;
    assign b_value = EXEX[2] ? EXimm_value : ALUSrcB;   //log: ALUSrcB used to be EXRegBout 
    BIGMUX2 MUX0(ForwardA,EXRegAout,datatowrite,MEMALUOut,0,ALUSrcA);
    BIGMUX2 MUX1(ForwardB,EXRegBout/*b_value*/,datatowrite,MEMALUOut,0,ALUSrcB);
    ForwardUnit FU(IDRegRs, IDRegRt, EXRegRd, EXWB ,MEMRegRd,WBRegRd,EXRegRs, EXRegRt, MEMWB[0], WBWB[0],
                             ForwardA, ForwardB, ForwardBranchA, ForwardBranchB, immE);

    // ALU control   
    assign aluop[0] = (~IDinst[31]&~IDinst[30]&~IDinst[29]&IDinst[28]&~IDinst[27]&~IDinst[26])|(imm);
    assign aluop[1] = (~IDinst[31]&~IDinst[30]&~IDinst[29]&~IDinst[28]&~IDinst[27]&~IDinst[26])|(imm);
    ALUControl ALUcontrol(slti,andiE,oriE,addiE,EXEX[1:0],EXimm_value[5:0],ALUCon);
    ALU theALU(ALUCon,ALUSrcA,b_value/*ALUSrcB*/,EXALUOut,ALUoverflow, EXShamt);
    EXMEM EXMEMreg(clock,EXWB2MEM,EXM2MEM,EXALUOut,regtopass, ALUSrcB/*EXRegBout*/,MEMM,MEMWB,MEMALUOut,MEMRegRd,MEMWriteData);
    /**      * Memory (Mem)      */     
    DATAMEM DM(clock,MEMM[0],MEMM[1],MEMALUOut,MEMWriteData,MEMReadData);
     
    MEMWB MEMWBreg(clock,MEMWB,MEMReadData,MEMALUOut,MEMRegRd,WBWB,WBReadData,WBALUOut,WBRegRd);
    /**      * Write Back (WB)      */     
    assign datatowrite = WBWB[1] ? WBReadData : WBALUOut;
          
endmodule 