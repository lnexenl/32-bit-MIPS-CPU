
module Control(OpCode, Funct,
	PCSrc, Branch, RegWrite, RegDst, 
	MemRead, MemWrite, MemtoReg, 
	ALUSrc1, ALUSrc2, ExtOp, LuOp, ALUOp);
	input [5:0] OpCode;
	input [5:0] Funct;
	output [1:0] PCSrc;
	output Branch;
	output RegWrite;
	output [1:0] RegDst;
	output MemRead;
	output MemWrite;
	output [1:0] MemtoReg;
	output ALUSrc1;
	output ALUSrc2;
	output ExtOp;
	output LuOp;
	output [3:0] ALUOp;
	
	// Your code below
	assign PCSrc = ((OpCode == 0)&&(Funct == 6'h08 || Funct == 6'h09))?2'b10:
				  (OpCode == 6'h02 || OpCode == 6'h03)?2'b01:
				  2'b00;
	
	assign Branch = (OpCode == 6'h04)?1:0;

	assign RegWrite = (OpCode == 6'h2b || OpCode == 6'h04 || OpCode == 6'h02|| (OpCode == 0 && Funct == 6'h08))?0:1;

	assign RegDst = (OpCode == 6'h03)?2'b10:
					(OpCode == 6'b0)?2'b01:2'b00;
	
	assign MemRead = (OpCode == 6'h23)? 1: 0;

	assign MemWrite = (OpCode == 6'h2b)? 1: 0;

	assign MemtoReg = (OpCode == 6'h03 || (OpCode == 6'h00 && Funct == 6'h09))?2'b10:
					  (OpCode == 6'h23)?2'b01:2'b00;

	assign ALUSrc1 = (OpCode == 6'h00 && (Funct == 6'h00||Funct == 6'h02||Funct == 6'h03))? 1: 0;

	assign ALUSrc2 = (OpCode == 6'h00||OpCode == 6'h04)?0:1;

	assign ExtOp = (OpCode == 6'h23||OpCode == 6'h2b||OpCode == 6'h08||OpCode == 6'h09||OpCode == 6'h0c||OpCode == 6'h0a||OpCode == 6'h04)?1:0;

	assign LuOp = (OpCode == 6'h0f)?1:0;
	// Your code above
	
	assign ALUOp[2:0] = 
		(OpCode == 6'h00)? 3'b010: 
		(OpCode == 6'h04)? 3'b001: 
		(OpCode == 6'h0c)? 3'b100: 
		(OpCode == 6'h0a || OpCode == 6'h0b)? 3'b101: 
		3'b000;
		
	assign ALUOp[3] = OpCode[0];
	
	assign ALUFun = (Funct == 6'h22 || Funct == 6'h23)?6'b000001:
					(Funct == 6'h24 || OpCode == 6'h0c)?6'b011000:
					(Funct == 6'h25)?6'b011110:
					(Funct == 6'h26)?6'b010110:
					(Funct == 6'h27)?6'b010001:
					(Funct == 6'h00 && OpCode == 6'h00)?6'b100000:
					(Funct == 6'h02)?6'b100001:
					(Funct == 6'h03)?6'b100011:
					(OpCode == 6'h04)?6'b110011:
					(OpCode == 6'h05)?6'b110001:
					(OpCode == 6'h0a || OpCode == 6'h0b || Funct == 6'h2a)?6'b110101:
					(OpCode == 6'h06)?6'b111101:
					(OpCode == 6'h07)?6'b111011:
					(OpCode == 6'h01)?6'b111111:6'b000000
endmodule