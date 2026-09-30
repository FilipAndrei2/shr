`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2026 12:29:36 PM
// Design Name: 
// Module Name: contor
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


module contor(
    input clk,
    input res,
    
    output reg[4:0] do
);

initial begin
    do <= 4'b0000;    
end

always@(posedge clk) begin
    if (res) begin
        do <= 4'b0000;
    end else begin
        do <= do + 4'b0001;
    end
end

endmodule
