module nios_ii_tb(clk,loc,alu_output);
input loc,alu_output;
output clk;
reg clk = 0;
wire[31:0] loc,alu_ouput;

nios_ii lol(.clk(clk),.loc(loc),.alu_output(alu_output));
always
begin
#5
clk = ~clk;
end
endmodule