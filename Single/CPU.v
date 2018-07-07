
module CPU(reset, clk, clk_Baud, led, switch, UART_TX, UART_RX);
	input reset, clk, clk_Baud, UART_RX;
	input [7:0] switch;
	output UART_TX;
	output [7:0] led;
	
	reg [31:0] PC;
	wire [31:0] PC_next;
	always @(posedge reset or posedge clk)
		if (reset)
			PC <= 32'h00000000;
		else
			PC <= PC_next;
	
	wire [31:0] PC_plus_4;
	assign PC_plus_4 = PC + 32'd4;
	
	wire [31:0] Instruction;
	InstructionMemory instruction_memory1(.Address(PC), .Instruction(Instruction));
	
	wire [2:0] PCSrc;
	wire [1:0] RegDst;
	wire MemRead;
	wire [1:0] MemtoReg;
	wire [5:0] ALUFun
	wire ExtOp;
	wire LuOp;
	wire MemWrite;
	wire ALUSrc1;
	wire ALUSrc2;
	wire RegWrite;
	wire interrupt;
	wire ker;
	wire IRQ;
	wire sign;
	wire [11:0] digi;
	
	Control control1(
		.OpCode(Instruction[31:26]), .Funct(Instruction[5:0]), .ker(ker), .IRQ(IRQ),
		.PCSrc(PCSrc), .RegWrite(RegWrite), .RegDst(RegDst), 
		.MemRead(MemRead),	.MemWrite(MemWrite), .MemtoReg(MemtoReg),
		.ALUSrc1(ALUSrc1), .ALUSrc2(ALUSrc2), .ExtOp(ExtOp), .LuOp(LuOp), .ALUFun(ALUFun), .sign(sign));
	
	wire [31:0] Databus1, Databus2, Databus3;
	wire [4:0] Write_register;
	assign Write_register = (RegDst == 2'b00)? Instruction[15:11]: 
							(RegDst == 2'b01)? Instruction[20:16]:
							(RegDst == 2'b10)? 5'd31: 5'd26;
	RegisterFile register_file1(.reset(reset), .clk(clk), .RegWrite(RegWrite), 
		.Read_register1(Instruction[25:21]), .Read_register2(Instruction[20:16]), .Write_register(Write_register),
		.Write_data(Databus3), .Read_data1(Databus1), .Read_data2(Databus2));
	
	wire [31:0] Ext_out;
	assign Ext_out = {ExtOp? {16{Instruction[15]}}: 16'h0000, Instruction[15:0]};
	
	wire [31:0] LU_out;
	assign LU_out = LuOp? {Instruction[15:0], 16'h0000}: Ext_out;

	wire [31:0] ALU_in1;
	wire [31:0] ALU_in2;
	wire [31:0] ALU_out;
	assign ALU_in1 = ALUSrc1? {27'h0000000, Instruction[10:6]}: Databus1;
	assign ALU_in2 = ALUSrc2? LU_out: Databus2;
	ALU alu1(.A(ALU_in1), .B(ALU_in2), .Sign(sign), .ALUFun(ALUFun), .z(ALU_out));
	
	wire [31:0] Read_data;
	DataMem data_mem1(
		.reset(reset), .clk(clk), .rd(MemRead & ~ALU_out[30]), .wr(MemWrite & ~ALU_out[30]),
		.addr(ALU_out), .wdata(Databus2), .rdata(Read_data));
	PeripheralDevice peride(
		.reset(reset), .clk(clk), .clk_Baud(clk_Baud), .rd(MemRead & ALU_out[30]), .wr(MemWrite & ALU_out[30]),.addr(ALU_out),
		.wdata(Databus2), .rdata(Read_data), .led(led), .switch(switch), .UART_RX(UART_RX), .UART_TX(UART_TX), .irqout(IRQ));
	assign Databus3 = (MemtoReg == 2'b00)? ALU_out: (MemtoReg == 2'b01)? Read_data: PC_plus_4;
	
	wire [31:0] Jump_target;
	assign Jump_target = {PC_plus_4[31:28], Instruction[25:0], 2'b00};
	
	wire [31:0] Branch_target;
	assign Branch_target = (ALU_out[0])? PC_plus_4 + {Ext_out[29:0], 2'b00}: PC_plus_4;
	
	assign PC_next = (PCSrc == 3'b000)? PC_plus_4:
					 (PCSrc == 3'b001)? Branch_target:
					 (PCSrc == 3'b010)? Jump_target:
					 (PCSrc == 3'b011)? Databus1
					 (PCSrc == 3'b100)? 32'h80000004
					 32'h8000008;

endmodule
	