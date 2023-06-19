import Clocks::*;
import DefaultValue::*;
import XilinxCells::*;
import GetPut::*;
import AxiBits::*;

interface BviFixFpConvert;
    method ActionValue#(Bit#(32)) m_axis_result;
    method Action s_axis_a(Bit#(32) v);
endinterface

import "BVI" fix_float=
module mkBviFixFpConvert(BviFixFpConvert);
    default_clock aclk(aclk);
    default_reset aresetn(aresetn);
    method s_axis_a (s_axis_a_tdata)
     ready (s_axis_a_tready) enable (s_axis_a_tvalid);

    method m_axis_result_tdata m_axis_result ()
     ready (m_axis_result_tvalid) enable (m_axis_result_tready);

    schedule (s_axis_a, m_axis_result) CF
           (s_axis_a, m_axis_result);
endmodule
