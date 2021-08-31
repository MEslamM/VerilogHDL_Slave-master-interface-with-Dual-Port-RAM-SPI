module MASTER ();

reg mosi,ss_n,clk,rst_n;
wire miso;
integer i;

wrapper m9(mosi,ss_n,clk,rst_n,miso);

initial begin
clk=0;
	forever
	#1 clk=~clk;
end


initial begin
rst_n=0;
ss_n=1;
#51
rst_n=1;
ss_n=0;
//operation 1
mosi=0;
#2
mosi=0;
#2
mosi=0;
#2
mosi=0;
#2
mosi=0;
#2
mosi=0;
#2
mosi=0;
#2
mosi=0;
#2
mosi=0;
#2
mosi=1;
#2
ss_n=1;
#10
//operation 2
ss_n=0;
mosi=0;
#2
mosi=1;
// data in
#2
mosi=1;
#2
mosi=0;
#2
mosi=1;
#2
mosi=0;
#2
mosi=1;
#2
mosi=0;
#2
mosi=1;
#2
mosi=0;
//operation 3
#2
ss_n=1;
#10
ss_n=0;
mosi=1;
#2
mosi=0;
#2
mosi=0;
#2
mosi=0;
#2
mosi=0;
#2
mosi=0;
#2
mosi=0;
#2
mosi=0;
#2
mosi=0;
#2
mosi=1;
#2
ss_n=1;
#10
//operation 4
ss_n=0;
mosi=1;
#2
mosi=1;
#2
mosi=0;
#2
mosi=1;
#2
mosi=1;
#2
mosi=0;
#2
mosi=1;
#2
mosi=1;
#2
mosi=1;
#2
mosi=0;
#50
ss_n=1;
#50;
$stop;

end
endmodule




