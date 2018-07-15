module PeripheralDevice(reset, sysclk, clk, rd, wr, addr, wdata, rdata, led, switch, UART_RX, UART_TX, irqout)
input reset, clk, clk_Baud, rd, wr, UART_RX;
input [7:0] switch;
input [31:0] addr;
input [31:0] wdata;
output UART_TX, irqout;
output [31:0] rdata;
output [7:0] led;
wire [7:0] RX_DATA;
wire [7:0] TX_DATA;
wire ctrl, RX_STATUS, TX_STATUS;

UART uart(.sysclk(sysclk), .PC_Uart_rxd(UART_RX), .PC_Uart_txd(UART_TX), .RX_DATA(RX_DATA), .TX_DATA(TX_DATA), .led(led), .ctrl(ctrl), .RX_STATUS(RX_STATUS).TX_STATUS(TX_STATUS));
Peripheral peri(
	.reset(reset), .clk(clk), .rd(rd), .wr(wr), .addr(addr), .wdata(wdata), .rdata(rdata),
	.led(led), .switch(switch), .digi(digi), .irqout(irqout), .RX_DATA(RX_DATA), .TX_DATA(TX_DATA),
	.RX_STATUS(RX_STATUS), .TX_STATUS(TX_STATUS), .ctrl(ctrl));
Digi digi();

endmodule