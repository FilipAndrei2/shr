`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2026 01:09:17 PM
// Design Name: 
// Module Name: tb2
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

// Test bench pt reg4_2
module tb2;
reg [0:4] dit;
reg plt;
reg clkt;
reg rest;

wire [0:4] dot;

reg4_2 uut(.clk(clkt), .pl(plt), .res(rest), .di(dit), .do(dot));

initial clkt = 1'b0;

always #5 clkt = ~clkt;

initial begin

#0
rest <= 1;

#5
rest <= 0;

#12
dit <= 4'hA;

#16
plt <= 1;

#21
plt <= 0;


end

endmodule
