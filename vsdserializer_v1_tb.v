`timescale 1ns / 1ps
`include "vsdserializer_v1.v"
module vsdserializer_v1_tb();
reg clk,load;
reg[9:0] INPUT;
wire OUTPUT;
vsdserializer_v1 dut (clk, load, INPUT, OUTPUT);
initial begin
 clk = 1;
 INPUT = $urandom;
 load = 1;
 #30 load = 0;
 #120 INPUT = $urandom;
load = 1;
#30 load = 0;
#120 INPUT = $urandom;
load = 1;
#30 load = 0;
end
always #50 clk = ~clk;
initial begin
$dumpfile("vsdserializer_v1_tb.vcd");
$dumpvars(0,vsdserializer_v1_tb);
#900 $finish;
end
endmodule
