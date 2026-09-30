`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2026 01:04:04 PM
// Design Name: 
// Module Name: lshr9
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


module lshr9(
    input clk,
    input pl,
    input res,
    input [7:0] di,
    
    output reg [7:0] do
    );
    
always @(posedge clk) begin
    if (res) begin
        do <= 8'h00;
    end if (pl) begin
        do <= di;
    end else begin
        // shiftare
        do <= { do[6:0], do[7] };
    end
end

endmodule
