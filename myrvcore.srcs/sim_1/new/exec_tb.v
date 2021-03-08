`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.01.2021 10:55:16
// Design Name: 
// Module Name: exec_tb
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


module exec_tb;

wire [3:0] alu_operation;
reg [1:0] alu_op;
reg [3:0] minor_op;
reg[3:0] alu_operation;
reg [31:0] rsrc1,rsrc2;
wire[31:0] alu_op;
wire zero;


alu_control uut2(alu_operation, alu_op, minor_op);
alu uut1(rsrc1,rsrc2,alu_operation,alu_op,zero);
initial begin
    
end
endmodule
