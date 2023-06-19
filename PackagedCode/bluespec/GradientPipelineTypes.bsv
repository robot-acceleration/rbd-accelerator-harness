import Vector::*;
typedef 8 Depth;
typedef 21 InputSize;
typedef 12 IntermediateSize;
typedef 6 FSize;
typedef 16 OutputSize;
typedef 7 NUM_LINKS;

typedef struct {
        Vector#(6,Bit#(32)) f;
        Vector#(6,Bit#(32)) a;
        Vector#(6,Bit#(32)) v;
        Bit#(32) qd;
        Bit#(32) cosq;
        Bit#(32) sinq;
} FPGALink1 deriving(Eq, Bits, FShow);

typedef struct {
        Bit#(32) qdd;
        Bit#(32) qd;
        Bit#(32) cosq;
        Bit#(32) sinq;
} FPGALink2 deriving(Eq, Bits, FShow);

typedef struct {
        Bit#(32) qdd;
        Bit#(32) qd;
        Bit#(32) cosq;
        Bit#(32) sinq;
} FPGALink3 deriving(Eq, Bits, FShow);



typedef struct {
        Vector#(6,Vector#(NUM_LINKS,Bit#(32))) dfidq;
        Vector#(6,Vector#(NUM_LINKS,Bit#(32))) dfidqd;
} Intermediate deriving(Eq, Bits, FShow);

typedef struct {
        Bit#(32) cosq;
        Bit#(32) sinq;
} Trigo deriving(Eq,Bits,FShow);

typedef struct {
        Vector#(6,Bit#(32)) f;
        Vector#(6,Vector#(NUM_LINKS,Bit#(32))) dfidq;
        Vector#(6,Vector#(NUM_LINKS,Bit#(32))) dfidqd;
} Intermediate2 deriving(Eq, Bits, FShow);

typedef struct {
        Vector#(6,Bit#(32)) f;
        Vector#(6,Bit#(32)) a;
        Vector#(6,Bit#(32)) v;
} RNEAIntermediate deriving(Eq, Bits, FShow);

typedef struct {
        Vector#(6,Bit#(32)) dvdq;
        Vector#(6,Bit#(32)) dadq;
        Vector#(6,Bit#(32)) dvdqd;
        Vector#(6,Bit#(32)) dadqd;
} DvDaIntermediate deriving(Eq, Bits, FShow);

typedef struct {
        Vector#(6,Bit#(32)) dfdq_upd;
        Vector#(6,Bit#(32)) dfdqd_upd;
} DfUpdIntermediate deriving(Eq, Bits, FShow);

typedef struct {
        Vector#(6,Bit#(32)) f_upd;
} FUpdIntermediate deriving(Eq, Bits, FShow);
