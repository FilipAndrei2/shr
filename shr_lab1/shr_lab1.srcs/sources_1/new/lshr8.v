`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2026 12:46:45 PM
// Design Name: 
// Module Name: lshr8
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


module lshr8(
    input clk,
    input si,
    
    output reg so,
    output reg [7:0] do
);

initial begin
    so <= 1'b0;
    do <= 8'h00;
end

always@(posedge clk) begin
    so <= do[7];
    do <= { do[6:0], si };
end

endmodule
