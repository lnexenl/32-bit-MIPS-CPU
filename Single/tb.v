`timescale 1ns/1ns
module tb();
wire [7:0]led;
wire [7:0]switch;
wire UART_TX;
reg UART_RX;
reg reset, sysclk;
initial begin
  reset = 0;
  sysclk = 0;
  UART_RX = 0;
  repeat(2) 
    #100 reset = ~reset;
end
always #10 sysclk = ~sysclk;
always begin
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 1;
	
	#200000 UART_RX <= 0;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 0;
end
CPU C(reset, sysclk, led, switch, UART_TX, UART_RX);
endmodule