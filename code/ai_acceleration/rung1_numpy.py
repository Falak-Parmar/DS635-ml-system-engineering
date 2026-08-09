"""Rung 1 — NumPy. The "wait, what?" moment.

One line. Three orders of magnitude faster than rung 0. Before reading on,
try to answer: how? The answer: `@` dispatches to a BLAS library —
blocked, vectorized, multithreaded. Everything the next rungs build by
hand, someone already built.
"""
import sys

sys.path.insert(0, "common")
from harness import best_of, load_inputs, report

if __name__ == "__main__":
    n = int(sys.argv[1]) if len(sys.argv) > 1 else 1024
    A, B, C_ref = load_inputs(n)

    # NumPy BLAS implementation
    seconds, C = best_of(lambda: A @ B, reps=3)
    report("rung1_numpy", n, seconds, C, C_ref)
