module ADDER(in1, in2, out, sign);
input in1, in2, sign;
output out;
wire [31:0]in1;
wire [31:0]in2;
wire [31:0]in2_2;
wire sign;
reg [31;0]out;
wire [32:0]out_2;
wire [32:0]in1_ext;
wire [32:0]in2_ext;
wire [32:0]in2_ext_2;
reg [32:0] out_ext;
wire Z, V, N;

assign in1_ext[31:0] = in1;
assign in2_ext[31:0] = in2;
assign in1_ext[32] = 0;
assign in2_ext[32] = 0;
assign in2_ext_2 = ~in2_ext + 1;
assign out_ext = in1_ext + in2_ext_2;
assign in2_2 = ~in2 + 1;
assign out_2 = in1 + in2_2;
assign Z = (A == B);
assign N = ((sign && out[31])||(~sign)&&out_2[2]);
assign V = (sign&&(in1[31]&&in2_2[31]&&(out_2[31]==0)||(in1[31]==0)&&(in2_2[31]==0)&&out_2[31]))||((~sign)&&out_2[32]);
always @(*)
begin
case (funct)
    6'b000000: out <= in1 + in2;
    6'b000001: begin 
            if(sign) out <= in1 + in2_2;
            else 
    6'b011000: out <= in1 & in2;
    6'b011110: out <= in1 | in2;
    6'b010110: out <= in1 ^ in2;
    6'b010001: out <= ~(in1|in2);
    6'b011010: out <= in1;
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
    6'b110011: out <= (Z==0)?1:0;
    6'b110001: out <= (Z==0)?0:1;
    6'b110101: out <= (N==1)?1:0;
    6'b111101: out <= (N==1||Z==0)?1:0;
    6'b111101: out <= ((in1[31] == 1||in1 == 32'b0)&&sign == 1)?1:0;
    6'b111011: out <= (in1[31] == 1 && sign == 1)?1:0;
    6'b111111: out <= ((in1[31] == 1||in1 == 32'b0)&&sign == 1)?0:1;
end
end
endmodule