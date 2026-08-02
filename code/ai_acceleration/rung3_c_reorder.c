/* Rung 3 — loop reorder, i-k-j. THE most important rung.
 *
 * Identical arithmetic, identical instruction count as rung 2. Only the
 * order in which memory is touched changed: the inner loop now strides
 * contiguously through both B and C.
 *
 * This is not a compute problem. It is a memory problem.
 * (The GPU version of this exact fact is memory coalescing.)
 */
#include "common/harness.h"

static void matmul(const float *A, const float *B, float *C, int n) {
    for (int i = 0; i < n; i++)
        for (int k = 0; k < n; k++) {
            float a = A[i * n + k];
            for (int j = 0; j < n; j++)
                C[i * n + j] += a * B[k * n + j];
        }
}

int main(int argc, char **argv) {
    return harness_main("rung3_c_reorder", matmul, argc, argv);
}
