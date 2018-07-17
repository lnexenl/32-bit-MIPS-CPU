module CPU(reset, sysclk, led, UART_TX, UART_RX);
input reset, sysclk, UART_RX;
output [7:0] led;
output UART_TX;
wire clk, sysclk_bd, sysclk_sam;
reg [31:0] PC;
wire [31:0] PC_plus_4;
wire [31:0] PC_next;
wire [31:0] instruction;
reg [31:0] IFID_PC;
reg [31:0] IFID_Instruction;
wire IRQ, PCSrc, RegWrite, RegDst, MemRead, MemWrite, MemtoReg, ALUSrc1, ALUSrc2, ExtOp, LuOp, ALUFun, sign;
wire [31:0] Databus1;
wire [31:0] Databus2;
wire [31:0] Ext_out;
wire [31:0] LU_out;
reg [31:0] IDEX_PC;
reg [31:0] IDEX_PC_4;
reg [31:0] IDEX_Databus1;
reg [31:0] IDEX_Databus2;
reg [31:0] IDEX_LUout;
reg [4:0] IDEX_Rs;
reg [4:0] IDEX_Rt;
reg [4:0] IDEX_Shamt;
reg IDEX_EXtOp, IDEX_ALUSrc1, IDEX_ALUSrc2,, IDEX_ALUFun, IDEX_sign, IDEX_LuOp, IDEX_Memwrite, IDEX_Memtoregm IDEX_RegWrite;
wire [31:0] ALU_in1,;
wire [31:0] ALU_in2;
wire [31:0] ALU_out;
reg [31:0] EXME_PC_4;
reg [31:0] EXME_ALUout;
reg [31:0] EXME_Databus2;
reg EXME_MemRead, EXME_MemWrite, EXME_Memtoreg;
reg EXME_RegWrite;
wire [31:0] rdata1;
wire [31:0] rdata2;
wire [31:0] Read_data;
wire [31:0] Databus3;
reg MEWB_RegWrite;
reg [31:0] MEWB_Databus3;

UART_BR ubr(.sysclk(sysclk), .sysclk_bd(sysclk_bd), .sysclk_sam(sysclk_sam), .sysclk_25M(clk));

assign PC_plus_4 = PC + 32'd4;
assign PC_next = ()?32'h80000004: ()?32'h80000008: ()? : PC_plus_4;
always @(posedge clk or posedge reset)
	if (reset)
		PC <= 32'h80000000;
	else 
		PC <= PC_next;

ROM rom(.addr({1'b0,PC[30:0]}), .data(Instruction));

always @(posedge clk or posedge reset) begin
	if (reset) begin
		IFID_PC <= 32'h; //
		IFID_Instruction <= 32'h0;
	end
	else if begin
	end
	else begin
		IFID_PC <= PC;
		IFID_Instruction <= Instruction;
	end
end

//ID
Control control(
		.OpCode(IFID_Instruction[31:26]), .Funct(IFID_Instruction[5:0]), .ker(IFID_PC[31]), .IRQ(IRQ),
		.PCSrc(PCSrc), .RegWrite(RegWrite), .RegDst(RegDst), 
		.MemRead(MemRead),	.MemWrite(MemWrite), .MemtoReg(MemtoReg),
		.ALUSrc1(ALUSrc1), .ALUSrc2(ALUSrc2), .ExtOp(ExtOp), .LuOp(LuOp), .ALUFun(ALUFun), .sign(sign));

		
RegFile regfile(.reset(reset), .clk(clk), .wr(), 
		.addr1(IFID_Instruction[25:21]), .addr2(IFID_Instruction[20:16]), .addr3(),
		.data3(), .data1(Databus1), .data2(Databus2));

assign Ext_out = {ExtOp? {16{IFID_Instruction[15]}}: 16'h0000, IFID_Instruction[15:0]};
assign LU_out = LuOp? {IFID_Instruction[15:0], 16'h0000}: Ext_out;
		
		
//EX		
assign ALU_in1 = IDEX_ALUSrc1? {27'h0000000, IDEX_Shamt}: IDEX_Databus1;
assign ALU_in2 = IDEX_ALUSrc2? IDEX_LUout: IDEX_Databus2;		
ALU alu(.A(ALU_in1), .B(ALU_in2), .Sign(IDEX_sign), .ALUFun(IDEX_ALUFun), .z(ALU_out));

//MEM

DataMem data_mem1(
		.reset(reset), .clk(clk), .rd(EXME_MemRead & ~EXME_ALUout[30]), .wr(EXME_MemWrite & ~EXME_ALUout[30]),
		.addr(EXME_ALUout), .wdata(EXME_Databus2), .rdata(rdata1));
PeripheralDevice peride(
		.reset(reset), .clk(clk), .sysclk(sysclk), .sysclk_bd(sysclk_bd), .sysclk_sam(sysclk_sam), .rd(EXME_MemRead & EXME_ALUout[30]),
		.wr(EXME_MemWrite & EXME_ALUout[30]),.addr(EXME_ALU_out),
		.wdata(EXME_Databus2), .rdata(rdata2), .led(led), .switch(switch), .UART_RX(UART_RX), .UART_TX(UART_TX), .irqout(IRQ));
assign Read_data = EXME_ALU_out[30]? rdata2: rdata1;
assign Databus3 = (EXME_Memtoreg == 2'b00)? EXME_ALU_out: (EXME_MemtoReg == 2'b01)? Read_data: EXME_PC_4;

//WB

	

endmodule