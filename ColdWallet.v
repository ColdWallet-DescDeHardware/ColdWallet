module ColdWallet #(parameter CLKS_PER_BIT=87)(clk_i, btesq_i, btdir_i, btrst_i, led_o, bit_o/*,out*/);

input wire btesq_i, btdir_i,btrst_i,clk_i;
output wire led_o;
wire [255:0] key_w;

wire wenable_w;
wire [15:0] fpin_w, pinrom_w;

wire [7:0] data_w [31:0];
reg  [7:0] data_o;
output wire bit_o;
integer counter = 0;

pin PIN(
	.w_o(wenable_w),
	.b_esq_i(btesq_i),
	.b_dir_i(btdir_i),
	.pin_vec_i(fpin_w),
	.pin_vec_o(pinrom_w)
);

rom ROM(
	.clk_i(clk_i),
	.pin_i(pinrom_w),
	.rst_i(btrst_i),
	.wenable_i(wenable_w),
	.pin_o(fpin_w),
	.led1_o(led_o)
);

AES AES(
	.dec_o(key_w)
);

genvar j;
generate
	for(j = 0; j < 32;j = j + 1) begin: separar
		assign  data_w[j][7:0] = key_w[j*8+:8];
	end
endgenerate
	

always@(posedge clk_i)
begin 
	counter = counter + 1; 
	case(counter)
		1:data_o = data_w[0]; 
		2:data_o = data_w[1];
		3:data_o = data_w[2];
		4:data_o = data_w[3];
		5:data_o = data_w[4];
		6:data_o = data_w[5];
		7:data_o = data_w[6];
		8:data_o = data_w[7];
		9:data_o = data_w[8];
		10:data_o = data_w[9];
		11:data_o = data_w[10];
		12:data_o = data_w[11];
		13:data_o = data_w[12];
		14:data_o = data_w[13];
		15:data_o = data_w[14];
		16:data_o = data_w[15];
		17:data_o = data_w[16];
		18:data_o = data_w[17];
		19:data_o = data_w[18];
		20:data_o = data_w[19];
		21:data_o = data_w[20];
		22:data_o = data_w[21];
		23:data_o = data_w[22];
		24:data_o = data_w[23];
		25:data_o = data_w[24];
		26:data_o = data_w[25];
		27:data_o = data_w[26];
		28:data_o = data_w[27];
		29:data_o = data_w[28];
		30:data_o = data_w[29];
		31:data_o = data_w[30];
		32:data_o = data_w[31];
endcase

end

	Transmitter #(87) tx(
		.i_Clock(clk_i),
		.i_Tx_DV(/*wenable_w*/1'b1),
		.i_Tx_Byte(8'h55),
		.o_Tx_Active(),
		.o_Tx_Serial(bit_o),
		.o_Tx_Done()
	);



/*
	Transmitter #(87) tx(
		.i_Clock(clk_i),
		.i_Tx_DV(1'b1),
		.i_Tx_Byte(data_o[7:0]),
		.o_Tx_Active(),
		.o_Tx_Serial(bit_o),
		.o_Tx_Done()
	);
*/
endmodule
