module ALU(A,B,Z,Sign,ALUFun);
input [31:0] A;
input [31:0] B;
input [5:0] ALUFun;
input Sign;
output [31:0] Z;
wire Y=1'b0,Y1=1'b0,Y2=1'b0;
wire N=1'b0,N1=1'b0,N2=1'b0;
wire [31:0] add;
wire [31:0] sub;
wire [32:0] IN1=9'h000000000;
wire [32:0] IN2=9'h000000000;
wire [32:0] OUT1=9'h000000000;
wire [32:0] OUT2=9'h000000000;
//如果溢出就直接溢出位就可以了
assign add = A + B;
assign IN1[31:0] = A;
assign IN2[31:0] = B;
assign OUT1 = IN1 + IN2;
assign OUT2 = IN1 - IN2;
assign N1 = (Sign==1'b1&&add[31]==1'b1)?1'b1:1'b0;
assign N2 = (Sign==1'b1&&sub[31]==1'b1)?1'b1:1'b0;
assign V1 = (OUT1[32]==1'b1)?1'b1:1'b0;
assign V2 = (OUT2[32]==1'b1)?1'b1:1'b0;

always @(*)
case (ALUFun)
	6'b000000: //ADD
	begin
		Z <= add;
		Y <= Y1;
		if(Sign==1'b1) N <= N1;
	end
	else N <= 1'b0;
	6'b000001: //SUB
	begin 
		Z <= sub;
		Y <= Y2;
		if (Sign == 1'b1) N <= N2;
		else N <= 1'b0;
	end
	6'b011000: Z <= A & B;
	6'b011110: Z <= A | B;
	6'b010110: Z <= A ^ B;
	6'b010001: Z <=~(A|B);
	6'b011010: Z <= A    ;
	6'b100000: Z <= (B << A[4:0]);
	6'b100001: Z <= (B >> A[4:0]);
	6'b100011: Z <= ({{32{B[31]}}, B} >> A[4:0]);
	6'b110011:
	begin
		Z = sub; 
		Z <= (Z==8'h00000000)?8'h000000001:8'h00000000;
	end
	6'b110001:
	begin 
		Z = sub;
		Z <= (Z!=8'h00000000)?8'h000000001:8'h00000000;
	end
	6'b110101:
	begin
		Z = sub;
		Z <= (Z[0])?8'h000000001:8'h00000000;
	end
	6'b111101: Z <= ((Sign==1'b1&&A[31]==1'b1)||A==8'h00000000)?8'h000000001:8'h00000000;
	6'b111011: Z <= (Sign==1'b1&&A[31]==1'b1)?8'h000000001:8'h00000000;
	6'b111111: Z <= (((Sign==1'b1&&A[31]==1'b0)||(Sign==1'b0))&&(A!=8'h00000000))?8'h000000001:8'h00000000;
	default: Z <= 32'h00000000;
endcase

endmodule