module vsdserializer_v1(clk, load, INPUT, OUTPUT);
input clk, load;
input [9:0] INPUT;
output reg OUTPUT;
reg [9:0] tmp;
always @(posedge clk)
begin
  if(load)
  tmp<=INPUT;
  else
  begin
  OUTPUT <= tmp[9];
  tmp <= {tmp[8:0],1'b0};
  end
end
endmodule
