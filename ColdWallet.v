module ColdWallet #(parameter CLKS_PER_BIT = 87)(clk_i,btesq_i,btdir_i,btrst_i,led_o,/*,out*/);

input wire btesq_i, btdir_i,btrst_i,clk_i;
output wire led_o;
reg [255:0] key_w;

wire wenable_w;
wire [15:0] fpin_w, pinrom_w;
wire [255:0] key_w;
wire [255:0] receiver_w;
integer i;

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
always@()
begin
	for(i = 0; i < 32 ; i = i + 1) begin
		uart_rx #(CLKS_PER_BIT) rx(
			.i_Clock(clk_i),
			.i_Rx_Serial(1'b1),
			.i_Rx_DV(),
			.o_Rx_Byte(receiver_w[i*8+:8])
		);
	end
end
always@()
begin
	for(i = 0; i < 32 ; i = i + 1) begin
		uart_tx #(CLKS_PER_BIT) tx(
			.i_Clock(clk_i),
			.i_Tx_DV(wenable_w),
			.i_Tx_Byte(key_w[i*8+:8]),
			.o_Tx_Active(),
			.o_Tx_Serial(),
			.o_Tx_Done()
		);
	end
end
endmodule
