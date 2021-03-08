`timescale 1ns / 1ps

module alu_control(alu_operation, alu_op, minor_op);
 output reg[3:0] alu_operation;
 input [1:0] alu_op;
 input [3:0] minor_op;
 wire [4:0] alu_ctrl_in;
 assign alu_ctrl_in = {alu_op,minor_op};
 always @(alu_ctrl_in)
     casex (alu_ctrl_in)
       6'b00xxxx: alu_operation=4'b0010;
       6'bx1xxxx: alu_operation=4'b0110;
       6'b1x0000: alu_operation=4'b0010;
       6'b1x1000: alu_operation=4'b0110;
       6'b1x0111: alu_operation=4'b0000;
       6'b1x0110: alu_operation=4'b0001;
    //   6'b000010: alu_operation=4'b000;
    //   6'b000011: alu_operation=3'b001;
    //   6'b000100: alu_operation=3'b010;
    //   6'b000101: alu_operation=3'b011;
    //   6'b000110: alu_operation=3'b100;
    //   6'b000111: alu_operation=3'b101;
    //   6'b001000: alu_operation=3'b110;
    //   6'b001001: alu_operation=3'b111;
      default: alu_operation=3'b0010;
     endcase
endmodule

module alu(rsrc1,rsrc2,alu_operation,alu_out,zero);
input[3:0] alu_operation;
input [31:0] rsrc1,rsrc2;
output reg[31:0] alu_out;
output reg zero;
always@(*)
begin
    case(alu_operation)
        4'b0000: alu_out <= rsrc1 & rsrc2;
        4'b0001: alu_out <= rsrc1 | rsrc2;
        4'b0010: alu_out <= rsrc1 + rsrc2;
        4'b0110: alu_out <= rsrc1 - rsrc2;
//        4'b0110: alu_out <= rsrc1 - rsrc2;
//        default: alu_op <= rsrc1 + rsrc2;       
    endcase
    if(alu_out == 0) zero <= 1;
    else zero <= 0; 
end
    
endmodule