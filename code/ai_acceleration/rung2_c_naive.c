/* Rung 2 — naive C, i-j-k order, single thread.
 *
 * Concept: compiled vs interpreted. Big jump over Python, and now
 * we're on hardware terms. Note the inner loop: B[k*n+j] jumps n floats
 * per step — one wasted cache line per access. Rung 3 fixes exactly this.
 */
#include "common/harness.h"

static void matmul(const float *A, const float *B, float *C, int n) {
    for (int i = 0; i < n; i++)
        for (int j = 0; j < n; j++) {
            float s = 0.0f;
            for (int k = 0; k < n; k++)
                s += A[i * n + k] * B[k * n + j];
            C[i * n + j] = s;
        }
}

int main(int argc, char **argv) {
    return harness_main("rung2_c_naive", matmul, argc, argv);
}
