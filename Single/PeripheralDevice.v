module PeripheralDevice(reset, clk, clk_Baud, rd, wr, addr, wdata, rdata, led, switch, UART_RX, UART_TX, irqout)
input reset, clk, clk_Baud, rd, wr, UART_RX;
input [7:0] switch;
input [31:0] addr;
input [31:0] wdata;
output UART_TX, irqout;
output [31:0] rdata;
output [7:0] led;
wire [7:0] RX_DATA;
wire [7:0] TX_DATA;

UART uart(clk, UART_RX, UART_TX, RX_DATA, TX_DATA, TX_STATUS, TX_END, RX_END);
//发送模块发送时TX_END出现一个正脉冲；接收模块接收完毕时RX_END出现一个正脉冲；发送模块处于发送状态时TX_STATUS为1，空闲时为0；发送使能信号待定
Peripheral peri(
	.reset(reset), .clk(clk), .rd(rd), .wr(wr), .addr(addr), .wdata(wdata), .rdata(rdata),
	.led(led), .switch(switch), .digi(digi), .irqout(irqout), .UART_RXD(UART_RXD), .UART_TXD(UART_TXD),
	.TX_STATUS(TX_STATUS), .RX_END(RX_END), .TX_END(TX_END));
Digi digi();

endmodule