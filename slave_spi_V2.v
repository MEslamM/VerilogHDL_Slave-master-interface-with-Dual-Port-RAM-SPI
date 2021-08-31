module slave_SSPI (clk,rst_n,mosi,ss_n,tx_valid,tx_data,miso,rx_valid,rx_data);

parameter [2:0]i_dle='d0;
parameter [2:0]chk_cmd='d1;
parameter [2:0]write='d2;
parameter [2:0]Read_data='d3;
parameter [2:0]Read_add='d4;

// states reg
parameter [3:0]a='d9;
parameter [3:0]b='d8;
parameter [3:0]c='d7;
parameter [3:0]d='d6;
parameter [3:0]e='d5;
parameter [3:0]f='d4;
parameter [3:0]g='d3;
parameter [3:0]h='d2;
parameter [3:0]i='d1;
parameter [3:0]j='d0;
parameter [3:0]beg='d10;


parameter [3:0]A='d7;
parameter [3:0]B='d6;
parameter [3:0]C='d5;
parameter [3:0]D='d4;
parameter [3:0]E='d3;
parameter [3:0]F='d2;
parameter [3:0]G='d1;
parameter [3:0]H='d0;
parameter [3:0]Beg2='d8;

input clk,rst_n,mosi,ss_n,tx_valid;
input [7:0] tx_data;

output reg miso,rx_valid;
output reg[9:0] rx_data;

reg [2:0]cs=i_dle;
reg [3:0]cs_parallel_series=a;
reg [2:0]ns;
reg [3:0]ns_parallel_series;
reg temp_ssn=0;

reg [3:0] cs_Mem_to_Slave=Beg2;
reg [3:0] ns_Mem_to_Slave;



always @(posedge clk) begin
	if (ss_n==0) begin

		cs_parallel_series<=ns_parallel_series;
		
	end
	
end


always @(cs_parallel_series) begin
	case(cs_parallel_series) 
		beg:begin
			ns_parallel_series=a;
		end
		a:begin
			ns_parallel_series = b;
			if (ss_n==0) begin
				rx_data[9]=mosi;
			end
		end
		b:begin
			ns_parallel_series = c;
			rx_data[8]=mosi;
		end
		c:begin
			ns_parallel_series = d;
			rx_data[7]=mosi;
		end
		d:begin
			ns_parallel_series = e;
			rx_data[6]=mosi;
		end
		e:begin
			ns_parallel_series = f;
			rx_data[5]=mosi;
		end
		f:begin
			ns_parallel_series = g;
			rx_data[4]=mosi;
		end
		g:begin
			ns_parallel_series = h;
			rx_data[3]=mosi;
		end
		h:begin
			ns_parallel_series = i;
			rx_data[2]=mosi;
		end
		i:begin
			ns_parallel_series = j;
			rx_data[1]=mosi;
		end
		j:begin
			rx_data[0]=mosi;
			temp_ssn=1;
		end

	endcase

end



//Return small when ss_n=1
always @(posedge ss_n) begin
	if (ss_n) begin
		cs_parallel_series=beg;
	end
end


//state memory(big)
always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		cs<=i_dle;
		
	end
	else begin
		cs<=ns;
	end
end

// next state Big

always @(cs,temp_ssn,ss_n) begin 
	if (temp_ssn) begin
		ns=chk_cmd;
	end
	if (cs==chk_cmd) begin
		case (rx_data[9])
		1'b0:begin
			ns=write;
			rx_valid=1;
		end
		1'b1 :begin
			if (rx_data[8]==0) begin
				ns=Read_add;
				rx_valid=1;
			end
			else begin
				ns=Read_data;
				rx_valid=0;
			end
		end
	
	endcase
	end

	if (ss_n==1) begin
		ns=i_dle;
	end
end


// tx_valid=1
//mem block memory to slave
always @(posedge clk) begin 
	if (tx_valid==1&&ss_n==0) begin
		cs_Mem_to_Slave <= ns_Mem_to_Slave;
	end
end

always @(cs_Mem_to_Slave) begin
	case(cs_Mem_to_Slave) 
		

		Beg2:begin
			ns_Mem_to_Slave = A;
			
		end
		A:begin
			ns_Mem_to_Slave = B;
			miso=tx_data[7];
		end
		B:begin
			ns_Mem_to_Slave = C;
			miso=tx_data[6];
		end
		C:begin
			ns_Mem_to_Slave = D;
			miso=tx_data[5];
		end
		D:begin
			ns_Mem_to_Slave = E;
			miso=tx_data[4];
		end
		E:begin
			ns_Mem_to_Slave = F;
			miso=tx_data[3];
		end
		F:begin
			ns_Mem_to_Slave = G;
			miso=tx_data[2];
		end
		G:begin
			ns_Mem_to_Slave = H;
			miso=tx_data[1];
		end
		H:begin
			miso=tx_data[0];
		end
		


	endcase

end


endmodule 