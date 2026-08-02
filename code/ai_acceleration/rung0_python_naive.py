"""Rung 0 — naive Python. The zero of the scale.

Run at N=256 only — at N=1024 this takes the better part of a minute per
run. The script extrapolates the N=1024 time so you don't have to sit
through it.
"""
import sys

sys.path.insert(0, "common")
from harness import best_of, load_inputs, report


def matmul(A, B, n):
    C = [[0.0] * n for _ in range(n)]
    for i in range(n):
        Ai = A[i]
        Ci = C[i]
        for j in range(n):
            s = 0.0
            for k in range(n):
                s += Ai[k] * B[k][j]
            Ci[j] = s
    return C


if __name__ == "__main__":
    n = int(sys.argv[1]) if len(sys.argv) > 1 else 256
    A, B, C_ref = load_inputs(n)
    A_l, B_l = A.tolist(), B.tolist()

    seconds, C = best_of(lambda: matmul(A_l, B_l, n), reps=1)
    report("rung0_python_naive", n, seconds, C, C_ref, atol=1e-2)

    t1024 = seconds * (1024 / n) ** 3
    print(f"# extrapolated to N=1024: ~{t1024 / 60:.1f} minutes", file=sys.stderr)
