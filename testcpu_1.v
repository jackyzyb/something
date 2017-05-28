`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:05:58 05/26/2017
// Design Name:   cpu
// Module Name:   C:/Users/Jacky/Documents/ISE Projects/CODLab7/testcpu_1.v
// Project Name:  CODLab7
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: cpu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testcpu_1;

	// Inputs
	reg clock;

	// Outputs
	wire [31:0] cycle;
	wire [31:0] nextpc;
	wire [31:0] IFpc_plus_4;
	wire [31:0] IFinst;
	wire [31:0] pc;
	wire PCSrc;
	wire [4:0] IDRegRs;
	wire [4:0] IDRegRt;
	wire [4:0] IDRegRd;
	wire [31:0] IDpc_plus_4;
	wire [31:0] IDinst;
	wire [31:0] IDRegAout;
	wire [31:0] IDRegBout;
	wire [31:0] IDimm_value;
	wire [31:0] BranchAddr;
	wire [31:0] PCMuxOut;
	wire [31:0] JumpTarget;
	wire [31:0] J_Target;
	wire [31:0] Jr_Target;
	wire PCWrite;
	wire IFIDWrite;
	wire HazMuxCon;
	wire jump;
	wire bne;
	wire imm;
	wire andi;
	wire ori;
	wire addi;
	wire bgtz;
	wire j;
	wire jr;
	wire ALUoverflow;
	wire [8:0] IDcontrol;
	wire [8:0] ConOut;
	wire [1:0] EXWB, EXWB2MEM;
	wire [1:0] ForwardA;
	wire [1:0] ForwardB;
	wire [1:0] aluop;
	wire [2:0] EXM, EXM2MEM;
	wire [3:0] EXEX;
	wire [3:0] ALUCon;
	wire [4:0] EXRegRs;
	wire [4:0] EXRegRt;
	wire [4:0] EXRegRd;
	wire [4:0] regtopass;
	wire [31:0] EXRegAout;
	wire [31:0] EXRegBout;
	wire [31:0] EXimm_value;
	wire [31:0] b_value;
	wire [31:0] EXALUOut;
	wire [31:0] ALUSrcA;
	wire [31:0] ALUSrcB;
	wire [1:0] MEMWB;
	wire [2:0] MEMM;
	wire [4:0] MEMRegRd;
	wire [31:0] MEMALUOut;
	wire [31:0] MEMWriteData;
	wire [31:0] MEMReadData;
	wire [1:0] WBWB;
	wire [4:0] WBRegRd;
	wire [31:0] datatowrite;
	wire [31:0] WBReadData;
	wire [31:0] WBALUOut;
    wire IFFlush, IDFlush, EXFlush;
    wire [1:0] ForwardBranchA,ForwardBranchB;
    wire [31:0] cmpA,cmpB;
    wire    addiE,oriE,andiE,immE;
    
    integer i;

	// Instantiate the Unit Under Test (UUT)
	cpu pipelined (
		.clock(clock), 
		.cycle(cycle), 
		.nextpc(nextpc), 
		.IFpc_plus_4(IFpc_plus_4), 
		.IFinst(IFinst), 
		.pc(pc), 
		.PCSrc(PCSrc), 
		.IDRegRs(IDRegRs), 
		.IDRegRt(IDRegRt), 
		.IDRegRd(IDRegRd), 
		.IDpc_plus_4(IDpc_plus_4), 
		.IDinst(IDinst), 
		.IDRegAout(IDRegAout), 
		.IDRegBout(IDRegBout), 
		.IDimm_value(IDimm_value), 
		.BranchAddr(BranchAddr), 
		.PCMuxOut(PCMuxOut), 
		.JumpTarget(JumpTarget), 
		.J_Target(J_Target), 
		.Jr_Target(Jr_Target), 
		.PCWrite(PCWrite), 
		.IFIDWrite(IFIDWrite), 
		.HazMuxCon(HazMuxCon), 
		.jump(jump), 
		.bne(bne), 
		.imm(imm), 
		.andi(andi), 
		.ori(ori), 
		.addi(addi), 
		.bgtz(bgtz), 
		.j(j), 
		.jr(jr), 
		.ALUoverflow(ALUoverflow), 
		.IDcontrol(IDcontrol), 
		.ConOut(ConOut), 
		.EXWB(EXWB), 
		.ForwardA(ForwardA), 
		.ForwardB(ForwardB), 
		.aluop(aluop), 
		.EXM(EXM), 
		.EXEX(EXEX), 
		.ALUCon(ALUCon), 
		.EXRegRs(EXRegRs), 
		.EXRegRt(EXRegRt), 
		.EXRegRd(EXRegRd), 
		.regtopass(regtopass), 
		.EXRegAout(EXRegAout), 
		.EXRegBout(EXRegBout), 
		.EXimm_value(EXimm_value), 
		.b_value(b_value), 
		.EXALUOut(EXALUOut), 
		.ALUSrcA(ALUSrcA), 
		.ALUSrcB(ALUSrcB), 
		.MEMWB(MEMWB), 
		.MEMM(MEMM), 
		.MEMRegRd(MEMRegRd), 
		.MEMALUOut(MEMALUOut), 
		.MEMWriteData(MEMWriteData), 
		.MEMReadData(MEMReadData), 
		.WBWB(WBWB), 
		.WBRegRd(WBRegRd), 
		.datatowrite(datatowrite), 
		.WBReadData(WBReadData), 
		.WBALUOut(WBALUOut),
        .IFFlush(IFFlush),
        .IDFlush(IDFlush),
        .EXFlush(EXFlush),
        .EXWB2MEM(EXWB2MEM),
        .EXM2MEM(EXM2MEM),
        .ForwardBranchA(ForwardBranchA),
        .ForwardBranchB(ForwardBranchB),
        .cmpA(cmpA),
        .cmpB(cmpB),
        .addiE(addiE),
        .oriE(oriE),
        .andiE(andiE),
        .immE(immE)
	);

	initial begin
		// Initialize Inputs
		clock = 1;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
    
    initial 
    begin         
    
    // Instr Memory intialization  
 
    
    pipelined.IM.instructmem[0] = 32'h20082000;
pipelined.IM.instructmem[1] = 32'h01294826;
pipelined.IM.instructmem[2] = 32'h014a5026;
pipelined.IM.instructmem[3] = 32'h016b5826;
pipelined.IM.instructmem[4] = 32'h018c6026;
pipelined.IM.instructmem[5] = 32'h21290001;
pipelined.IM.instructmem[6] = 32'h214a0002;
pipelined.IM.instructmem[7] = 32'h216bffff;
pipelined.IM.instructmem[8] = 32'h8d0c0000;
pipelined.IM.instructmem[9] = 32'h21080004;
pipelined.IM.instructmem[10] = 32'h012b6820;
pipelined.IM.instructmem[11] = 32'had0d0000;
pipelined.IM.instructmem[12] = 32'h21080004;
pipelined.IM.instructmem[13] = 32'h012a6820;
pipelined.IM.instructmem[14] = 32'had0d0000;
pipelined.IM.instructmem[15] = 32'h21080004;
pipelined.IM.instructmem[16] = 32'h012b6822;
pipelined.IM.instructmem[17] = 32'had0d0000;
pipelined.IM.instructmem[18] = 32'h21080004;
pipelined.IM.instructmem[19] = 32'h01496823;
pipelined.IM.instructmem[20] = 32'had0d0000;
pipelined.IM.instructmem[21] = 32'h21080004;
pipelined.IM.instructmem[22] = 32'h012b6824;
pipelined.IM.instructmem[23] = 32'had0d0000;
pipelined.IM.instructmem[24] = 32'h21080004;
pipelined.IM.instructmem[25] = 32'h316d0010;
pipelined.IM.instructmem[26] = 32'had0d0000;
pipelined.IM.instructmem[27] = 32'h21080004;
pipelined.IM.instructmem[28] = 32'h012a6825;
pipelined.IM.instructmem[29] = 32'had0d0000;
pipelined.IM.instructmem[30] = 32'h21080004;
pipelined.IM.instructmem[31] = 32'h01696827;
pipelined.IM.instructmem[32] = 32'had0d0000;
pipelined.IM.instructmem[33] = 32'h21080004;
pipelined.IM.instructmem[34] = 32'h01696826;
pipelined.IM.instructmem[35] = 32'had0d0000;
pipelined.IM.instructmem[36] = 32'h21080004;
pipelined.IM.instructmem[37] = 32'h21ad0001;
pipelined.IM.instructmem[38] = 32'h1da00001;
pipelined.IM.instructmem[39] = 32'h08000025;
pipelined.IM.instructmem[40] = 32'had0d0000;
pipelined.IM.instructmem[41] = 32'h21080004;
pipelined.IM.instructmem[42] = 32'h15a90001;
pipelined.IM.instructmem[43] = 32'h01ad6826;
pipelined.IM.instructmem[44] = 32'had0d0000;
pipelined.IM.instructmem[45] = 32'h21080004;
pipelined.IM.instructmem[46] = 32'h200e00c8;
pipelined.IM.instructmem[47] = 32'h01ad6826;
pipelined.IM.instructmem[48] = 32'h01c00008;
pipelined.IM.instructmem[49] = 32'h21ad0010;
pipelined.IM.instructmem[50] = 32'h21ad0008;
pipelined.IM.instructmem[51] = 32'had0d0000;
pipelined.IM.instructmem[52] = 32'h21080004;
pipelined.IM.instructmem[53] = 32'h200e2000;
pipelined.IM.instructmem[54] = 32'h8dc90000;
pipelined.IM.instructmem[55] = 32'h014b4820;
pipelined.IM.instructmem[56] = 32'h01295820;
pipelined.IM.instructmem[57] = 32'had0b0000;

 
    // Data Memory intialization  
    
    pipelined.DM.datamem[0] = 32'd0;
    pipelined.DM.datamem[1] = 32'd0;
    pipelined.DM.datamem[2] = 32'd0;
    pipelined.DM.datamem[3] = 0;
    pipelined.DM.datamem[4] = 0;
    pipelined.DM.datamem[5] = 0;
    pipelined.DM.datamem[6] = 0;
    pipelined.DM.datamem[7] = 0;
    pipelined.DM.datamem[8] = 0;
    pipelined.DM.datamem[9] = 0;
    
    
    // Register File initialization  
    for (i = 0; i < 32; i = i + 1)   
        pipelined.piperegs.regfile[i] = 32'd0;
  
    end   
    
    
    always#25 clock=~clock;
      
endmodule

