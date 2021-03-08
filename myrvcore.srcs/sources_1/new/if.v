module IF(
input clk,reset,
output[31:0] current_instruction);
reg [31:0] memory[0:1023];
reg [31:0] PC;

always@(reset,posedge clk)
begin
    if(reset) PC <= 0;
    else PC <= PC +1;
end

endmodule