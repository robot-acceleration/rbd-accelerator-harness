#define FIXED_DECIMAL_BITS 16

#ifndef NUM_LINKS
    #define NUM_LINKS 7
#endif
#ifndef N_SPARSE_MINV_ENTRIES
    #define N_SPARSE_MINV_ENTRIES 49
#endif

// Return the smallest multiple N of y such that:
// //   x <= y * N
#define CEILING(x,y) (((x) + (y) - 1) / (y))

template <typename T>
int convertToFixed(T input){return static_cast<int>(std::round(input*(1 << FIXED_DECIMAL_BITS)));}

template <typename T>
T convertFromFixed(int input){return static_cast<T>(input)/static_cast<T>(1 << FIXED_DECIMAL_BITS);}

template <int NUM_LINKS_TEMPL = NUM_LINKS,
         int N_SPARSE_MINV_ENTRIES_TEMPL = N_SPARSE_MINV_ENTRIES>
constexpr int FPGAKnotIn_zero_padding() {
    //int FPGAKnotIn_raw_size = (4*NUM_LINKS_TEMPL+N_SPARSE_MINV_ENTRIES)*4
    //const int bus_width_bytes = 32;
    //int smallest_mul_N = CEILING(FPGAKnotIn_raw_size, bus_width_bytes);
    //int zero_padding_in_bytes = bus_width_bytes * smallest_mul_N - FPGAKnotIn_raw_size;
    //return zero_padding_in_bytes;
    // C++11 doesn't let constexpr have more than one statement, apart from a single return
    // Pinocchio isn't happy with anything other than C++11
    return (32 * CEILING((4*NUM_LINKS_TEMPL+N_SPARSE_MINV_ENTRIES_TEMPL)*4, 32) - (4*NUM_LINKS_TEMPL+N_SPARSE_MINV_ENTRIES_TEMPL)*4);
}

template <int N_SPARSE_MINV_ENTRIES_TEMPL = N_SPARSE_MINV_ENTRIES>
constexpr size_t FPGAKnotOut_zero_padding() {
    //size_t FPGAKnotOut_raw_size = N_SPARSE_MINV_ENTRIES_TEMPL*2*4;
    //const int bus_width_bytes = 32;
    //size_t smallest_mul_N = CEILING(FPGAKnotOut_raw_size, bus_width_bytes);
    //size_t zero_padding_in_bytes = bus_width_bytes * smallest_mul_N - FPGAKnotOut_raw_size;
    //return zero_padding_in_bytes;
    return (32 * CEILING(N_SPARSE_MINV_ENTRIES_TEMPL*2*4, 32)) - (N_SPARSE_MINV_ENTRIES_TEMPL*2*4);
}

int32_t fake_cast(float v) {
	float input = v;
	return *((int32_t*) &input);
}

float fake_cast2(int32_t v) {
	int32_t input = v;
	return *((float*) &input);
}


template <int NUM_LINKS_TEMPL = NUM_LINKS>
struct FPGALinkIn {
	int32_t sinq;
	int32_t cosq;
	int32_t qd;
	int32_t qdd;
};

template <int NUM_LINKS_TEMPL = NUM_LINKS,
         int N_SPARSE_MINV_ENTRIES_TEMPL = N_SPARSE_MINV_ENTRIES>
struct FPGAKnotIn{
	FPGALinkIn<NUM_LINKS_TEMPL> links[NUM_LINKS_TEMPL];
	int32_t minv[N_SPARSE_MINV_ENTRIES_TEMPL];
	int8_t zero_padding[FPGAKnotIn_zero_padding<NUM_LINKS_TEMPL, N_SPARSE_MINV_ENTRIES_TEMPL>()];
};

template <int KNOT_POINTS = 64, 
         int NUM_LINKS_TEMPL = NUM_LINKS,
         int N_SPARSE_MINV_ENTRIES_TEMPL = N_SPARSE_MINV_ENTRIES>
struct FPGADataIn{
	FPGAKnotIn<NUM_LINKS_TEMPL, N_SPARSE_MINV_ENTRIES_TEMPL> knots[KNOT_POINTS];
	uint32_t flag;
};

template <int N_SPARSE_MINV_ENTRIES_TEMPL = N_SPARSE_MINV_ENTRIES>
struct FPGAKnotOut{
	int32_t cdq[N_SPARSE_MINV_ENTRIES_TEMPL];
	int32_t cdqd[N_SPARSE_MINV_ENTRIES_TEMPL];
	int8_t zero_padding[FPGAKnotOut_zero_padding<N_SPARSE_MINV_ENTRIES_TEMPL>()];
};

template <int KNOT_POINTS = 64,
         int N_SPARSE_MINV_ENTRIES_TEMPL = N_SPARSE_MINV_ENTRIES>
struct FPGADataOut{
	FPGAKnotOut<N_SPARSE_MINV_ENTRIES_TEMPL> knots[KNOT_POINTS];
	uint64_t flag;
};
