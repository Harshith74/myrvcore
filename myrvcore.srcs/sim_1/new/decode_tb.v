`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.01.2021 10:26:06
// Design Name: 
// Module Name: decode_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module decode_tb;

reg[31:0] instruction;
wire[31:0] read_data1,read_data2;
wire Branch,MemRead,MemtoReg,MemWrite,ALUsrc,RegWrite;
wire[1:0] AluOp;

decode uut(instruction,read_data1,read_data2,Branch,MemRead,MemtoReg,MemWrite,ALUsrc,RegWrite,AluOp);

initial begin
    instruction = 32'h00002083;
    #100;
    instruction = 32'h00108133;
    #100;
//    instruction = 32'h00002083;
//    #100;
//    instruction = 32'h00002083;
//    #100;
//    instruction = 32'h00002083;
//    #100;
//    instruction = 32'h00002083;
//    #100;
    
end
endmodule
