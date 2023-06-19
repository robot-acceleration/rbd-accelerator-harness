#include "Gradient.h"
#include "dmaManager.h"
#include "GradientPipelineIndication.h"
#include "FPGATypes.h"

#ifndef NUM_LINKS
    #define NUM_LINKS 7
#endif
#ifndef N_SPARSE_MINV_ENTRIES
    #define N_SPARSE_MINV_ENTRIES 49
#endif

unsigned int localfpgaOutPt10;
unsigned int localfpgaInPt10;
unsigned int localfpgaOutPt16;
unsigned int localfpgaInPt16;
unsigned int localfpgaOutPt32;
unsigned int localfpgaInPt32;
unsigned int localfpgaOutPt64;
unsigned int localfpgaInPt64;
unsigned int localfpgaOutPt128;
unsigned int localfpgaInPt128;
unsigned int localfpgaOutPt256;
unsigned int localfpgaInPt256;

FPGADataIn<10,NUM_LINKS,N_SPARSE_MINV_ENTRIES> *localdataIn10;
FPGADataOut<10,N_SPARSE_MINV_ENTRIES> *localdataOut10;
FPGADataIn<16,NUM_LINKS,N_SPARSE_MINV_ENTRIES> *localdataIn16;
FPGADataOut<16,N_SPARSE_MINV_ENTRIES> *localdataOut16;
FPGADataIn<32,NUM_LINKS,N_SPARSE_MINV_ENTRIES> *localdataIn32;
FPGADataOut<32,N_SPARSE_MINV_ENTRIES> *localdataOut32;
FPGADataIn<64,NUM_LINKS,N_SPARSE_MINV_ENTRIES> *localdataIn64;
FPGADataOut<64,N_SPARSE_MINV_ENTRIES> *localdataOut64;
FPGADataIn<128,NUM_LINKS,N_SPARSE_MINV_ENTRIES> *localdataIn128;
FPGADataOut<128,N_SPARSE_MINV_ENTRIES> *localdataOut128;
FPGADataIn<256,NUM_LINKS,N_SPARSE_MINV_ENTRIES> *localdataIn256;
FPGADataOut<256,N_SPARSE_MINV_ENTRIES> *localdataOut256;

char *localDataIn[6];
char *localDataOut[6];
extern "C" {
void connectal_setup();
void perform_points(unsigned int points);
}
class GradientPipelineIndication: public GradientPipelineIndicationWrapper
{
    public:
    void done() {
            printf("Done\n");
    }
    GradientPipelineIndication(unsigned int id) : GradientPipelineIndicationWrapper(id) {
    }
};
GradientProxy *fpga;
DmaManager *dma;
GradientPipelineIndication *gradientPipelineIndication;

extern "C" void connectal_setup() {
  printf("Allocate memory for communication with the FPGA\n");
  fflush(stdout);
  
  fpga = new GradientProxy(IfcNames_GradientS2H);
  fflush(stdout);
 
  dma  = platformInit();
  printf("Init the dma\n");
  fflush(stdout);
 
  gradientPipelineIndication = new GradientPipelineIndication(IfcNames_GradientPipelineIndicationH2S);
  printf("Init the indication\n");
  fflush(stdout);
 
  {
    size_t dataIn_size = sizeof(FPGADataIn<10,NUM_LINKS,N_SPARSE_MINV_ENTRIES>);
    size_t dataOut_size = sizeof(FPGADataOut<10,N_SPARSE_MINV_ENTRIES>);
    printf("datain: %d\n", dataIn_size);
    int dataIn_desc	= portalAlloc(dataIn_size ,0);
    int dataOut_desc	= portalAlloc(dataOut_size,0);
    printf("PortalAlloc\n");
    fflush(stdout);
    localdataIn10		= (FPGADataIn<10,NUM_LINKS,N_SPARSE_MINV_ENTRIES>*) portalMmap(dataIn_desc,dataIn_size);
    localdataOut10	= (FPGADataOut<10,N_SPARSE_MINV_ENTRIES>*) portalMmap(dataOut_desc,dataOut_size);

    printf("PortalMmap\n");
    fflush(stdout);
    localfpgaInPt10  = dma->reference(dataIn_desc);
    localfpgaOutPt10 = dma->reference(dataOut_desc);
    printf("Dma reference\n");
    fflush(stdout);
  }
  {
    size_t dataIn_size = sizeof(FPGADataIn<16,NUM_LINKS,N_SPARSE_MINV_ENTRIES>);
    size_t dataOut_size = sizeof(FPGADataOut<16,N_SPARSE_MINV_ENTRIES>);
    int dataIn_desc	= portalAlloc(dataIn_size ,0);
    int dataOut_desc	= portalAlloc(dataOut_size,0);
    localdataIn16		= (FPGADataIn<16,NUM_LINKS,N_SPARSE_MINV_ENTRIES>*) portalMmap(dataIn_desc,dataIn_size);
    localdataOut16	= (FPGADataOut<16,N_SPARSE_MINV_ENTRIES>*) portalMmap(dataOut_desc,dataOut_size);
    localfpgaInPt16  = dma->reference(dataIn_desc);
    localfpgaOutPt16 = dma->reference(dataOut_desc);
  }
  {
    size_t dataIn_size = sizeof(FPGADataIn<32,NUM_LINKS,N_SPARSE_MINV_ENTRIES>);
    size_t dataOut_size = sizeof(FPGADataOut<32,N_SPARSE_MINV_ENTRIES>);
    int dataIn_desc	= portalAlloc(dataIn_size, 0);
    int dataOut_desc	= portalAlloc(dataOut_size, 0);
    localdataIn32		= (FPGADataIn<32,NUM_LINKS,N_SPARSE_MINV_ENTRIES>*) portalMmap(dataIn_desc,dataIn_size);
    localdataOut32	= (FPGADataOut<32,N_SPARSE_MINV_ENTRIES>*) portalMmap(dataOut_desc,dataOut_size);
    localfpgaInPt32  = dma->reference(dataIn_desc);
    localfpgaOutPt32 = dma->reference(dataOut_desc);
  }
  {
    size_t dataIn_size = sizeof(FPGADataIn<64,NUM_LINKS,N_SPARSE_MINV_ENTRIES>);
    size_t dataOut_size = sizeof(FPGADataOut<64,N_SPARSE_MINV_ENTRIES>);
    int dataIn_desc	= portalAlloc(dataIn_size ,0);
    int dataOut_desc	= portalAlloc(dataOut_size,0);
    localdataIn64		= (FPGADataIn<64,NUM_LINKS,N_SPARSE_MINV_ENTRIES>*) portalMmap(dataIn_desc,dataIn_size);
    localdataOut64	= (FPGADataOut<64,N_SPARSE_MINV_ENTRIES>*) portalMmap(dataOut_desc,dataOut_size);
    localfpgaInPt64  = dma->reference(dataIn_desc);
    localfpgaOutPt64 = dma->reference(dataOut_desc);
  }
  {
    size_t dataIn_size = sizeof(FPGADataIn<128,NUM_LINKS,N_SPARSE_MINV_ENTRIES>);
    size_t dataOut_size = sizeof(FPGADataOut<128,N_SPARSE_MINV_ENTRIES>);
    int dataIn_desc	= portalAlloc(dataIn_size ,0);
    int dataOut_desc	= portalAlloc(dataOut_size,0);
    localdataIn128		= (FPGADataIn<128,NUM_LINKS,N_SPARSE_MINV_ENTRIES>*) portalMmap(dataIn_desc,dataIn_size);
    localdataOut128	= (FPGADataOut<128,N_SPARSE_MINV_ENTRIES>*) portalMmap(dataOut_desc,dataOut_size);
    localfpgaInPt128  = dma->reference(dataIn_desc);
    localfpgaOutPt128 = dma->reference(dataOut_desc);
  }
  {
    size_t dataIn_size = sizeof(FPGADataIn<256,NUM_LINKS,N_SPARSE_MINV_ENTRIES>);
    size_t dataOut_size = sizeof(FPGADataOut<256,N_SPARSE_MINV_ENTRIES>);
    int dataIn_desc	= portalAlloc(dataIn_size ,0);
    int dataOut_desc	= portalAlloc(dataOut_size,0);
    localdataIn256		= (FPGADataIn<256,NUM_LINKS,N_SPARSE_MINV_ENTRIES>*) portalMmap(dataIn_desc,dataIn_size);
    localdataOut256	= (FPGADataOut<256,N_SPARSE_MINV_ENTRIES>*) portalMmap(dataOut_desc,dataOut_size);
    localfpgaInPt256  = dma->reference(dataIn_desc);
    localfpgaOutPt256 = dma->reference(dataOut_desc);
  }
//  localDataIn[0] = (char*) localdataIn10;
//  localDataOut[0] = (char*) localdataOut10;
//  localDataIn[1] = (char*) localdataIn16;
//  localDataOut[1] = (char*) localdataOut16;
//  localDataIn[2] = (char*) localdataIn32;
//  localDataOut[2] = (char*) localdataOut32;
//  localDataIn[3] = (char*) localdataIn64;
//  localDataOut[3] = (char*) localdataOut64;
//  localDataIn[4] = (char*) localdataIn128;
//  localDataOut[4] = (char*) localdataOut128;
//  localDataIn[5] = (char*) localdataIn256;
//  localDataOut[5] = (char*) localdataOut256;
}


void connectallWrapper_3(GradientProxy *fpga, unsigned int fpgaInPt, unsigned int fpgaOutPt, unsigned int points) { fpga->start64(fpgaInPt, fpgaOutPt, points);}

extern "C" void perform_points(unsigned int points){

  switch (points) {
  case 10:
	  {
	    localdataOut10->flag = 0xDEADBEEFDEADBEEF;
	    std::atomic_thread_fence(std::memory_order_seq_cst);
	    connectallWrapper_3(fpga, localfpgaInPt10,localfpgaOutPt10, 10);
	    volatile uint64_t *peek = (uint64_t*) &(localdataOut10->flag);
	    while(peek[0] == 0xDEADBEEFDEADBEEF) std::atomic_thread_fence(std::memory_order_seq_cst);
	  }
	  break;
  case 16:
    {
      localdataOut16->flag = 0xDEADBEEFDEADBEEF;
      std::atomic_thread_fence(std::memory_order_seq_cst);
      connectallWrapper_3(fpga, localfpgaInPt16,localfpgaOutPt16, 16);
      volatile uint64_t *peek = (uint64_t*) &localdataOut16->flag;
      while(peek[0] == 0xDEADBEEFDEADBEEF) std::atomic_thread_fence(std::memory_order_seq_cst);
    }
  break;
  case 32:
    {
      localdataOut32->flag = 0xDEADBEEFDEADBEEF;
      std::atomic_thread_fence(std::memory_order_seq_cst);
      connectallWrapper_3(fpga, localfpgaInPt32,localfpgaOutPt32, 32);
      volatile uint64_t *peek = (uint64_t*) &localdataOut32->flag;
      while(peek[0] == 0xDEADBEEFDEADBEEF) std::atomic_thread_fence(std::memory_order_seq_cst);
    }
  break;

  case 64:
    {
      localdataOut64->flag = 0xDEADBEEFDEADBEEF;
      std::atomic_thread_fence(std::memory_order_seq_cst);
      connectallWrapper_3(fpga, localfpgaInPt64,localfpgaOutPt64, 64);
      volatile uint64_t *peek = (uint64_t*) &localdataOut64->flag;
      while(peek[0] == 0xDEADBEEFDEADBEEF) std::atomic_thread_fence(std::memory_order_seq_cst);
    }
  break;

  case 128:
    {
      localdataOut128->flag = 0xDEADBEEFDEADBEEF;
      std::atomic_thread_fence(std::memory_order_seq_cst);
      connectallWrapper_3(fpga, localfpgaInPt128,localfpgaOutPt128, 128);
      volatile uint64_t *peek = (uint64_t*) &localdataOut128->flag;
      while(peek[0] == 0xDEADBEEFDEADBEEF) std::atomic_thread_fence(std::memory_order_seq_cst);
    }
  break;

  case 256:
    {
      localdataOut256->flag = 0xDEADBEEFDEADBEEF;
      std::atomic_thread_fence(std::memory_order_seq_cst);
      connectallWrapper_3(fpga, localfpgaInPt256,localfpgaOutPt256, 256);
      volatile uint64_t *peek = (uint64_t*) &localdataOut256->flag;
      while(peek[0] == 0xDEADBEEFDEADBEEF) std::atomic_thread_fence(std::memory_order_seq_cst);
    }
    break;
  }
}


