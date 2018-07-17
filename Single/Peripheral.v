`timescale 1ns/1ps

module Peripheral (reset, clk, rd, wr, addr, wdata, rdata, led, switch, digi, irqout, RX_DATA, TX_DATA, RX_STATUS, TX_STATUS, ctrl);
input reset, clk;
wire reset, clk;
input rd, wr;
wire rd, wr;
input TX_STATUS, RX_STATUS;
wire TX_STATUS, RX_STATUS;
input wire[31:0] addr;
input wire[31:0] wdata;
input wire[7:0] switch;
input wire[7:0] RX_DATA;
output reg[31:0] rdata;
output reg[7:0] led;
output reg[11:0] digi;
output reg[7:0] TX_DATA;
output irqout;
output wire ctrl;

reg [31:0] TH,TL;
reg [2:0] TCON;
assign irqout = TCON[2];

reg UART_SEND, UART_CONR;
assign ctrl = UART_SEND;

initial begin
	UART_CONR = 0;
	UART_SEND = 0;
end

always@(*) begin
	if (RX_STATUS) UART_CONR <= 1;	
	if(rd) begin
		case(addr)
			32'h40000000: rdata <= TH;			
			32'h40000004: rdata <= TL;			
			32'h40000008: rdata <= {29'b0,TCON};				
			32'h4000000C: rdata <= {24'b0,led};			
			32'h40000010: rdata <= {24'b0,switch};
			32'h40000014: rdata <= {20'b0,digi};
			32'h40000018: rdata <= {24'b0,TX_DATA};
			32'h4000001C: rdata <= {24'b0,RX_DATA};
			32'h40000020: begin 
							rdata <= {30'b0, UART_CONR, TX_STATUS};
							UART_CONR <=0;
						  end
			default: rdata <= 32'b0;
		endcase
	end
	else
		rdata <= 32'b0;
end

always@(negedge reset or posedge clk) begin
	if(~reset) begin
		TH <= 32'b0;
		TL <= 32'b0;
		TCON <= 3'b0;
		led <= 8'b0;
		digi <= 12'h100;
		UART_SEND <= 0;
	end
	else begin
		if(TCON[0]) begin	//timer is enabled
			if(TL==32'hffffffff) begin
				TL <= TH;
				if(TCON[1]) TCON[2] <= 1'b1;		//irq is enabled
			end
			else TL <= TL + 1;
		end
		if(wr) begin
			case(addr)
				32'h40000000: TH <= wdata;
				32'h40000004: TL <= wdata;
				32'h40000008: TCON <= wdata[2:0];		
				32'h4000000C: led <= wdata[7:0];			
				32'h40000014: digi <= wdata[11:0];
				32'h40000018: begin
					TX_DATA <= wdata[7:0];
					UART_SEND <= 1;
				end
				default: ;
			endcase
		end
		if (UART_SEND) UART_SEND <= 0;
	end
end
endmodule

