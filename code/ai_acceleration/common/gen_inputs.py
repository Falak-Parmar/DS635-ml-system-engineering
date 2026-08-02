"""Generate deterministic input matrices and the correctness reference.

Writes data/N{n}/{A,B,C_ref}.bin as float32 row-major. Every rung — C or
Python — checks against the same C_ref, so a broken optimization is caught
immediately.
"""
import argparse
import os

import numpy as np


def generate(n: int, outdir: str) -> None:
    rng = np.random.default_rng(seed=635)
    A = rng.standard_normal((n, n), dtype=np.float32)
    B = rng.standard_normal((n, n), dtype=np.float32)
    C_ref = A @ B
    os.makedirs(outdir, exist_ok=True)
    A.tofile(os.path.join(outdir, "A.bin"))
    B.tofile(os.path.join(outdir, "B.bin"))
    C_ref.tofile(os.path.join(outdir, "C_ref.bin"))
    print(f"wrote {outdir}: A, B, C_ref ({n}x{n} float32)")


if __name__ == "__main__":
    p = argparse.ArgumentParser()
    p.add_argument("--n", type=int, nargs="+", default=[256, 1024, 2048])
    p.add_argument("--datadir", default=os.path.join(os.path.dirname(__file__), "..", "data"))
    args = p.parse_args()
    for n in args.n:
        generate(n, os.path.join(args.datadir, f"N{n}"))
