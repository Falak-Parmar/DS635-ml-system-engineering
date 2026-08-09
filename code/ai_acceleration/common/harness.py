"""Shared benchmark harness for the Python rungs.

Same contract as harness.h: load data/N{n}, best-of-reps timing, check
against C_ref, print one CSV line: name,N,seconds,gflops,check.
"""
import os
import time

import numpy as np

DATA_ROOT = os.path.join(os.path.dirname(__file__), "..", "data")


def load_inputs(n: int):
    d = os.path.join(DATA_ROOT, f"N{n}")
    if not os.path.exists(d):
        raise SystemExit(f"{d} missing — run common/gen_inputs.py --n {n}")
    A = np.fromfile(os.path.join(d, "A.bin"), dtype=np.float32).reshape(n, n)
    B = np.fromfile(os.path.join(d, "B.bin"), dtype=np.float32).reshape(n, n)
    C_ref = np.fromfile(os.path.join(d, "C_ref.bin"), dtype=np.float32).reshape(n, n)
    return A, B, C_ref


HEADER = "name,N,seconds,gflops,check"
_header_printed = False


def report(name: str, n: int, seconds: float, C, C_ref, atol: float = 1e-2) -> str:
    global _header_printed
    if not _header_printed:
        print(HEADER)
        _header_printed = True
    gflops = 2.0 * n**3 / seconds / 1e9
    ok = "PASS" if np.max(np.abs(np.asarray(C) - C_ref)) < atol else "FAIL"
    line = f"{name},{n},{seconds:.4f},{gflops:.2f},{ok}"
    print(line)
    return line


def best_of(fn, reps: int = 3) -> tuple[float, object]:
    best, out = float("inf"), None
    for _ in range(reps):
        t0 = time.perf_counter()
        result = fn()
        dt = time.perf_counter() - t0
        if dt < best:
            best, out = dt, result
    return best, out
