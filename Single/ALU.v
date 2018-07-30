module ALU(in1, in2, out, sign, funct);
input in1, in2, sign, funct;
output out;
wire [31:0]in1;
wire [31:0]in2;
wire [31:0]in2_2;
wire [5:0]funct;
wire sign;
reg [31:0]out;
wire [31:0]out_1;
wire [32:0]out_1_1;
wire [32:0]out_2;
wire [32:0]in1_ext;
wire [32:0]in2_ext;
wire [32:0]in2_ext_2;
reg [63:0] out_ext;
wire [32:0] out_ext_;
wire Z, V, N;

assign in1_ext[31:0] = in1;
assign in2_ext[31:0] = in2;
assign in1_ext[32] = 0;
assign in2_ext[32] = 0;
assign in2_ext_2 = ~in2_ext + 1;//取二补码对无符号数进行计算
assign out_ext_ = in1_ext + in2_ext_2; //out_ext= A - B
assign in2_2 = ~in2 + 1;//取二补码对有符号数进行计算
assign out_1 = in1 + in2;// A + B有符号位
assign out_1_1 = in1_ext + in2_ext;// A + B无符号位
assign out_2 = in1 + in2_2; // A - B
assign Z = (in1 == in2);
assign N = sign & out_2[31];
assign V = (sign&&(in1[31]&&in2_2[31]&&(out_2[31]==0)||(in1[31]==0)&&(in2_2[31]==0)&&out_2[31]))||((~sign)&&(out_ext_[32]||out_1_1[32]));
always @(*)
begin
case (funct)
    6'b000000: out <= in1 + in2;
    6'b000001: out <= in1 + in2_2;
    6'b011000: out <= in1 & in2;
    6'b011110: out <= in1 | in2;
    6'b010110: out <= in1 ^ in2;
    6'b010001: out <= ~(in1|in2);
    6'b011010: out <= in2;
    6'b100000: begin
            out_ext = {32'b0, in2};
            if (in1[0]) out_ext = out_ext << 1;
            if (in1[1]) out_ext = out_ext << 2;
            if (in1[2]) out_ext = out_ext << 4;
            if (in1[3]) out_ext = out_ext << 8;
            if (in1[4]) out_ext = out_ext << 16;
            out <= out_ext[31:0];
    end
    6'b100001: begin
            out_ext = {32'b0, in2};
            if (in1[0]) out_ext = out_ext >> 1;
            if (in1[1]) out_ext = out_ext >> 2;
            if (in1[2]) out_ext = out_ext >> 4;
            if (in1[3]) out_ext = out_ext >> 8;
            if (in1[4]) out_ext = out_ext >> 16;
            out <= out_ext[31:0];
    end
    6'b100011: begin
            out_ext = {{32{in2[31]}}, in2};
            if (in1[0]) out_ext = out_ext >> 1;
            if (in1[1]) out_ext = out_ext >> 2;
            if (in1[2]) out_ext = out_ext >> 4;
            if (in1[3]) out_ext = out_ext >> 8;
            if (in1[4]) out_ext = out_ext >> 16;
            out <= out_ext[31:0];
    end
    6'b110011: out <= (Z==1)?1:0;
    6'b110001: out <= (Z==1)?0:1;
    6'b110101: out <= (N==1)?1:0;
    6'b111101: out <= (N==1||Z==0)?1:0;
    6'b111101: out <= ((in1[31] == 1||in1 == 32'b0)&&sign == 1)?1:0;
    6'b111011: out <= (in1[31] == 1 && sign == 1)?1:0;
    6'b111111: out <= ((in1[31] == 1||in1 == 32'b0)&&sign == 1)?0:1;
endcase
end
endmodule
