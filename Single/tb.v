`timescale 1ns/1ns
module tb();
wire [7:0]led;
wire UART_TX;
reg UART_RX;
reg reset, sysclk;
initial begin
  reset = 0;
  sysclk = 0;
  UART_RX = 0;
  repeat(2) 
    #100 reset = ~reset;
  repeat(1)
  begin
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 1;
	
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 1;
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
CPU C(reset, sysclk, led, UART_TX, UART_RX);
endmodule