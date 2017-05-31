module DATAMEM(clock,MemWrite,MemRead,Addr_t,Wdata,Rdata);
    input clock;
    input [31:0] Addr_t,Wdata;
    input MemWrite,MemRead;
    output [31:0] Rdata;
    reg [31:0] Rdata, Addr, Addr_map;
    reg [31:0] datamem[511:0];//32 32-bit registers     
    
    always@(*)
    begin
        Addr = (Addr_t -32'h2000);
        Addr_map=Addr[31:2];
    end
    always@(posedge clock)     
        if(MemWrite)     
        begin       
            datamem[Addr_map]<=Wdata;
            //memory write     
        end  
    
    always@(Addr,Wdata,MemWrite,MemRead)     
        if(MemRead)       
            Rdata <= datamem[Addr_map];//memory read  
    
endmodule 