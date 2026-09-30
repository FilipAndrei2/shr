`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2026 12:18:14 PM
// Design Name: 
// Module Name: reg4
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


module reg4(
        input clk,
        input[0:4] di,
        
        output reg[0:4] do
    );
    
always@(posedge clk) begin
    do <= di;
end

endmodule
