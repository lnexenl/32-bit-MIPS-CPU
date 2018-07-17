`timescale 1ns/1ps

module ALU_tb();  
 reg [31:0] A;
 reg [31:0] B;	   
 reg [5:0] ALUFun;         
 reg Sign;
 wire [31:0] Z;

initial
begin
#1 A=8'h0000_0000;
   B=8'h0000_0000;
   ALUFun=6'b000000;
   Sign=1'b1;
repeat(100)
begin
  #10
  A=A+8'h00000001;
  B=B+8'h00000001;
  ALUFun=ALUFun+6'b000001;
end
end
always 
begin
 #5  
  Sign=~Sign;

end

MAC MAC(
    .A(A),
    .B(B),	   
    .Z(Z),         
    .Sign(Sign),         
    .ALUFun(ALUFun)
    );
endmodule