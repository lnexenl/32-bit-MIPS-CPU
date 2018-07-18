module UART_BR(sysclk, sysclk_bd, sysclk_sam, sysclk_25M, reset);
input wire sysclk, reset;
output reg sysclk_bd = 0;
output reg sysclk_sam = 0;
output reg sysclk_25M = 0;
reg [12:0]cnt = 13'b0;
reg [8:0] cnt1 = 9'b0;
reg [1:0] cnt2 = 2'b0;
always @(posedge sysclk or posedge reset)
begin
if (reset)
begin
    cnt = 13'b0;
    cnt1 = 9'b0;
    cnt2 = 2'b0;
    sysclk_25M = 0;
    sysclk_bd = 0;
    sysclk_sam = 0;
end
else
begin
    if(cnt == 13'd5199)
    begin
        sysclk_bd = ~sysclk_bd;
        cnt = 13'd0;
    end
    else cnt = cnt + 1;
    if(cnt1 == 9'd324)
    begin
        sysclk_sam = ~sysclk_sam;
        cnt1 = 9'd0;
    end
    else cnt1 = cnt1 + 1;
    if(cnt2 == 2'b11) sysclk_25M = ~sysclk_25M;
    cnt2 = cnt2 + 1;
end
end
endmodule