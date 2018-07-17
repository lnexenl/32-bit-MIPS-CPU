module UART(sysclk, sysclk_bd, sysclk_sam, PC_Uart_rxd, PC_Uart_txd, RX_DATA, TX_DATA, ctrl, RX_STATUS, TX_STATUS);
input sysclk, sysclk_bd, sysclk_sam, PC_Uart_rxd, ctrl;
wire sysclk, sysclk_bd, sysclk_sam, PC_Uart_rxd, ctrl;
output PC_Uart_txd, RX_STATUS;
output wire [7:0]RX_DATA;
output wire TX_STATUS;
input wire [7:0]TX_DATA;
wire [7:0]RX_SAVE;
wire FLAG;
wire RX_STATUS;
reg TX_EN;
initial begin
    TX_EN = 0;
end
always @(posedge sysclk)
begin
    if (ctrl) TX_EN <= 1;
    else TX_EN <= 0;
end
// assign led = (ctrl == 1)? RX_DATA:RX_SAVE;
//assign TX_DATA = (ctrl == 1)? RX_DATA:RX_SAVE;
UART_receiver r(.PC_UART_rxd(PC_Uart_rxd), .sam(sysclk_sam), .RX_DATA(RX_DATA),.RX_SAVE(RX_SAVE), .RX_STATUS(RX_STATUS));
UART_sender s( TX_DATA,TX_EN,TX_STATUS,PC_Uart_txd,sysclk_bd);
endmodule

module UART_receiver(
    PC_UART_rxd,
    sam,
    RX_DATA,
    RX_SAVE,
    RX_STATUS
    );
input PC_UART_rxd, sam;
output reg [7:0]RX_DATA;
output reg [7:0]RX_SAVE;
output reg RX_STATUS = 0;
reg [2:0]cnt = 0;
reg [3:0] RX = 0;
reg RX_EN = 0;
always @(posedge sam)
begin
    if((~RX_EN) & (~PC_UART_rxd) & (~RX_STATUS))
    begin
      if(cnt == 7)
      begin
          //cnt = 0;
          RX_EN = 1;
      end
      else cnt = cnt + 1;
    end
    else if(RX_EN)
    begin
        cnt = cnt + 1;
        if(cnt == 4)
        begin
            RX_SAVE[RX] = RX_DATA[RX];
            RX_DATA[RX] = PC_UART_rxd;
            RX = RX + 1;
        end
        if(RX == 8)
        begin
            RX = 0;
            RX_EN = 0;
            cnt = 0;
            RX_STATUS = 1;
        end
    end
    else
    begin
        if(PC_UART_rxd)
            RX_STATUS = 0;
    end
end
endmodule

module UART_sender(TX_DATA,TX_EN,TX_STATUS,PC_UART_txd,sysclk_bd);
input wire [7:0]TX_DATA;
input wire TX_EN, sysclk_bd;
output reg TX_STATUS = 1, PC_UART_txd = 1;
reg [3:0] cnt = 0;
always @(posedge sysclk_bd or posedge TX_EN)
begin
if(TX_EN&&TX_STATUS)
begin
    cnt = 0;
    TX_STATUS = 0;
end
else if(~TX_STATUS & sysclk_bd)
begin
    if(cnt == 0)
    begin
        PC_UART_txd = 0;
        cnt = cnt + 1;
    end
    else if(cnt <=8)
    begin
        PC_UART_txd = TX_DATA[cnt - 1];  
        cnt = cnt + 1;
    end
    else
    begin
        PC_UART_txd = 1;
        TX_STATUS = 1;
    end
end
end
endmodule