`timescale 1ns/1ps

module ROM (addr,data);
input [30:0] addr;
output [31:0] data;

localparam ROM_SIZE = 131;
(* rom_style = "distributed" *) reg [31:0] ROMDATA[ROM_SIZE-1:0];

assign data=(addr < ROM_SIZE)?ROMDATA[addr[30:2]]:32'b0;

integer i;
initial begin
ROMDATA[0] <= 32'h8000003;
ROMDATA[1] <= 32'h800001c;
ROMDATA[2] <= 32'h800001b;
ROMDATA[3] <= 32'h2010302b;
ROMDATA[4] <= 32'h20115a89;
ROMDATA[5] <= 32'h200f0001;
ROMDATA[6] <= 32'h800000d;
ROMDATA[7] <= 32'h11000001;
ROMDATA[8] <= 32'h11200002;
ROMDATA[9] <= 32'h108042;
ROMDATA[10] <= 32'h800000d;
ROMDATA[11] <= 32'h118842;
ROMDATA[12] <= 32'h800000d;
ROMDATA[13] <= 32'h32080001;
ROMDATA[14] <= 32'h32290001;
ROMDATA[15] <= 32'h1095020;
ROMDATA[16] <= 32'h114ffff6;
ROMDATA[17] <= 32'h12110008;
ROMDATA[18] <= 32'h211402a;
ROMDATA[19] <= 32'h11000003;
ROMDATA[20] <= 32'h2308822;
ROMDATA[21] <= 32'h12110004;
ROMDATA[22] <= 32'h800000d;
ROMDATA[23] <= 32'h2118022;
ROMDATA[24] <= 32'h12110001;
ROMDATA[25] <= 32'h800000d;
ROMDATA[26] <= 32'h800001a;
ROMDATA[27] <= 32'h3600008;
ROMDATA[28] <= 32'h3c124009;
ROMDATA[29] <= 32'h22520008;
ROMDATA[30] <= 32'h8e530000;
ROMDATA[31] <= 32'h2013fff9;
ROMDATA[32] <= 32'h2749824;
ROMDATA[33] <= 32'hae530000;
ROMDATA[34] <= 32'h2252000c;
ROMDATA[35] <= 32'h8e530000;
ROMDATA[36] <= 32'h32730f00;
ROMDATA[37] <= 32'h20140100;
ROMDATA[38] <= 32'h1274000a;
ROMDATA[39] <= 32'h14a040;
ROMDATA[40] <= 32'h1274000c;
ROMDATA[41] <= 32'h14a040;
ROMDATA[42] <= 32'h1274000e;
ROMDATA[43] <= 32'h14a040;
ROMDATA[44] <= 32'h12740000;
ROMDATA[45] <= 32'h14a0c2;
ROMDATA[46] <= 32'h320c000f;
ROMDATA[47] <= 32'hc00003d;
ROMDATA[48] <= 32'h800007b;
ROMDATA[49] <= 32'h14a040;
ROMDATA[50] <= 32'h320c00f0;
ROMDATA[51] <= 32'hc00003d;
ROMDATA[52] <= 32'h800007b;
ROMDATA[53] <= 32'h14a040;
ROMDATA[54] <= 32'h322c000f;
ROMDATA[55] <= 32'hc00003d;
ROMDATA[56] <= 32'h800007b;
ROMDATA[57] <= 32'h14a040;
ROMDATA[58] <= 32'h322c00f0;
ROMDATA[59] <= 32'hc00003d;
ROMDATA[60] <= 32'h800007b;
ROMDATA[61] <= 32'h9820;
ROMDATA[62] <= 32'h1193001e;
ROMDATA[63] <= 32'h22730001;
ROMDATA[64] <= 32'h1193001e;
ROMDATA[65] <= 32'h22730001;
ROMDATA[66] <= 32'h1193001e;
ROMDATA[67] <= 32'h22730001;
ROMDATA[68] <= 32'h1193001e;
ROMDATA[69] <= 32'h22730001;
ROMDATA[70] <= 32'h1193001e;
ROMDATA[71] <= 32'h22730001;
ROMDATA[72] <= 32'h1193001e;
ROMDATA[73] <= 32'h22730001;
ROMDATA[74] <= 32'h1193001e;
ROMDATA[75] <= 32'h22730001;
ROMDATA[76] <= 32'h1193001e;
ROMDATA[77] <= 32'h22730001;
ROMDATA[78] <= 32'h1193001e;
ROMDATA[79] <= 32'h22730001;
ROMDATA[80] <= 32'h1193001e;
ROMDATA[81] <= 32'h22730001;
ROMDATA[82] <= 32'h1193001e;
ROMDATA[83] <= 32'h22730001;
ROMDATA[84] <= 32'h1193001e;
ROMDATA[85] <= 32'h22730001;
ROMDATA[86] <= 32'h1193001e;
ROMDATA[87] <= 32'h22730001;
ROMDATA[88] <= 32'h1193001e;
ROMDATA[89] <= 32'h22730001;
ROMDATA[90] <= 32'h1193001e;
ROMDATA[91] <= 32'h200c0071;
ROMDATA[92] <= 32'h3e00008;
ROMDATA[93] <= 32'h200c003f;
ROMDATA[94] <= 32'h3e00008;
ROMDATA[95] <= 32'h200c0006;
ROMDATA[96] <= 32'h3e00008;
ROMDATA[97] <= 32'h200c005b;
ROMDATA[98] <= 32'h3e00008;
ROMDATA[99] <= 32'h200c004f;
ROMDATA[100] <= 32'h3e00008;
ROMDATA[101] <= 32'h200c0066;
ROMDATA[102] <= 32'h3e00008;
ROMDATA[103] <= 32'h200c006d;
ROMDATA[104] <= 32'h3e00008;
ROMDATA[105] <= 32'h200c007d;
ROMDATA[106] <= 32'h3e00008;
ROMDATA[107] <= 32'h200c0007;
ROMDATA[108] <= 32'h3e00008;
ROMDATA[109] <= 32'h200c007f;
ROMDATA[110] <= 32'h3e00008;
ROMDATA[111] <= 32'h200c006f;
ROMDATA[112] <= 32'h3e00008;
ROMDATA[113] <= 32'h200c0077;
ROMDATA[114] <= 32'h3e00008;
ROMDATA[115] <= 32'h200c007c;
ROMDATA[116] <= 32'h3e00008;
ROMDATA[117] <= 32'h200c0039;
ROMDATA[118] <= 32'h3e00008;
ROMDATA[119] <= 32'h200c005e;
ROMDATA[120] <= 32'h3e00008;
ROMDATA[121] <= 32'h200c0079;
ROMDATA[122] <= 32'h3e00008;
ROMDATA[123] <= 32'h1946020;
ROMDATA[124] <= 32'hae4c0000;
ROMDATA[125] <= 32'h2251fff4;
ROMDATA[126] <= 32'h8e530000;
ROMDATA[127] <= 32'h20140002;
ROMDATA[128] <= 32'h2749825;
ROMDATA[129] <= 32'hae530000;
ROMDATA[130] <= 32'h3400008;

end
endmodule
