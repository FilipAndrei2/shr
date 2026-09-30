`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2026 12:20:50 PM
// Design Name: 
// Module Name: reg4_2
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


module reg4_2(
    input [0:4] di,
    input pl,
    input clk,
    input res,
    
    output reg[0:4] do
    );
    
always @ (posedge clk) begin
    if (res) begin
        do <= 4'b0000;
    end else if (pl) begin 
        do <= di;
    end else begin
        do <= do;
    end
end

endmodule
