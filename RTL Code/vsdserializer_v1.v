module vsdserializer_v1
(
input clk,
input rst_n,
input load,
input [9:0] data_in,
output data_out
);
 
reg [9:0] tmp;
 
assign data_out = tmp[9];

always @(posedge clk or negedge rst_n) begin
if(~rst_n) begin
tmp <= 10'd0;
end else if (load) begin
tmp <= data_in;
end else begin
tmp<= {tmp[8:0],1'b0};
end
end
 
endmodule
