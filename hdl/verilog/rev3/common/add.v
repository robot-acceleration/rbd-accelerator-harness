`timescale 1ns / 1ps

// Fixed-Point Adder

//------------------------------------------------------------------------------
// add Module
//------------------------------------------------------------------------------
module add#(parameter WIDTH = 32,parameter DECIMAL_BITS = 16)(
   input  signed[(WIDTH-1):0] a_in,
   input  signed[(WIDTH-1):0] b_in,
   output signed[(WIDTH-1):0] sum_out
   );

   // addition
   assign sum_out = a_in+b_in;

endmodule
