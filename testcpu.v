`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:17:02 05/23/2017
// Design Name:   cpu
// Module Name:   C:/Users/Jacky/Documents/ISE Projects/CODLab7/testcpu.v
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

module testcpu;

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
	wire PCWrite;
	wire IFIDWrite;
	wire HazMuxCon;
	wire jump;
	wire bne;
	wire imm;
	wire andi;
	wire ori;
	wire addi;
	wire [8:0] IDcontrol;
	wire [8:0] ConOut;
	wire [1:0] EXWB;
	wire [1:0] ForwardA;
	wire [1:0] ForwardB;
	wire [1:0] aluop;
	wire [2:0] EXM;
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
		.PCWrite(PCWrite), 
		.IFIDWrite(IFIDWrite), 
		.HazMuxCon(HazMuxCon), 
		.jump(jump), 
		.bne(bne), 
		.imm(imm), 
		.andi(andi), 
		.ori(ori), 
		.addi(addi), 
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
		.WBALUOut(WBALUOut)
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
    pipelined.IM.instructmem[0] = 32'h8c030000;
    pipelined.IM.instructmem[1] = 32'h8c040001;
    pipelined.IM.instructmem[2] = 32'h8c050002;
    pipelined.IM.instructmem[3] = 32'h8c010002;
    pipelined.IM.instructmem[4] = 32'h10600004;
    pipelined.IM.instructmem[5] = 32'h00852020;
    pipelined.IM.instructmem[6] = 32'h00852822;
    pipelined.IM.instructmem[7] = 32'h00611820;
    pipelined.IM.instructmem[8] = 32'h1000fffb;
    pipelined.IM.instructmem[9] = 32'hac040006;
 
    // Data Memory intialization  
    
    pipelined.DM.datamem[0] = 32'd8;
    pipelined.DM.datamem[1] = 32'd1;
    pipelined.DM.datamem[2] = -32'd1;
    pipelined.DM.datamem[3] = 0;
    
 
    // Register File initialization  
    for (i = 0; i < 32; i = i + 1)   
        pipelined.piperegs.regfile[i] = 32'd0;
  
    end   
    
    
    always#25 clock=~clock;
endmodule

