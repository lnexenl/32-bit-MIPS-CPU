module Control(Opcode,funct,IRQ,ker,PCSrc,RegDst,RegWr,ALUSrc1,ALUSrc2,ALUFun,Sign,MemWr,MemRd,MemToReg,EXTOp,Interrupt,LUOp);
input IRQ;
input [5:0] Opcode;
input [5:0] funct;
input ker;
output [2:0] PCSrc;
output [1:0] RegDst;
output [1:0] MemToReg;
output [5:0] ALUFun;
output RegWr,ALUSrc1,ALUSrc2,Sign,MemWr,MemRd,EXTOp,LUOp,Interrupt;
wire undef;
assign Interrupt=IRQ&&(~ker);
assign undef=~(((Opcode>=6'h01&&Opcode<=6'h0c)||(Opcode==6'h0f)||(Opcode==6'h23)||(Opcode==6'h2b))||
	((Opcode==6'h0)&&((funct>=6'h20&&funct<=6'h27)||(funct==6'h00)||(funct==6'h02)||(funct==6'h03)||(funct==6'h2a)||(funct==6'h08)||(funct==6'h09))));
assign PCSrc=(Opcode==6'h00&&funct==6'h00)?3'd0:Interrupt?3'd4:((Opcode>=6'h04&&Opcode<=6'h07)||(Opcode==6'h01))?3'd1://branch
			(Opcode==6'h02||Opcode==6'h03)?3'd2://j&&jal
			(Opcode==6'h00&&(funct==6'h08||funct==6'h09))?3'd3://jr&&jalr
			undef?3'd5://exception
			3'd0;//PC+4

assign RegDst=(Interrupt|undef)?2'd3:
			  (Opcode==6'h03)?2'd2:
			  (Opcode==6'h00)?2'd0:2'd1;
assign MemToReg=((Interrupt|undef)||(Opcode==6'h03)||(Opcode==6'h00&&funct==6'h09))?2'd2:
				(Opcode==6'h23)?2'd1:2'd0;
assign EXTOp=~(Opcode==6'h0c);
assign LUOp=(Opcode==6'h0f);
assign MemRd=(~Interrupt)&(Opcode==6'h23);
assign MemWr=(~Interrupt)&(Opcode==6'h2b);
assign Sign=1'b1;
assign RegWr=Interrupt|(~((Opcode>=6'h04&&Opcode<=6'h07)||(Opcode==6'h01)||(Opcode==6'h02)||(Opcode==6'h2b)||(Opcode==6'h00&&funct==6'h08)));
assign ALUSrc1=(Opcode==6'h00)&&((funct==6'h00)||(funct==6'h02)||(funct==6'h03));
assign ALUSrc2=~(Opcode>=6'h00&&Opcode<=6'h07);
assign ALUFun=((Opcode==6'h00&&funct==6'h22)||(Opcode==6'h00&&funct==6'h23))?6'b000001:
				((Opcode==6'h00&&funct==6'h24)||(Opcode==6'h0c))?6'b011000:
				(Opcode==6'h00&&funct==6'h25)?6'b011110:
				(Opcode==6'h00&&funct==6'h26)?6'b010110:
				(Opcode==6'h00&&funct==6'h27)?6'b010001:
				(Opcode==6'h00&&funct==6'h00)?6'b100000:
				(Opcode==6'h00&&funct==6'h02)?6'b100001:
				(Opcode==6'h00&&funct==6'h03)?6'b100011:
				((Opcode==6'h00&&funct==6'h2a)||(Opcode==6'h0a)||(Opcode==6'h0b))?6'b110101:
				(Opcode==6'h04)?6'b110011:
				(Opcode==6'h05)?6'b110001:
				(Opcode==6'h06)?6'b111101:
				(Opcode==6'h07)?6'b111111:
				(Opcode==6'h01)?6'b111011:6'b000000;
endmodule

