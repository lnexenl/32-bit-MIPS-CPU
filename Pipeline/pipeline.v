module CPU(reset, sysclk, led, UART_TX, UART_RX);
input reset, sysclk, UART_RX;
output [7:0] led;
output UART_TX;
wire clk, sysclk_bd, sysclk_sam;
wire [6:0]BCD;
wire [3:0]DK;
reg [31:0] PC;
wire [31:0] PC_plus_4;
wire [31:0] PC_next;
wire [31:0] instruction;
reg [31:0] IFID_PC;
reg [31:0] IFID_PC_4;
reg [31:0] IFID_Instruction;
wire IRQ, RegWrite, MemRead, MemWrite, ALUSrc1, ALUSrc2, ExtOp, LuOp, sign;
wire [2:0] PCSrc;
wire [1:0] RegDst;
wire [1:0] MemtoReg;
wire [5:0] ALUFun;
wire [4:0] Write_register;
wire [31:0] Databus1;
wire [31:0] Databus2;
wire [31:0] Ext_out;
wire [31:0] LU_out;
wire Branch, Jump, Jr;
wire [31:0] Branch_target;
wire [31:] Jump_target;
reg [31:0] IDEX_PC;
reg [31:0] IDEX_PC_4;
reg [2:0] IDEX_PCSrc;
reg [31:0] IDEX_Databus1;
reg [31:0] IDEX_Databus2;
reg [31:0] IDEX_LUout;
reg [4:0] IDEX_Writeregister;
reg [4:0] IDEX_Rs;
reg [4:0] IDEX_Rt;
reg [4:0] IDEX_Shamt;
reg IDEX_ExtOp, IDEX_ALUSrc1, IDEX_ALUSrc2, IDEX_sign, IDEX_LuOp, IDEX_MemRead, IDEX_MemWrite, IDEX_RegWrite, IDEX_Branchtarget;
reg [1:0] IDEX_MemtoReg;
reg [5:0] IDEX_ALUFun;
reg [31:0] IDEX_Branchtarget;
wire [31:0] ALU_in1,;
wire [31:0] ALU_in2;
wire [31:0] ALU_out;
reg [31:0] EXME_PC_4;
reg [31:0] EXME_ALUout;
reg [31:0] EXME_Databus2;
reg [4:0] EXME_Writeregister;
reg EXME_MemRead, EXME_MemWrite;
reg [1:0] EXME_MemtoReg;
reg EXME_RegWrite;
wire [31:0] rdata1;
wire [31:0] rdata2;
wire [31:0] Read_data;
wire [31:0] Databus3;
reg MEWB_RegWrite;
reg [31:0] MEWB_Databus3;
reg [4:0] MEWB_Writeregister;
reg [1:0] MEWB_MemtoReg;

UART_BR ubr(.sysclk(sysclk), .sysclk_bd(sysclk_bd), .sysclk_sam(sysclk_sam), .sysclk_25M(clk));

assign PC_plus_4 = PC + 32'd4;
always @(posedge clk or posedge reset)
	if (reset)
		PC <= 32'h00000000;
	else if (PCSrc == 3'd4) //&& ~Branch
		PC <= 32'h80000004;
	else if (PCSrc == 3'd5)
		PC <= 32'h80000008;
	else if (~Load_use) begin
		PC <= (Branch)? IDEX_Branchtarget: (Jump)? Jump_target: (Jr)?Databus1: PC_plus_4;
			
		
ROM rom(.addr({1'b0,PC[30:0]}), .data(Instruction));
//IFID
always @(posedge clk or posedge reset) begin
	if(reset) begin
		IFID_PC <= 32'h00000000;
		IFID_PC_4 <= 32'h00000000;
		IFID_Instruction <= 32'h0;
	end
	else if (Branch || Jump || Jr) begin
		IFID_PC <= {IFID_PC[31], 31'd0};
		IFID_PC_4 <= {IFID_PC_4[31], 31'd0};
		IFID_Instruction <= 32'd0;
	end
	else if(~Load_use) begin
		IFID_PC <= PC;
		IFID_PC_4 <= PC_plus_4;
		IFID_Instruction <= Instruction;
	end
end
//ID
Control control(
		.OpCode(IFID_Instruction[31:26]), .Funct(IFID_Instruction[5:0]), .ker(IFID_PC[31]), .IRQ(IRQ),  //IFID_PC_4
		.PCSrc(PCSrc), .RegWrite(RegWrite), .RegDst(RegDst), 
		.MemRead(MemRead),	.MemWrite(MemWrite), .MemtoReg(MemtoReg),
		.ALUSrc1(ALUSrc1), .ALUSrc2(ALUSrc2), .ExtOp(ExtOp), .LuOp(LuOp), .ALUFun(ALUFun), .sign(sign));

assign Write_register = (RegDst == 2'b00)? IFID_Instruction[15:11]: 
						(RegDst == 2'b01)? IFID_Instruction[20:16]:
						(RegDst == 2'b10)? 5'd31: 5'd26;
RegFile regfile(.reset(reset), .clk(clk), .wr(MEWB_RegWrite), 
		.addr1(IFID_Instruction[25:21]), .addr2(IFID_Instruction[20:16]), .addr3(MEWB_Writeregister),
		.data3(MEWB_Databus3), .data1(Databus1), .data2(Databus2));

assign Ext_out = {ExtOp? {16{IFID_Instruction[15]}}: 16'd0, IFID_Instruction[15:0]};
assign LU_out = LuOp? {IFID_Instruction[15:0], 16'd0}: Ext_out;
assign Jump = (PCSrc == 3'd2)?1:0;
assign Jr = (PCSrc == 3'd3)?1:0;
assign Jump_target = {IFID_PC_4[31:28], IFID_Instruction[25:0], 2'b00};
assign Branch_target = IFID_PC_4 + {Ext_out[29:0], 2'b00};
//IDEX
always @(posedge clk or posedge reset) begin
	if (reset) begin
	end
	else
		IDEX_ALUFun <= ALUFun;
		IDEX_ALUSrc1 <= ALUSrc1;
		IDEX_ALUSrc2 <= ALUSrc2;
		IDEX_Databus1 <= Databus2;
		IDEX_Databus2 <= Databus1;
		IDEX_ExtOp <= ExtOp;
		IDEX_LUout <= LU_out;
		IDEX_LuOp <= LuOp;
		IDEX_MemtoReg <= MemtoReg;
		IDEX_PC <= IFID_PC; //
		IDEX_PC_4 <= IFID_PC_4; //
		IDEX_PCSrc <= PCSrc;
		IDEX_RegWrite <=RegWrite;
		IDEX_Rs <= IFID_Instruction[25:21];
		IDEX_Rt <= IFID_Instruction[20:16];
		IDEX_Shamt <= IFID_Instruction[10:6];
		IDEX_Writeregister <= Write_register;
		IDEX_sign <= sign;
		IDEX_Branchtarget <= Branch_target;
		if (Branch || Load_use) begin
			IDEX_MemRead <= 1'b0;
			IDEX_MemWrite <= 1'b0;
		end
		else
			IDEX_MemRead <= MemRead;
			IDEX_MemWrite <= MemWrite;
		end
	end
end
//EX
assign Load_use = (IDEX_MemRead && (IDEX_Rt==IFID_Instruction[20:16] || IDEX_Rt==IFID_Instruction[25:21]))?1:0;	
assign ALU_in1 = IDEX_ALUSrc1? {27'd0, IDEX_Shamt}: IDEX_Databus1;
assign ALU_in2 = IDEX_ALUSrc2? IDEX_LUout: IDEX_Databus2;		
ALU alu(.A(ALU_in1), .B(ALU_in2), .Sign(IDEX_sign), .ALUFun(IDEX_ALUFun), .z(ALU_out));
assign Branch = (IDEX_PCSrc == 3'd1 && ALU_out[0])?1:0;	
//EXME
always @(posedge clk or posedge reset) begin
	if (reset) begin
			EXME_ALUout <= 32'd0;
			EXME_Databus2 <= 32'd0;
			EXME_MemRead <= 1'b0;
			EXME_MemWrite <= 1'b0;
			EXME_MemtoReg <= 2'd0;
			EXME_PC_4 <= 32'd0;
			EXME_RegWrite <= 1'b0;
			EXME_Writeregister <= 5'd0;
	end
	else 
		EXME_ALUout <= ALU_out;
		EXME_Databus2 <= IDEX_Databus2;
		EXME_MemRead <= IDEX_MemRead;
		EXME_MemWrite <= IDEX_MemWrite;
		EXME_MemtoReg <= IDEX_MemtoReg;
		EXME_PC_4 <= IDEX_PC_4;
		EXME_RegWrite <= IDEX_RegWrite;
		EXME_Writeregister <= IDEX_Writeregister;
	end
end
//ME
DataMem data_mem1(
		.reset(reset), .clk(clk), .rd(EXME_MemRead & ~EXME_ALUout[30]), .wr(EXME_MemWrite & ~EXME_ALUout[30]),
		.addr(EXME_ALUout), .wdata(EXME_Databus2), .rdata(rdata1));
PeripheralDevice peride(
		.reset(reset), .clk(clk), .sysclk(sysclk), .sysclk_bd(sysclk_bd), .sysclk_sam(sysclk_sam), .rd(EXME_MemRead & EXME_ALUout[30]),
		.wr(EXME_MemWrite & EXME_ALUout[30]),.addr(EXME_ALUout), .wdata(EXME_Databus2), .rdata(rdata2),
		.led(led), .switch(switch), .UART_RX(UART_RX), .UART_TX(UART_TX), .irqout(IRQ), .BCD(BCD), .DK(DK));
assign Read_data = EXME_ALUout[30]? rdata2: rdata1;
assign Databus3 = (EXME_MemtoReg == 2'b00)? EXME_ALUout: (EXME_MemtoReg == 2'b01)? Read_data: EXME_PC_4;
//MEWB
always @(posedge clk or posedge reset) begin
	if (reset) begin
		MEWB_Databus3 <= 32'd0;
		MEWB_RegWrite <= 1'b0;
		MEWB_Writeregister <= 5'd0;
		MEWB_MemtoReg <= 2'd0;
	end
	else
		MEWB_Databus3 <= Databus3;
		MEWB_RegWrite <= EXME_RegWrite;
		MEWB_Writeregister <= EXME_Writeregister;
		MEWB_MemtoReg <= EXME_MemtoReg;
		
	end
end
	
endmodule