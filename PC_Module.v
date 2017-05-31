module PC_Module(clk,pc_in, PCWrite, pc_out);
    input clk, PCWrite;
    input [31:0] pc_in;
    output reg [31:0] pc_out;


    initial
    begin   
        pc_out=0;
    end

    always@(posedge clk)
    begin
        if(PCWrite)
            pc_out<=pc_in;
        else
            ;//do nothing
    end
    
endmodule 