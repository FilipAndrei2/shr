`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2026 12:43:11 PM
// Design Name: 
// Module Name: rshr
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


module rshr(
    input clk,
    input si,
    
    output reg so,
    output reg [7:0] do
    );
    
    initial begin
        do <= 8'h00;
    end 
    
    always @(posedge clk) begin
        so <= do[0];
        do <= { si, do[7:1] };
    end
    
endmodule
