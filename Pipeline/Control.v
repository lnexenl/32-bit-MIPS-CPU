module Control(Opcode,Funct,IRQ,ker,PCSrc,RegDst,RegWr,ALUSrc1,ALUSrc2,ALUFun,Sign,MemWr,MemRd,MemToReg,EXTOp,Interrupt,LUOp);
input [5:0] Opcode;
input [5:0] Funct;
input IRQ;
input ker;
output [2:0] PCSrc;
output [1:0] RegDst;
output [1:0] MemToReg;
output [5:0]ALUFun;
output RegWr,ALUSrc1,ALUSrc2,Sign,MemWr,MemRd,EXTOp,LUOp,Interrupt;
wire Undefined;
assign Interrupt = IRQ&&(~ker);//
assign Undefined = ~((Opcode>2'h00&&Opcode<2'h0d)||Opcode==2'h0f||Opcode==2'h23||Opcode==2'h2b)||(Opcode==2'h00&&((Funct>=2'h20&&Funct<=2'h27)||Funct==2'h02||Funct==2'h03||Funct==2'h09||Funct==2'h2a));
assign PCSrc =  (Opcode==6'h00&&Funct==6'h00)?3'b000:
                ((Opcode>=6'h04&&Opcode<=6'h07)||(Opcode==6'h01))?3'b001://分支
			    (Opcode==6'h02||Opcode==6'h03)?3'b010://跳转
			    (Opcode==6'h00&&(Funct==6'h08||Funct==6'h09))?3'b011://跳转
                Interrupt?3'b100:
			    Undefined?3'b101://异常
			    3'b000;//PC+4
assign RegDst = (Interrupt||Undefined)?2'b11:
			    (Opcode==6'h03)?2'b10:
			    (Opcode==6'h00)?2'b00:
                2'b01;
assign RegWr = Interrupt|~(((Opcode>=6'h04&&Opcode<=6'h07)||(Opcode==6'h01)||(Opcode==6'h02)||(Opcode==6'h2b)||(Opcode==6'h00&&funct==6'h08)));
assign ALUSrc1 = (Opcode==6'h00)&&((Funct==6'h00)||(Funct==6'h02)||(Funct==6'h03));
assign ALUSrc2 = ~(Opcode>=6'h00&&Opcode<=6'h07);
assign ALUFun = ((Opcode==6'h00&&Funct==6'h22)||(Opcode==6'h00&&Funct==6'h23))?6'b000001:
				((Opcode==6'h00&&Funct==6'h24)||(Opcode==6'h0c))?6'b011000:
				(Opcode==6'h00&&Funct==6'h25)?6'b011110:////////
				(Opcode==6'h00&&Funct==6'h26)?6'b010110:
				(Opcode==6'h00&&Funct==6'h27)?6'b010001:
				(Opcode==6'h00&&Funct==6'h00)?6'b100000:
				(Opcode==6'h00&&Funct==6'h02)?6'b100001:
				(Opcode==6'h00&&Funct==6'h03)?6'b100011:
				((Opcode==6'h00&&Funct==6'h2a)||(Opcode==6'h0a)||(Opcode==6'h0b))?6'b110101:
				(Opcode==6'h01)?6'b111011:				
				(Opcode==6'h04)?6'b110011:
				(Opcode==6'h05)?6'b110001:
				(Opcode==6'h06)?6'b111101:
				(Opcode==6'h07)?6'b111111:
				(OpCode==6'h0f)?6'b011010:
                6'b000000;
assign Sign = (OpCode == 6'h0b)?1'b0:1'b1; //think slti
assign MemWr = (~Interrupt)&(Opcode==6'h2b);
assign MemRd = (~Interrupt)&(Opcode==6'h23);
assign EXTOp = (OpCode == 6'h23||OpCode == 6'h2b||OpCode == 6'h08||OpCode == 6'h0a||(OpCode >= 6'h04 && OpCode <= 6'h07)||OpCode == 6'h01)?1:0;
assign LUOp = (OpCode == 6'h0f)?1:0;
endmodule