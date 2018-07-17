`timescale 1ns/1ns
module tb(reset, sysclk, led, switch, UART_TX, UART_RX);
output reset, sysclk, switch, UART_TX;
input led, UART_RX;
wire [7:0]led;
wire [7:0]switch;
wire UART_RX, UART_TX;
reg reset, sysclk;
initial begin
  reset = 0;
  sysclk = 0;
end
always #50 sysclk = ~sysclk;
CPU C(reset, sysclk, led, switch, UART_TX, UART_RX);
endmodule