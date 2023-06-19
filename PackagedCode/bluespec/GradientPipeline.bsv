import GetPut::*;
import FIFO::*;
import FIFOF::*;
import ClientServer::*;
import ConnectalMemory::*;
import ConnectalConfig::*;
import ConnectalMemTypes::*;
import MemReadEngine::*;
import MemWriteEngine::*;
import Vector::*;
import IfcGradientPipeline::*;
import GradientPipelineTypes::*;
import BRAM::*;
import BRAMFIFO::*;
import BviIfcFProc_rev1::*;
import BviIfcBProc_rev2::*;
import BuildVector::*;
import Pipe::*;
import Ehr::*;
import ConvertersFixFp::*;

interface GradientPipeline;
    interface Gradient start;
    interface Vector#(1, MemReadClient#(256)) dmaReadClient;
    interface Vector#(1, MemWriteClient#(256)) dmaWriteClient;
endinterface

typedef enum {GradientStop, GradientRunning} State deriving(Eq, Bits,FShow);

module mkGradientPipeline#(GradientPipelineIndication indication)(GradientPipeline);
    // rnea_acc[0] left empty for ease of indexing
    // s/9/num_links+2 because num_links+1 is an input to bproc and is 1-indexed
    Vector#(9,Reg#(RNEAIntermediate)) rnea_acc <- replicateM(mkReg(unpack(0)));
    Vector#(8,Reg#(Trigo)) trigo_acc <- replicateM(mkReg(unpack(0))); // 1-indexed
    // s/9/num_links+2 because num_links+1 is an input to bproc and is 1-indexed
    FIFOF#(Vector#(9,Trigo)) trigo_values <- mkSizedFIFOF(4);

    // storing intermediate dfi{dq,dqd}s outputed by fproc as matrix of regs to be able to arbitrarily index into them
    // previously used to be: Vector#({num_links_incr},Reg#(Intermediate2)) intermediate_acc <- replicateM(mkReg(unpack(0)));    // 1-indexed
    // 8-array of 6-vectors
    Reg#(Vector#(8, Vector#(6, Bit#(32)))) f_inter_acc <- mkReg(unpack(0));
    // 8-array of (6x7)-matrices
    Reg#(Vector#(8, Vector#(6, Vector#(7, Bit#(32))))) dfidq_inter_acc <- mkReg(unpack(0));
    Reg#(Vector#(8, Vector#(6, Vector#(7, Bit#(32))))) dfidqd_inter_acc <- mkReg(unpack(0));

    // s/9/num_links+2 because num_links+1 is an input to bproc and is 1-indexed
    FIFOF#(Vector#(9,Intermediate2)) intermediate_values <- mkSizedFIFOF(3);

    // explicitly storing minv in queue because neither trigo nor link related quantity
    FIFOF#(Vector#(7, Vector#(7, Bit#(32)))) minv_queue <- mkSizedFIFOF(4);

    Reg#(Bit#(2560)) int_inputs <- mkReg(0);
    Reg#(Bit#(16)) inputs_counter <- mkReg(0);
    Reg#(Bit#(32)) nbP <- mkReg(64);
    FIFOF#(Vector#(8,FPGALink3)) inputs <- mkSizedFIFOF(4); // 1-indexed

    //commented to allow host-side fpconv
`ifndef HOST_FPCONV
    Server#(Vector#(8,Bit#(32)),Vector#(8,Bit#(32))) fix_fps <- mkFixFps();
    Server#(Vector#(8,Bit#(32)),Vector#(8,Bit#(32))) fp_fixs <- mkFpFixs();
`endif

    MemReadEngine#(256, 256, Depth, Depth) re <- mkMemReadEngineBuff(valueOf(Depth) * 512);
    MemWriteEngine#(256, 256, Depth, Depth)  we <- mkMemWriteEngineBuff(valueOf(Depth) * 512);

    Reg#(SGLId) rdPointer <- mkReg(0);
    Reg#(SGLId) wrPointer <- mkReg(0);
    Reg#(State) state <- mkReg(GradientStop);

    Reg#(Maybe#(Bit#(32))) read_idx_forward <- mkReg(Invalid);

    Reg#(Bit#(32)) cyc_count <- mkReg(0);

    FProc fproc <- mkFProc();
    BProc bproc <- mkBProc();

    rule tic;
        cyc_count <= cyc_count + 1;
    endrule

    rule feedInput if (read_idx_forward matches tagged Valid .s);
        if (read_idx_forward matches tagged Valid .offset) begin
            re.readServers[0].request.put(MemengineCmd{
            sglId:rdPointer,
            base: 0,
            len: 320*nbP,
            burstLen: 128,
            tag:0});
            $display("Request data for the 64 points", offset);
        read_idx_forward <= tagged Invalid;
        end
    endrule

    //commented to allow host-side fpconv

`ifndef HOST_FPCONV
    rule converFpToFix;
           let complete_input_bits <- toGet(re.readServers[0].data).get();
           //$display("Start fp to fix converison of ", fshow(complete_input_bits.data));
           fp_fixs.request.put(unpack(complete_input_bits.data));
    endrule
`endif

    Reg#(Bit#(32)) counter_input <- mkReg(0);

    Reg#(FPGALink3) zeroLink <- mkReg(unpack(0));
    Reg#(Vector#(7, Vector#(7, Bit#(32)))) zeroMinv <- mkReg(unpack(0));

    rule getInput;
`ifndef HOST_FPCONV
        let complete_input_bitspacked <- fp_fixs.response.get();
        let complete_input_bits = pack(complete_input_bitspacked);
        //$display("Receive chunk converted to fix:", fshow(complete_input_bits));
`else
        let complete_input_bitspacked <- toGet(re.readServers[0].data).get();
        let complete_input_bits = complete_input_bitspacked.data;
`endif

        Bit#(2560) new_int = (int_inputs >> 256) | (zeroExtend(complete_input_bits) << 2304); 
        //display("Current input:", fshow(new_int));
        let new_count = inputs_counter + 256;

        if (inputs_counter + 256 > 2304) begin
            //$display("Complete input received from host", fshow(counter_input));
            counter_input <= counter_input + 1;
            Vector#(7,FPGALink3) new_data = unpack(truncate(new_int));
            Vector#(8,FPGALink3) new_data_1_indexed = cons(zeroLink, new_data);
            inputs.enq(new_data_1_indexed);
            Vector#(49, Bit#(32)) sparse_minv = unpack(truncate(new_int >> 896));
            let new_minv = zeroMinv;
`include "GradientPipelineSparseToDenseMinvInput.bsv"
            $display(fshow(new_minv));
            minv_queue.enq(new_minv);
            new_count = 0; 
        end 

        int_inputs <= new_int; 
        inputs_counter <= new_count;
        $display("Chunk", fshow(new_count));
    endrule

    //*********************

    Ehr#(2,Bool) phase <- mkEhr(False);

    FIFOF#(Bit#(3136)) out_data <- mkSizedFIFOF(10);
    Reg#(Bit#(16)) gear_out <- mkReg(0);


`include "GradientPipelineFprocRules.bsv"
`include "GradientPipelineBprocRules.bsv"

    Reg#(Bit#(16)) outstanding_dma <- mkReg(0);

    rule send_writeDMA;
	      Bit#(3328) data_out = zeroExtend(out_data.first());
        Bit#(256) chunk = data_out[256*(gear_out+1)-1 : 256*(gear_out)];
        if (gear_out == 0)  begin
            we.writeServers[0].request.put(MemengineCmd{sglId: wrPointer, base: 416*offset_out, len: 416, burstLen: 64, tag:0});
            outstanding_dma <= outstanding_dma + 1;
            offset_out <= offset_out + 1;
            $display("Row number", fshow(offset_out), fshow(outstanding_dma));
            gear_out <= gear_out + 1;
        end 
        else begin
            if (gear_out == 12) begin 
                gear_out <= 0;
                out_data.deq();
                //$display("End Row:",  fshow(data_out)); 
            end
            else begin
                gear_out <= gear_out + 1;
            end
        end
        $display("Push to writeback not converted yet", fshow(chunk));  

`ifndef HOST_FPCONV
        fix_fps.request.put(unpack(chunk));
`else
        we.writeServers[0].data.enq(chunk);
`endif
    endrule

`ifndef HOST_FPCONV
    rule converFixToFp;
        let complete_input_bitspacked <- fix_fps.response.get();
        we.writeServers[0].data.enq(pack(complete_input_bitspacked));
        //$display("Fully converted and sent back ", fshow(complete_input_bitspacked));
    endrule
`endif

    Reg#(Bool) processing <- mkReg(False);
    rule finish if (offset_out == nbP && outstanding_dma == 0 && processing);
        $display("Finish");
        processing <= False;
        offset_out <= 0;
	      we.writeServers[0].request.put(MemengineCmd{sglId:wrPointer, base: 416*nbP , len: 32, burstLen:32, tag:0});
        we.writeServers[0].data.enq(0);
        outstanding_dma <= outstanding_dma + 1;
    endrule 

    rule write_done;
        let rv1 <- we.writeServers[0].done.get;
        outstanding_dma <= outstanding_dma - 1;
        $display("Request write confirmation engine ", outstanding_dma);
        //outstanding <= outstanding - 1;
    endrule

    interface Gradient start;
        method Action start64(Bit#(32) dataIn, Bit#(32) dataOut, Bit#(32) nbPoints) if (read_idx_forward == tagged Invalid && !processing);
            $display("Start a 64 Step gradient computation");
            rdPointer <= dataIn;
            processing <= True;
            wrPointer <= dataOut;
            nbP <= nbPoints; 
            read_idx_forward <= tagged Valid(0); 
        endmethod
    endinterface

    interface MemReadClient dmaReadClient = vec(re.dmaClient);
    interface MemWriteClient dmaWriteClient = vec(we.dmaClient);
endmodule

