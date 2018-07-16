module ALU(in1, in2, out, sign, funct);
input in1, in2, sign, funct;
output out;
wire [31:0]in1;
wire [31:0]in2;
wire sign;
wire [5:0]funct;
reg [31:0]out;
wire [32:0]add;
wire Z, Y, N;
assign add = in1 + in2;
always @(*)
begin
  case (funct)
    case: 6'b000000 //ADD
    begin
        if(sign == 0) out <= add[31:0];
    end
  endcase
end