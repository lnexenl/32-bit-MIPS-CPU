module UART_BR(sysclk, sysclk_bd, sysclk_sam, sysclk_25M);
input wire sysclk;
output reg sysclk_bd = 0;
output reg sysclk_sam = 0;
output reg sysclk_25M = 0;
reg [12:0]cnt = 13'b0;
reg [8:0] cnt1 = 9'b0;
reg [15:0] cnt2 = 2'b0;
always @(posedge sysclk)
begin
    if(cnt == 5199)
    begin
        sysclk_bd = ~sysclk_bd;
        cnt = 0;
    end
    else cnt = cnt + 1;
    if(cnt1 == 324)
    begin
        sysclk_sam = ~sysclk_sam;
        cnt1 = 0;
    end
    else cnt1 = cnt1 + 1;
    if(cnt2 == 2'b11) sysclk_25M = ~sysclk_25M;
    cnt2 = cnt2 + 1;
end
endmodule