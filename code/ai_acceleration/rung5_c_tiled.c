/* Rung 5 — tiling / cache blocking. Arithmetic intensity, by name.
 *
 * A TxT tile loads 3T^2 floats and does 2T^3 FLOPs — reuse scales with T.
 * Choose T so the working tiles fit in cache.
 *
 * Order matters: tiling did NOTHING at rung 3's scalar speeds (the code
 * was compute-bound — try it). It pays off exactly when rung 4's SIMD
 * made the code memory-bound. Optimizations only help on the bottleneck.
 *
 * (The GPU version of this is shared-memory tiling — and there it's
 * manual, because the GPU has no automatic cache to hope for.)
 *
 * Two knobs to play with:
 *   - T (make T=64 / T=128 / T=256): find your cache's sweet spot.
 *   - The inner-loop bounds are guard-free, which REQUIRES N % T == 0.
 *     Add "&& j < n" back and watch the compiler quietly stop
 *     vectorizing — a bounds check in the hot loop costs 3x. (See the
 *     lab exercises in the README.)
 */
#include "common/harness.h"

#ifndef T
#define T 128
#endif

static void matmul(const float *restrict A, const float *restrict B,
                   float *restrict C, int n) {          // restrict → SIMD (no-alias guarantee)
    for (int ii = 0; ii < n; ii += T)
        for (int kk = 0; kk < n; kk += T)
            for (int jj = 0; jj < n; jj += T)           // tile loops → TEMPORAL (working set fits in cache)
                for (int i = ii; i < ii + T; i++)
                    for (int k = kk; k < kk + T; k++) {
                        float a = A[i * n + k];          // TEMPORAL (register): reused T times below
                        for (int j = jj; j < jj + T; j++)
                            C[i * n + j] += a * B[k * n + j];
                            // ^ SPATIAL: stride-1 on B and C   ^ SIMD: broadcast-a FMA, independent lanes
                    }
}

static void matmul_wrap(const float *A, const float *B, float *C, int n) {
    if (n % T != 0) {
        fprintf(stderr, "rung5 requires N %% T == 0 (N=%d, T=%d)\n", n, T);
        exit(1);
    }
    matmul(A, B, C, n);
}

int main(int argc, char **argv) {
    return harness_main("rung5_c_tiled", matmul_wrap, argc, argv);
}
