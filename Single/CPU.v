module CPU(reset, sysclk, led, UART_TX, UART_RX, BCD, DK);
	input reset, sysclk, UART_RX;
	output wire UART_TX;
	output wire[7:0]led;
	output wire [6:0]BCD;
	output wire [3:0]DK;	
	reg [31:0] PC;
	wire [31:0] PC_next;
	wire sysclk_bd, sysclk, sysclk_sam, clk, reset, UART_RX;
	UART_BR br(.sysclk(sysclk), .sysclk_bd(sysclk_bd), .sysclk_sam(sysclk_sam), .sysclk_25M(clk), .reset(reset));
	
	always @(posedge reset or posedge clk)
		if (reset)
			PC <= 32'h00000000;
		else
			PC <= PC_next;
	
	wire [31:0] PC_plus_4;
	assign PC_plus_4 = PC + 32'd4;
	
	wire [31:0] Instruction;
	ROM rom1(.addr({1'b0,PC[30:0]}), .data(Instruction));
	
	wire [2:0] PCSrc;
	wire [1:0] RegDst;
	wire MemRead;
	wire [1:0] MemtoReg;
	wire [5:0] ALUFun;
	wire ExtOp;
	wire LuOp;
	wire MemWrite;
	wire ALUSrc1;
	wire ALUSrc2;
	wire RegWrite;
	wire interrupt;
	wire IRQ;
	wire sign;
	Control control1(
		.OpCode(Instruction[31:26]), .Funct(Instruction[5:0]), .ker(PC[31]), .IRQ(IRQ),
		.PCSrc(PCSrc), .RegWrite(RegWrite), .RegDst(RegDst), 
		.MemRead(MemRead),	.MemWrite(MemWrite), .MemtoReg(MemtoReg),
		.ALUSrc1(ALUSrc1), .ALUSrc2(ALUSrc2), .ExtOp(ExtOp), .LuOp(LuOp), .ALUFun(ALUFun), .sign(sign), .Interrupt(interrupt));
	
	wire [31:0] Databus1, Databus2, Databus3;
	wire [4:0] Write_register;
	assign Write_register = (RegDst == 2'b00)? Instruction[15:11]: 
							(RegDst == 2'b01)? Instruction[20:16]:
							(RegDst == 2'b10)? 5'd31: 5'd26;
	RegFile register_file1(.reset(reset), .clk(clk), .addr1(Instruction[25:21]),
		.data1(Databus1), .addr2(Instruction[20:16]), .data2(Databus2),
		.wr(RegWrite), .addr3(Write_register), .data3(Databus3));
	
	wire [31:0] Ext_out;
	assign Ext_out = {ExtOp? {16{Instruction[15]}}: 16'h0000, Instruction[15:0]};
	
	wire [31:0] LU_out;
	assign LU_out = LuOp? {Instruction[15:0], 16'h0000}: Ext_out;

	wire [31:0] ALU_in1;
	wire [31:0] ALU_in2;
	wire [31:0] ALU_out;
	assign ALU_in1 = ALUSrc1? {27'h0000000, Instruction[10:6]}: Databus1;
	assign ALU_in2 = ALUSrc2? LU_out: Databus2;
	ALU alu1(.in1(ALU_in1), .in2(ALU_in2), .out(ALU_out), .sign(sign), .funct(ALUFun));
	
	wire [31:0] Read_data, rdata1, rdata2;
	DataMem data_mem1(
		.reset(reset), .clk(clk), .rd(MemRead & ~ALU_out[30]), .wr(MemWrite & ~ALU_out[30]),
		.addr(ALU_out), .wdata(Databus2), .rdata(rdata1));
	wire [11:0] digi;
	PeripheralDevice peride(
		.reset(reset), .clk(clk), .sysclk(sysclk), .sysclk_bd(sysclk_bd), .sysclk_sam(sysclk_sam), .rd(MemRead & ALU_out[30]), .wr(MemWrite & ALU_out[30]),.addr(ALU_out),
		.wdata(Databus2), .rdata(rdata2), .led(led), .switch(switch), .UART_RX(UART_RX), .UART_TX(UART_TX), .irqout(IRQ), .BCD(BCD), .DK(DK), .digi(digi));
	assign Read_data = ALU_out[30]? rdata2: rdata1;
		
	assign Databus3 = (MemtoReg == 2'b00)? ALU_out: (MemtoReg == 2'b01)? Read_data: interrupt?PC: PC_plus_4;
	
	wire [31:0] Jump_target;
	assign Jump_target = {PC_plus_4[31:28], Instruction[25:0], 2'b00};
	
	wire [31:0] Branch_target;
	assign Branch_target = (ALU_out[0])? PC_plus_4 + {Ext_out[29:0], 2'b00}: PC_plus_4;
	
	assign PC_next = (PCSrc == 3'b000)? PC_plus_4:
					 (PCSrc == 3'b001)? Branch_target:
					 (PCSrc == 3'b010)? Jump_target:
					 (PCSrc == 3'b011)? Databus1:
					 (PCSrc == 3'b100)? 32'h80000004:
					 32'h80000008;

endmodule
	