`timescale 1ns/1ns
module tb();
wire [7:0] led;
wire [6:0] BCD;
wire [3:0] DK;
wire UART_TX;
reg UART_RX, reset ,sysclk;
initial begin
	sysclk <= 0;
	UART_RX <= 1;
	reset <= 0;
	repeat(2) 
		#100 reset = ~reset;
end
always #5 sysclk = ~sysclk;
always begin
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 1;
	
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 1;
	
	#2000000 reset <= 1;
	#10000 reset <= 0;
	
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 1;

	
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 1;

	#2000000 reset <= 1;
	#10000 reset <= 0;
end
CPU C(reset, sysclk, led, UART_TX, UART_RX, BCD, DK);
endmodule