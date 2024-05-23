`timescale 1ns / 1ps
`include "vsdserializer_v1.v"
module vsdserializer_v1_tb;
 
reg clk = 1'b1;
reg load = 1'b0;
reg rst_n = 1'b1;
reg[9:0] data_in = 10'd0;
wire data_out;
 
vsdserializer_v1 dut (clk, rst_n, load, data_in, data_out);
 
always begin
#2 clk = ~clk;
end
 
initial begin
#10 rst_n = 1'b0;
#10 rst_n = 1'b1;
 
#20;
 
@(posedge clk) begin
data_in = $urandom;
load = 1'b1;
end
 
#1;
 
@(posedge clk) begin
data_in = 10'd0;
load = 1'b0;
end
 
#100 $finish;
end
 
initial begin
$dumpfile("vsdserializer_v1_tb.vcd");
$dumpvars(0,vsdserializer_v1_tb);
end

endmodule
