`timescale 1ns/1ns
module tb();
wire [7:0]led;
wire [7:0]switch;
wire UART_RX, UART_TX;
reg reset, sysclk;
initial begin
  reset = 0;
  sysclk = 0;
  repeat(2) 
    #100 reset = ~reset;
end
always #50 sysclk = ~sysclk;
CPU C(reset, sysclk, led, switch, UART_TX, UART_RX);
endmodule