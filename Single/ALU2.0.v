module ALU(A,B,S,Z,ALUFun);
input [31:0] A, B;
input S;
input [5:0] ALUFun;
wire Y,Y1,Y2;
wire N,N1,N2;
wire [31:0] add;
wire [31:0] jian;
output [31:0] reg Z;
wire [32:0] IN1;
wire [32:0] IN2=9'h000000000;
wire [32:0] OUT=9'h000000000;

assign
{
if(Sign==1)
{
add <= A + B;
jian <=A - B;
if(add[0]==1'b1)
{N1 <= 1;
}
else
{N1 <= 0;
}
if(jian[0]==1'b1)
{N2 <= 1;
}
else
{N2 <= 0;
}
IN1 <= 9'h000000000;
IN2 <= 9'h000000000;
OUT <= 9'h000000000;
IN1[32:1] <= A;
IN2[32:1] <= B;
OUT <= IN1 + IN2;
if(OUT[0] == 1)
{V1 <= 1;
}
else
{V1 <= 0;
}
OUT <= IN1 - IN2;
if(OUT[0] == 1)
{V2 <= 1;
}
else
{V2 <= 0;
}
}
else{
add <= A + B;
jian <=A - B;

IN1 <= 9'h000000000;
IN2 <= 9'h000000000;
OUT <= 9'h000000000;
IN1[32:1] <= A;
IN2[32:1] <= B;
OUT <= IN1 + IN2;
if(OUT[0] == 1)
{V1 <= 1;
}
else
{V1 <= 0;
}
OUT <= IN1 - IN2;
if(OUT[0] == 1)
{V2 <= 1;
}
else
{V2 <= 0;
}
}
}
	always @(*)
		case (ALUFun)
// compute
			6'b000000:{
			Z <= add;
			Y <= Y1;
			if(Sign==1)
			{N <= N1;}
			}
			6'b000001:{ 
			Z <= jian;
			Y <= Y2;
			if(Sign==1)
			{N <= N2;}
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
			6'b110011: S <= (!Z)?8'h000000001:8'h00000000;
			6'b110001: S <= (Z)?8'h000000001:8'h00000000;
			6'b110101: S <= (Z[0])?8'h000000001:8'h00000000;
			6'b111101: S <= (A<=8'h00000000)?8'h000000001:8'h00000000;
			6'b111011: S <= (A<8'h00000000)?8'h000000001:8'h00000000;
			6'b111111: S <= (A>8'h00000000)?8'h000000001:8'h00000000;
			default: S <= 32'h00000000;
		endcase

endmodule