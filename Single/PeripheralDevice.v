module PeripheralDevice(reset, clk, sysclk, sysclk_bd, sysclk_sam, rd, wr, addr, wdata, rdata, led, switch, UART_RX, UART_TX, irqout, BCD, DK, digi);
input reset, clk, sysclk, sysclk_bd, sysclk_sam, rd, wr, UART_RX;
wire reset, clk, sysclk, sysclk_bd, sysclk_sam, rd, wr, UART_RX;
input wire [7:0] switch;
input wire [31:0] addr;
input wire [31:0] wdata;
input wire [11:0] digi;
output UART_TX, irqout;
output [31:0] rdata;
output [7:0] led;
output [6:0] BCD;
output [3:0] DK;
wire [7:0] RX_DATA;
wire [7:0] TX_DATA;
wire ctrl, RX_STATUS, TX_STATUS, sysclk_25M;

assign DK = digi[11:8];
assign BCD = digi[6:0];
UART uart(.sysclk(sysclk), .sysclk_bd(sysclk_bd), .sysclk_sam(sysclk_sam), .PC_Uart_rxd(UART_RX), .PC_Uart_txd(UART_TX), .RX_DATA(RX_DATA), .TX_DATA(TX_DATA), .ctrl(ctrl), .RX_STATUS(RX_STATUS), .TX_STATUS(TX_STATUS));
Peripheral peri(
	.reset(reset), .clk(clk), .rd(rd), .wr(wr), .addr(addr), .wdata(wdata), .rdata(rdata),
	.led(led), .switch(switch), .digi(digi), .irqout(irqout), .RX_DATA(RX_DATA), .TX_DATA(TX_DATA),
	.RX_STATUS(RX_STATUS), .TX_STATUS(TX_STATUS), .ctrl(ctrl));

endmodule