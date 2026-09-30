`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2026 12:23:25 PM
// Design Name: 
// Module Name: reg4_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module reg4_tb;
    reg clkt;
    reg[3:0] dit;
    reg [4:0] dot;
    reg4 reg4_inst(.clk(clkt), .di(dit), .do(dot));
    
initial begin
    clkt = 0;
    dit <= 4'b0000;
    
    #12
    dit <= 4'b1010;
    
    #25
    dit <= 4'b1111;
end
   
always #5 clkt = ~clkt;

endmodule
