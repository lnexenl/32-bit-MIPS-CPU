module Control(OpCode, Funct, ker, IRQ,
	PCSrc, RegWrite, RegDst, 
	MemRead, MemWrite, MemtoReg, 
	ALUSrc1, ALUSrc2, ExtOp, LuOp, ALUFun, sign);
	input wire[5:0] OpCode;
	input wire[5:0] Funct;
	input wire ker;
	input wire IRQ;
	output wire [2:0] PCSrc;
	output wire RegWrite;
	output wire [1:0] RegDst;
	output wire MemRead;
	output wire MemWrite;
	output wire [1:0] MemtoReg;
	output wire ALUSrc1;
	output wire ALUSrc2;
	output wire ExtOp;
	output wire LuOp;
	output wire [5:0] ALUFun;
	output wire sign;
	wire Exception;
	wire Interrupt;
	assign Exception = ~((OpCode == 6'h0 &&(Funct == 6'h0 || (Funct >= 6'h20 && Funct <= 6'h27) || Funct == 6'h02 || Funct == 6'h03 || Funct == 6'h2a || Funct == 6'h08 || Funct == 6'h09)) || (OpCode >= 6'h01 && OpCode <= 6'h0c) || OpCode == 6'h0f || OpCode == 6'h23 || OpCode == 6'h2b);
	assign Interrupt = IRQ&&(~ker);
	assign PCSrc = (OpCode == 6'h01 || (OpCode >= 6'h04 && OpCode <= 6'h07))?3'd1:
				   (OpCode >= 6'h02 && OpCode <= 6'h03)?3'd2:
				   (OpCode == 6'h00 && (Funct >= 6'h08 && Funct <= 6'h09))?3'd3:
				   Interrupt?3'd4:3'd0;
	
	assign RegWrite = (~Interrupt && ((OpCode == 6'h2b || (OpCode >= 6'h04 && OpCode <= 6'h07) || OpCode == 6'h02 || OpCode == 6'h01 || (OpCode == 0 && Funct == 6'h08))))?0:1;

	assign RegDst = (Interrupt || Exception)?2'd3:
					(OpCode == 6'h03)?2'd2:
					(OpCode == 6'h00)?2'd0:2'd1;
	
	assign MemRead = (~Interrupt) || (OpCode == 6'h23);

	assign MemWrite = (~Interrupt) || (OpCode == 6'h2b);

	assign MemtoReg = (OpCode == 6'h03 || (OpCode == 6'h00 && Funct == 6'h09) || (Interrupt || Exception))?2'd2:
					  (OpCode == 6'h23)?2'd1:2'd0;

	assign ALUSrc1 = (OpCode == 6'h00 && (Funct == 6'h00||Funct == 6'h02||Funct == 6'h03));

	assign ALUSrc2 = ~(OpCode >= 6'h00 && OpCode <= 6'h07);

	assign ExtOp = (OpCode == 6'h23||OpCode == 6'h2b||OpCode == 6'h08||OpCode == 6'h0a||(OpCode >= 6'h04 && OpCode <= 6'h07)||OpCode == 6'h01)?1:0;

	assign LuOp = (OpCode == 6'h0f)?1:0;
	
	assign ALUFun = (OpCode == 6'h00 && (Funct == 6'h22 || Funct == 6'h23))?6'b000001:
					((OpCode == 6'h00 && Funct == 6'h24) || OpCode == 6'h0c)?6'b011000:
					(OpCode == 6'h00 && Funct == 6'h25)?6'b011110:
					(OpCode == 6'h00 && Funct == 6'h26)?6'b010110:
					(OpCode == 6'h00 && Funct == 6'h27)?6'b010001:
					(OpCode == 6'h0f)?6'b011010:
					(Funct == 6'h00 && OpCode == 6'h00)?6'b100000:
					(OpCode == 6'h00 && Funct == 6'h02)?6'b100001:
					(OpCode == 6'h00 && Funct == 6'h03)?6'b100011:
					(OpCode == 6'h04)?6'b110011:
					(OpCode == 6'h05)?6'b110001:
					(OpCode == 6'h0a || OpCode == 6'h0b || Funct == 6'h2a)?6'b110101:
					(OpCode == 6'h06)?6'b111101:
					(OpCode == 6'h07)?6'b111011:
					(OpCode == 6'h01)?6'b111111:6'b000000;
	
	assign sign = (OpCode == 6'h0b)?0:1;
endmodule