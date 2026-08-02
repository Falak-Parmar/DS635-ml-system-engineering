/* Rung 6 — multithreading with OpenMP.
 *
 * Tiled + vectorized + all cores. Scales roughly with core count — and
 * now we're within a small factor of BLAS: you have just reconstructed
 * a real library.
 *
 * This is the CPU ceiling. All remaining gains would need more cores,
 * and cores are expensive in area and power.
 */
#include "common/harness.h"

#ifndef T
#define T 128
#endif

static void matmul(const float *restrict A, const float *restrict B,
                   float *restrict C, int n) {
#pragma omp parallel for schedule(static)
    for (int ii = 0; ii < n; ii += T)
        for (int kk = 0; kk < n; kk += T)
            for (int jj = 0; jj < n; jj += T)
                for (int i = ii; i < ii + T; i++)
                    for (int k = kk; k < kk + T; k++) {
                        float a = A[i * n + k];
                        for (int j = jj; j < jj + T; j++)
                            C[i * n + j] += a * B[k * n + j];
                    }
}

static void matmul_wrap(const float *A, const float *B, float *C, int n) {
    if (n % T != 0) {
        fprintf(stderr, "rung6 requires N %% T == 0 (N=%d, T=%d)\n", n, T);
        exit(1);
    }
    matmul(A, B, C, n);
}

int main(int argc, char **argv) {
    return harness_main("rung6_c_openmp", matmul_wrap, argc, argv);
}
