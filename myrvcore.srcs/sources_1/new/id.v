module decode(
input[31:0] instruction,
output[31:0] read_data1,read_data2,
output reg Branch,MemtoReg,ALUsrc,RegWrite,
output reg[1:0] BranchType,
output reg[3:0] MemRead,
output reg[1:0] MemWrite,
output reg[1:0] AluOp
);


//assign opcode = instruction[6:0];
localparam  	LOAD    =   7'b0000011,
                STORE   =   7'b0100011,
                BRANCH  =   7'b1100011,
                JALR    =   7'b1100111,
                JAL     =   7'b1101111,
                OP_IMM  =   7'b0010011,
                OP      =   7'b0110011;
                
localparam 	    LUI 	=	7'b0110111,
				AUIPC 	=	7'b0010111,
//				JAL 	=	7'b1101111,
//				JALB	=	10'b0001100111,
				fun3_BEQ    =	3'b000,
				fun3_BNE 	=	3'b001,
				fun3_BLT 	=	3'b100,
				fun3_BGE 	=	3'b101,
				fun3_BLTU 	=	3'b110,
				fun3_BGEU 	=	3'b111,
				fun3_LB     =	3'b000,
				fun3_LH 	=	3'b001,
				fun3_LW 	=	3'b010,
				fun3_LBU 	=	3'b100,
				fun3_LHU 	=	3'b101,
				fun3_SB 	=	3'b000,
				fun3_SH 	=	3'b001,
				fun3_SW 	=	3'b010,
				fun3_ADDI 	=	3'b000,
				fun3_SLTI 	=	3'b010,
				fun3_SLTIU 	=	3'b011,
				fun3_XORI	=	3'b100,
				fun3_ORI	=	3'b110,
				fun3_ANDI	=	3'b111,
				fun3_SLLI 	=	3'b001,
				fun3_SRLI 	=	3'b010,
				fun3_SRAI 	=	3'b101,
				fun3_ADD 	=	3'b000,
				fun3_SUB 	=	3'b000,
				fun3_SLL 	=	3'b001,
				fun3_SLT 	=	3'b010,
				fun3_SLTU 	=	3'b011,
				fun3_XOR 	=	3'b100,
				fun3_SRL 	=	3'b101,
				fun3_SRA 	=	3'b101,
				fun3_OR 	=	3'b110,
				fun3_AND 	=	3'b111,
				fun7_SLLI 	=	0,
				fun7_SRLI 	=   0,
				fun7_SRAI 	=	1,
				fun7_ADD 	=	0,
				fun7_SUB 	=	1,
				fun7_SLL 	=	0,
				fun7_SLT 	=	0,
				fun7_SLTU 	=	0,
				fun7_XOR 	=	0,
				fun7_SRL 	=	0,
				fun7_SRA 	=	1,
				fun7_OR 	=	0,
				fun7_AND 	=	0;
				
wire[11:0] Op_bits;
wire[6:0] opcode;
wire[4:0] rs1,rs2,rd;
wire[11:0] imm12;
wire[19:0] imm20;
//reg[1:0] ALUop;
//reg AlUSrc,Branch,MemRead,MemWrite;
reg[10:0] control_signals;

//assign ALUop = control_signals[1:0];

//always@(*)
//begin
//            AluOp <=  control_signals[1:0];
//            ALUsrc<= control_signals[10];
//            MemtoReg <= control_signals[9];
//            RegWrite <= control_signals[8];
//            MemRead<=control_signals[4:7];
//            MemWrite<=control_signals[3];
//            Branch <= control_signals[2]; 
//end

assign Op_bits = {instruction[30],instruction[14:12],instruction[6:0]};
assign rs1 = instruction[19:15];
assign rs2 = instruction[24:20];
assign rd = instruction[11:7];
assign imm12 = instruction[31:20];
assign imm20 = instruction[31:12];
assign opcode = instruction[6:0];
//regfile access
reg[31:0] RegFile[0:31];
integer i;
initial begin
    for(i = 0; i < 32; i = i+1)
        RegFile[i] = i;
end
assign read_data1 = RegFile[rs1];
assign read_data2 = RegFile[rs2];

always@(*)
begin
    case(opcode)
    LOAD    :
    begin
            AluOp <=  2'b000;
            ALUsrc<= 1; //immediate in instruction
            MemtoReg <= 1;  //output of memory
            RegWrite <= 1;  //write into rd
            MemWrite<=2'b00; //no write
            Branch <= 0; //no branch
            case(instruction[14:12])
               
                fun3_LB     :   /*wstrb = 1000*/
                begin
                    MemRead<=4'b0010;// fetch 4bytes
                end
                fun3_LH 	:   /*wstrb = 1100*/
                begin                   
                    MemRead<=4'b0100;// fetch 4bytes                    
                end
                fun3_LW 	:  
                begin
                    MemRead<=4'b1000;// fetch 4bytes                    
                end
                fun3_LBU 	:   /*wstrb = 1000*/
                begin
                    MemRead<=4'b0011;// fetch 4bytes
                end
                fun3_LHU 	:   /*wstrb = 1100*/
                begin
                    MemRead<=4'b0101;// fetch 4bytes
                end
            endcase
                        
    end          
    STORE   :
    begin
            AluOp <=  2'b000;
            ALUsrc<= 1; //immediate in instruction
            MemtoReg <= 1;  //output of memory
            RegWrite <= 1;  //write into rd
            MemRead<=4'b0000; //no write
            Branch <= 0; //no branch
            case(instruction[14:12])
                fun3_SB 	: MemWrite<=2'b01;//
				fun3_SH 	: MemWrite<=2'b10;
				fun3_SW 	:  MemWrite<=2'b11 ;
            endcase
            AluOp <= 2'b00;
    end          
    BRANCH  :
    begin
            AluOp[1:0] <=  2'b01;    //sub
            ALUsrc<= 0;
            RegWrite <= 0;
            MemRead<= 4'b0000;  //could be dont care
            MemWrite<= 2'b00;
            Branch <= 1;             
            case(instruction[14:12])
                fun3_BEQ    : 
                begin
                    AluOp[2] <= 0;
                    BranchType <= 2'b00; 
                end
				fun3_BNE 	:
				begin
                    AluOp[2] <= 0;
                    BranchType <= 2'b01; 
                end
				fun3_BLT 	:
				begin
                    AluOp[2] <= 0;
                    BranchType <= 2'b10; 
                end
				fun3_BGE 	:
				begin
                    AluOp[2] <= 0;
                    BranchType <= 2'b11; 
                end
				fun3_BLTU 	:
				begin
                    AluOp[2] <= 1;
                    BranchType <= 2'b10; 
                end
				fun3_BGEU 	:
				begin
                    AluOp[2] <= 1;
                    BranchType <= 2'b11; 
                end
            endcase    
    end          
    JALR    :       ;
    JAL     :       ;
    OP_IMM  :
    begin
            case(instruction[14:12])
                fun3_ADDI 	: ;
				fun3_SLTI 	: ;
				fun3_SLTIU 	: ;
				fun3_XORI	: ;
				fun3_ORI	: ;
				fun3_ANDI	: ;
				fun3_SLLI 	: ;
				fun3_SRLI 	: 
				begin
				    if(fun7_SRLI) ; //srli
				    else ;  //srai
				end
				fun3_SRAI 	: ;
            endcase
    end
    OP      ://also R format
    begin
            case(instruction[14:12])
                fun3_ADD 	: ;
				fun3_SUB 	: ;
				fun3_SLL 	: ;
				fun3_SLT 	: ;
				fun3_SLTU 	: ;
				fun3_XOR 	: ;
				fun3_SRL 	: ;
				fun3_SRA 	: ;
				fun3_OR 	: ;
				fun3_AND 	: ;
            endcase
            control_signals <= 8'b00100010;
             
    end
    default: control_signals <= 8'b11111111;
    endcase
end
//always@(*)
//begin
//    if(instruction[6:0] == LUI);
//    elseif(instruction[6:0] == AUIPC);
//    elseif(instruction[6:0] == JAL);
    
//end

//always@(*)
//begin
    
        
//    case(instruction[6:0])
//                LUI 	:        ;
//				AUIPC 	:        ;
//				JAL 	:        ;
//				default :        ;
//    endcase


//    case({instruction[14:12],instruction[6:0]})
//                JALB	:;
//				BEQ		:;
//				BNE 	:;
//				BLT 	:;
//				BGE 	:;
//				BLTU 	:;
//				BGEU 	:;
//				LB 		:;
//				LH 		:;
//				LW 		:;
//				LBU 	:;
//				LHU 	:;
//				SB 		:;
//				SH 		:;
//				SW 		:;
//				ADDI 	:;
//				SLTI 	:;
//				SLTIU 	:;
//				XORI	:;
//				ORI		:;
//				ANDI	:;
//				default : ;
//    endcase
    
//    case(Op_bits)
//                    SLLI 	:     ;
//                    SRLI 	:     ;
//                    SRAI 	:     ;
//                    ADD 	:     ;
//                    SUB 	:     ;
//                    SLL 	:     ;
//                    SLT 	:     ;
//                    SLTU 	:     ;
//                    XOR 	:     ;
//                    SRL 	:     ;
//                    SRA 	:      ;
//                    OR 		:      ;
//                    AND 	:      ;
//                    default : begin
                        
//                    end
//    endcase

    
    
//end
//always@(*)
//begin
    
//end
//decode(instruction)
endmodule