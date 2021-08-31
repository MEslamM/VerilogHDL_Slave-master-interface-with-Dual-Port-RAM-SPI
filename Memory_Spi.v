module mem_spi (clk,rst_n,rx_valid,din,dout,tx_valid);

parameter memdepth = 256;
parameter addr_size=8;

input clk,rst_n,rx_valid;
input [9:0] din;

output reg [addr_size-1:0] dout ;
output reg tx_valid ;

reg [addr_size-1:0] adress_write ;
reg  [addr_size-1:0] adress_read ;
integer i;

reg[addr_size-1:0]mem_spi1[memdepth-1:0];


always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
			for (i = 0; i < memdepth ; i=i+1) begin
			mem_spi1[i] <='b0;
			end
			dout <='b0;
	end
	else begin
		if (rx_valid==1) begin
			if (din[9:8]==2'b00) begin
				adress_write<=din[7:0];
			end
			else if (din[9:8]==2'b01) begin
				mem_spi1[adress_write]<=din[7:0];
			end
			else if (din[9:8]==2'b10) begin
				adress_read<=din[7:0];
			end
		end

		else if (din[9:8]==2'b11)begin
			tx_valid<=1;
			dout<=mem_spi1[adress_read];
		end

	end
end

endmodule