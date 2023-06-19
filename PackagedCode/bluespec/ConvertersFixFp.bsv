
import BviFpFixConvert::*;
import BviFixFpConvert::*;
import Vector::*;
import ClientServer::*;
import GetPut::*;

module mkFpToFix(Server#(Bit#(32), Bit#(32)));
   let fpfix <- mkBviFpFixConvert();

   interface Put request;
     method Action put(Bit#(32) req);
       fpfix.s_axis_a(req);
     endmethod
   endinterface

   interface Get response = toGet(fpfix.m_axis_result);
endmodule

module mkFixToFp(Server#(Bit#(32), Bit#(32)));
   let fixfp <- mkBviFixFpConvert();

   interface Put request;
     method Action put(Bit#(32) req);
       fixfp.s_axis_a(req);
     endmethod
   endinterface

   interface Get response = toGet(fixfp.m_axis_result);
endmodule

module mkFpFixs(Server#(Vector#(8,Bit#(32)),Vector#(8,Bit#(32))));
  Vector#(8, Server#(Bit#(32),Bit#(32))) fp_fixs <- replicateM(mkFpToFix());

   interface Put request;
    method Action put(Vector#(8,Bit#(32)) req);
      for (Integer i = 0; i<8; i=i+1) begin
        fp_fixs[i].request.put(req[i]);
      end
    endmethod
   endinterface

  interface Get response;
    method ActionValue#(Vector#(8,Bit#(32))) get();
      Vector#(8,Bit#(32)) res;
      for (Integer i = 0; i<8; i=i+1) begin
        res[i] <- fp_fixs[i].response.get();
      end
      return res;
    endmethod
  endinterface 
endmodule

// THIS LAST ONE IS COPY PASTED FROM THE PREVIOUS ONE OUTSIDE OF THE MODULE
module mkFixFps(Server#(Vector#(8,Bit#(32)),Vector#(8,Bit#(32))));
  Vector#(8, Server#(Bit#(32),Bit#(32))) fp_fixs <- replicateM(mkFixToFp());

   interface Put request;
    method Action put(Vector#(8,Bit#(32)) req);
      for (Integer i = 0; i<8; i = i+ 1) begin
        fp_fixs[i].request.put(req[i]);
      end
    endmethod
   endinterface

  interface Get response;
    method ActionValue#(Vector#(8,Bit#(32))) get();
      Vector#(8,Bit#(32)) res;
      for (Integer i = 0; i<8; i=i+1) begin
        res[i] <- fp_fixs[i].response.get();
      end
      return res;
    endmethod
  endinterface 
endmodule


