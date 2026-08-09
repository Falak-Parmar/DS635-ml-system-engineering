/* Shared benchmark harness for the C rungs.
 *
 * Each rung defines  matmul(A, B, C, n)  and calls harness_main().
 * Contract: read data/N{n}/{A,B,C_ref}.bin, run `reps` times, take the
 * best time, verify against C_ref, print one CSV line:
 *
 *     name,N,seconds,gflops,check
 */
#ifndef HARNESS_H
#define HARNESS_H

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

typedef void (*matmul_fn)(const float *, const float *, float *, int);

static double now_sec(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return ts.tv_sec + ts.tv_nsec * 1e-9;
}

static float *load_matrix(const char *datadir, const char *name, int n) {
    char path[512];
    snprintf(path, sizeof(path), "%s/%s.bin", datadir, name);
    FILE *f = fopen(path, "rb");
    if (!f) {
        fprintf(stderr, "cannot open %s — run common/gen_inputs.py first\n", path);
        exit(1);
    }
    float *m = (float *)malloc((size_t)n * n * sizeof(float));
    if (fread(m, sizeof(float), (size_t)n * n, f) != (size_t)n * n) {
        fprintf(stderr, "short read on %s\n", path);
        exit(1);
    }
    fclose(f);
    return m;
}

static float max_abs_diff(const float *x, const float *y, int n) {
    float worst = 0.0f;
    for (long i = 0; i < (long)n * n; i++) {
        float d = fabsf(x[i] - y[i]);
        if (d > worst) worst = d;
    }
    return worst;
}

static int harness_main(const char *name, matmul_fn matmul, int argc, char **argv) {
    int n = argc > 1 ? atoi(argv[1]) : 1024;
    int reps = argc > 2 ? atoi(argv[2]) : 3;

    char datadir[256];
    snprintf(datadir, sizeof(datadir), "data/N%d", n);

    float *A = load_matrix(datadir, "A", n);
    float *B = load_matrix(datadir, "B", n);
    float *C_ref = load_matrix(datadir, "C_ref", n);
    float *C = (float *)malloc((size_t)n * n * sizeof(float));

    double best = 1e30;
    for (int r = 0; r < reps; r++) {
        memset(C, 0, (size_t)n * n * sizeof(float)); /* rungs 3+ accumulate into C */
        double t0 = now_sec();
        matmul(A, B, C, n);
        double dt = now_sec() - t0;
        if (dt < best) best = dt;
    }

    double gflops = 2.0 * n * (double)n * n / best / 1e9;
    const char *check = max_abs_diff(C, C_ref, n) < 1e-2f ? "PASS" : "FAIL";
    printf("name,N,seconds,gflops,check\n");
    printf("%s,%d,%.4f,%.2f,%s\n", name, n, best, gflops, check);

    free(A); free(B); free(C_ref); free(C);
    return strcmp(check, "PASS") != 0;
}

#endif
