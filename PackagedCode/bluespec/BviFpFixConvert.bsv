
/*
   /home/bthom/rbd25mhz/PackagedCode/connectal/generated/scripts/importbvi.py
   -o
   BviFpFixConvert.bsv
   -c
   aclk
   -f
   s_axis_a
   -f
   m_axis_result
   -I
   BviFpFixConvert
   -P
   BviFpFixConvert
   /home/bthom/rbd25mhz/PackagedCode/connectal/out/vcu118/fp_convert/fp_convert_stub.v
*/

import Clocks::*;
import DefaultValue::*;
import XilinxCells::*;
import GetPut::*;
import AxiBits::*;

interface BviFpFixConvert;
    method ActionValue#(Bit#(32)) m_axis_result;
    method Action s_axis_a(Bit#(32) v);
endinterface

import "BVI" fp_convert=
module mkBviFpFixConvert(BviFpFixConvert);
    default_clock aclk(aclk);
    default_reset aresetn(aresetn);
    method s_axis_a (s_axis_a_tdata)
     ready (s_axis_a_tready) enable (s_axis_a_tvalid);

    method m_axis_result_tdata m_axis_result ()
     ready (m_axis_result_tvalid) enable (m_axis_result_tready);

    schedule (s_axis_a, m_axis_result) CF
           (s_axis_a, m_axis_result);
endmodule
