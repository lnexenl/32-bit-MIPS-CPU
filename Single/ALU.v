module ALU(A,B,Sign,ALUFun,Z);
input [31:0] A, B;
input Sign;
input [5:0] ALUFun;
output reg [31:0] Z;

always @(*)
	case (ALUFun)
// compute
		6'b000000: Z <= A + B;
		6'b000001: Z <= A - B;
// logic
		6'b011000: Z <= A & B;
		6'b011110: Z <= A | B;
		6'b010110: Z <= A ^ B;
		6'b010001: Z <=~(A|B);
		6'b011010: Z <= A    ;
//changeposition
		6'b100000: Z <= (B << A[4:0]);
		6'b100001: Z <= (B >> A[4:0]);
		6'b100011: Z <= ({{32{B[31]}}, B} >> A[4:0]);
//corleration
		6'b110011: Z <= (A==B)?8'hffffffff:8'h00000000;
		6'b110001: Z <= (A!=B)?8'hffffffff:8'h00000000;
		6'b110101: Z <= (A<B)?8'hffffffff:8'h00000000;
		6'b111101: Z <= (A<=8'h00000000)?8'hffffffff:8'h00000000;
		6'b111011: Z <= (A<8'h00000000)?8'hffffffff:8'h00000000;
		6'b111111: Z <= (A>8'h00000000)?8'hffffffff:8'h00000000;
		default: Z <= 32'h00000000;
	endcase
endmodule