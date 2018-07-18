module UART(sysclk, sysclk_bd, sysclk_sam, reset, PC_Uart_rxd, PC_Uart_txd, RX_DATA, TX_DATA, ctrl, RX_STATUS, TX_STATUS);
input sysclk, sysclk_bd, sysclk_sam, PC_Uart_rxd, ctrl, reset;
wire sysclk, sysclk_bd, sysclk_sam, PC_Uart_rxd, ctrl, reset;
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
always @(posedge sysclk or posedge reset)
begin
    if (reset) 
        TX_EN <= 0;
    else 
    begin
        if (ctrl) TX_EN <= 1;
        else TX_EN <= 0;
    end
end
UART_receiver r(.PC_UART_rxd(PC_Uart_rxd),.sysclk(sysclk), .sam(sysclk_sam), .reset(reset), .RX_DATA(RX_DATA),.RX_SAVE(RX_SAVE), .RX_STATUS(RX_STATUS));
UART_sender s( TX_DATA,TX_EN,TX_STATUS,PC_Uart_txd,sysclk_bd, sysclk, reset);
endmodule

module UART_receiver(PC_UART_rxd,sysclk,sam,reset,RX_DATA,RX_SAVE,RX_STATUS);
input PC_UART_rxd, sam, sysclk, reset;
output reg [7:0]RX_DATA;
output reg [7:0]RX_SAVE;
output reg RX_STATUS = 0;
reg [2:0]cnt = 0;
reg [3:0] RX = 0;
reg RX_EN = 0;
reg [1:0]status = 2'b00;
reg FLAG = 0;
always@(posedge sysclk or posedge reset)
begin
if(reset)
begin
    RX_STATUS <= 0;
    FLAG <= 0;
end
else begin
        if(status == 2'b10) FLAG <= 1;
        if(status == 2'b11 && FLAG == 1) begin
            RX_STATUS <= 1;
        end
        if (RX_STATUS == 1) begin
            RX_STATUS <= 0;
            FLAG <= 0;
        end
    end
end
always @(posedge sam or posedge reset)
begin
if(reset)
begin
  status <= 2'b00;
  cnt <= 3'b0;
end
else 
    begin
        if((~RX_EN) & (~PC_UART_rxd) & (~RX_STATUS))
        begin
        if(cnt == 7)
        begin
            status = 2'b01;
            RX_EN = 1;
        end
        else cnt = cnt + 1;
        end
        else if(RX_EN)
        begin
            cnt = cnt + 1;
            if(cnt == 4)
            begin
                status = 2'b10;
                RX_SAVE[RX] = RX_DATA[RX];
                RX_DATA[RX] = PC_UART_rxd;
                RX = RX + 1;
            end
            if(RX == 8)
            begin
                status = 2'b11;
                RX = 0;
                RX_EN = 0;
                cnt = 0;
                RX_STATUS = 1;
            end
        end
        else
        begin
            if(PC_UART_rxd)
            begin
                RX_STATUS = 0;
                status = 2'b00;
            end
        end
    end
end
endmodule

module UART_sender(TX_DATA,TX_EN,TX_STATUS,PC_UART_txd,sysclk_bd, sysclk, reset);
input wire [7:0]TX_DATA;
input wire TX_EN, sysclk_bd, sysclk, reset;
reg FLAG = 0;
output reg TX_STATUS = 1, PC_UART_txd = 1;
reg [3:0] cnt = 0;
reg [1:0]status = 2'b00;
always @(posedge sysclk or posedge reset)
begin
if(reset) begin
    FLAG <= 0;
end
else begin
    if(TX_STATUS && FLAG == 0 && TX_EN) FLAG = 1;
    else if(status == 2'b11) FLAG = 0;
end
end
always @(posedge sysclk_bd or posedge reset)
begin
if(reset)
begin
    cnt <= 4'b0;
    status <= 2'b00;
    PC_UART_txd <= 1'b1;
    TX_STATUS <= 1'b1;
end
else begin
    if(status == 2'b00 && FLAG == 1)
    begin
        cnt = 0;
        TX_STATUS = 0;
        status = 2'b01;
    end
    else if(~TX_STATUS & sysclk_bd)
    begin
        if(cnt == 0)
        begin
            PC_UART_txd = 0;
            cnt = cnt + 1;
            status = 2'b10;
        end
        else if(cnt <=8)
        begin
            PC_UART_txd = TX_DATA[cnt - 1];  
            cnt = cnt + 1;
            status = 2'b11;
        end
        else
        begin
            PC_UART_txd = 1;
            TX_STATUS = 1;
            status = 2'b00;
        end
    end
end
end
endmodule