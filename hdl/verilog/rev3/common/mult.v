`timescale 1ns / 1ps

// Fixed-Point Multiplier

//------------------------------------------------------------------------------
// mult Module
//------------------------------------------------------------------------------
module mult#(parameter WIDTH = 32,parameter DECIMAL_BITS = 16)(
   input  signed[(WIDTH-1):0] a_in,
   input  signed[(WIDTH-1):0] b_in,
   output signed[(WIDTH-1):0] prod_out
   );

   // internal wires and state
   wire signed[((2*WIDTH)-1):0] prod;

   // multiplication
   assign prod = a_in*b_in;
   assign prod_out = prod[((WIDTH-1)+DECIMAL_BITS):DECIMAL_BITS];

endmodule
