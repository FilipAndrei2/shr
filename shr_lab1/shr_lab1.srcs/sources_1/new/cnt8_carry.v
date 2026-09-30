`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2026 12:37:16 PM
// Design Name: 
// Module Name: cnt8_carry
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


module cnt8_carry(
    input clk,
    input res,
    input pl,
    input inc,
    input ci,
    input [7:0]di,
    
    output reg co,
    output reg [7:0] do
    );
    
always @(posedge clk) begin
    if (res) begin
        co <= 1'b0;
        do <= 8'h00;
    end else if (pl) begin
        co <= 1'b0;
        do <= di; 
    end else if (inc && ci) begin
        co <= do[7];
        do <= do + 8'h01;
    end
end

endmodule
