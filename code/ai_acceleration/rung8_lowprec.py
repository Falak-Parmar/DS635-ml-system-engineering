"""Rung 8 — precision as a performance knob.

On NVIDIA (Ampere+): enabling TF32 reroutes FP32 matmul through tensor
cores — several-fold jump, zero code change.

On AMD RDNA2 (no matrix cores): TF32 is a no-op, but FP16 uses the
double-rate packed-math pipes — a real, if smaller, jump.

Either way the lesson holds: fewer bits = less bandwidth = more speed,
and dedicated matrix hardware is another level entirely. Tensor cores
get a full treatment in the precision lecture.
"""
import sys
import time

sys.path.insert(0, "common")
from harness import load_inputs, report

import torch


def bench(fn, reps=10):
    for _ in range(3):
        fn()
    torch.cuda.synchronize()
    best = float("inf")
    for _ in range(reps):
        torch.cuda.synchronize()
        t0 = time.perf_counter()
        out = fn()
        torch.cuda.synchronize()
        best = min(best, time.perf_counter() - t0)
    return best, out


def main():
    n = int(sys.argv[1]) if len(sys.argv) > 1 else 1024
    if not torch.cuda.is_available():
        print("rung8_lowprec: no GPU visible to torch — skipping", file=sys.stderr)
        return 0

    A, B, C_ref = load_inputs(n)
    A_g, B_g = torch.from_numpy(A).cuda(), torch.from_numpy(B).cuda()

    torch.backends.cuda.matmul.allow_tf32 = True
    torch.backends.cudnn.allow_tf32 = True
    best, C_g = bench(lambda: A_g @ B_g)
    report("rung8_tf32", n, best, C_g.cpu().numpy(), C_ref, atol=0.5)

    A_h, B_h = A_g.half(), B_g.half()
    best, C_h = bench(lambda: A_h @ B_h)
    report("rung8_fp16", n, best, C_h.float().cpu().numpy(), C_ref, atol=0.5)
    return 0


if __name__ == "__main__":
    sys.exit(main())
