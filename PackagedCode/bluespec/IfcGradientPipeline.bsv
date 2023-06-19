interface Gradient;
    method Action start64(Bit#(32) dataIn, Bit#(32) dataOut, Bit#(32) nbP);
endinterface

// HW to Sw
interface GradientPipelineIndication;
    method Action done();
endinterface
