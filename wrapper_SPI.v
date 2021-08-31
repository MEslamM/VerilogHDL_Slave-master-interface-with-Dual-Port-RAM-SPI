module wrapper (mosi,ss_n,clk,rst_n,miso);

input mosi,ss_n,clk,rst_n;

output miso;

wire [9:0]rx_data ;
wire rx_valid,tx_valid;
wire [7:0]tx_data;

mem_spi m5(clk,rst_n,rx_valid,rx_data,tx_data,tx_valid);
slave_SSPI m6(clk,rst_n,mosi,ss_n,tx_valid,tx_data,miso,rx_valid,rx_data);

endmodule