module ALU(A,B,Sign,ALUFun,Z,Y,N,S);
input [31:0] A, B;
input Sign;
input [5:0] ALUFun;
output reg Z;
output reg Y;
output reg N;
output [31:0] reg S;
wire [32:0] IN1;
wire [32:0] IN2=9'h000000000;
wire [32:0] OUT=9'h000000000;
	always @(*)
		case (ALUFun)
// compute
			6'b000000:{
			S <= A + B;
			if(S == 8'h00000000)
			{Z <= 1;
			}
			else
			{Z <= 0;
			}
			if(S[0]==1'b1)
			{N <= 1;
			}
			else
			{N <= 0;
			}
			IN1 <= 9'h000000000;
			IN2 <= 9'h000000000;
			OUT <= 9'h000000000;
			IN1[32:1] <= A;
			IN2[32:1] <= B;
			OUT <= IN1 + IN2;
			if(OUT[0] == 1)
			{V <= 1;
			}
			else
			{V <= 0;
			}
			}
			6'b000001:{ 
			S <= A - B;
			if(S == 8'h00000000)
			{Z <= 1;
			}
			else
			{Z <= 0;
			}
			if(S[0]==1'b1)
			{N <= 1;
			}
			else
			{N <= 0;
			}
			IN1 <= 9'h000000000;
			IN2 <= 9'h000000000;
			OUT <= 9'h000000000;
			IN1[32:1] <= A;
			IN2[32:1] <= B;
			OUT <= IN1 - IN2;
			if(OUT[0] == 1)
			{V <= 1;
			}
			else
			{V <= 0;
			}
			}
			}
// logic
			6'b011000: S <= A & B;
			6'b011110: S <= A | B;
			6'b010110: S <= A ^ B;
			6'b010001: S <=~(A|B);
			6'b011010: S <= A    ;
//changeposition
			6'b100000: S <= (B << A[4:0]);
			6'b100001: S <= (B >> A[4:0]);
			6'b100011: S <= ({{32{B[31]}}, B} >> A[4:0]);
//corleration
			6'b110011: S <= (A==B)?8'h000000001:8'h00000000;
			6'b110001: S <= (A!=B)?8'h000000001:8'h00000000;
			6'b110101: S <= (A<B)?8'h000000001:8'h00000000;
			6'b111101: S <= (A<=8'h00000000)?8'h000000001:8'h00000000;
			6'b111011: S <= (A<8'h00000000)?8'h000000001:8'h00000000;
			6'b111111: S <= (A>8'h00000000)?8'h000000001:8'h00000000;
			default: S <= 32'h00000000;
		endcase

endmodule