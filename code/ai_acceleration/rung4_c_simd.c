/* Rung 4 — SIMD via compiler auto-vectorization.
 *
 * Same reordered i-k-j loop as rung 3. The only change is how it's
 * COMPILED: rungs 2-3 are built with vectorization disabled; this file
 * gets -O3 -march=native -ffast-math and the compiler turns the inner
 * loop into AVX2: one instruction, 8 float lanes.
 *
 * In effect this is a warp with 8 lanes instead of 32 — and no
 * scheduler to hide latency. Half of SIMT, before ever touching a GPU.
 *
 * RUN THIS AT N=1024 AND N=2048 and compare GFLOP/s. At 1024, B fits in
 * L3 and SIMD flies. At 2048 it doesn't — throughput collapses. You just
 * raised the compute roof high enough to slam into the memory wall.
 * Rung 5 is the escape.
 */
#include "common/harness.h"

static void matmul(const float *restrict A, const float *restrict B,
                   float *restrict C, int n) {
    for (int i = 0; i < n; i++)
        for (int k = 0; k < n; k++) {
            float a = A[i * n + k];
            for (int j = 0; j < n; j++)
                C[i * n + j] += a * B[k * n + j];
        }
}

static void matmul_wrap(const float *A, const float *B, float *C, int n) {
    matmul(A, B, C, n);
}

int main(int argc, char **argv) {
    return harness_main("rung4_c_simd", matmul_wrap, argc, argv);
}
