"""Rung 7 — GPU matmul, with the two traps as flags.

    python3 rung7_gpu.py --no-sync         # trap 1: measure the enqueue, not the compute
    python3 rung7_gpu.py --time-transfer   # trap 2: PCIe transfer inside the timing
    python3 rung7_gpu.py                   # timed correctly

Trap 1: kernel launch is an ASYNCHRONOUS enqueue. Without synchronize()
you measure how long it takes to put work in a queue — microseconds —
not how long the work takes.

Trap 2: the data has to get to the GPU. Include the host->device copy and
watch the speedup shrink. PCIe is real.

Works on NVIDIA (CUDA) and AMD (ROCm/HIP) alike — torch maps 'cuda' to
HIP on ROCm builds. Pin the device on hybrid laptops: HIP_VISIBLE_DEVICES=0.
"""
import argparse
import sys
import time

sys.path.insert(0, "common")
from harness import load_inputs, report

import torch


def main():
    p = argparse.ArgumentParser()
    p.add_argument("n", type=int, nargs="?", default=1024)
    p.add_argument("--reps", type=int, default=10)
    p.add_argument("--no-sync", action="store_true")
    p.add_argument("--time-transfer", action="store_true")
    args = p.parse_args()

    if not torch.cuda.is_available():
        print("rung7_gpu: no GPU visible to torch — skipping", file=sys.stderr)
        return 0

    print(f"# device: {torch.cuda.get_device_name(0)}", file=sys.stderr)
    A, B, C_ref = load_inputs(args.n)
    A_t, B_t = torch.from_numpy(A), torch.from_numpy(B)

    if args.no_sync:
        A_g, B_g = A_t.cuda(), B_t.cuda()
        for _ in range(3):  # warmup so we time the enqueue, not first-call kernel compilation
            _ = A_g @ B_g
        torch.cuda.synchronize()
        t0 = time.perf_counter()
        C_g = A_g @ B_g  # enqueued, NOT finished
        dt = time.perf_counter() - t0
        print(f"# 'time' without synchronize: {dt * 1e6:.1f} microseconds", file=sys.stderr)
        print(f"# that is {2 * args.n**3 / dt / 1e12:.0f} 'TFLOP/s' — obviously fake", file=sys.stderr)
        torch.cuda.synchronize()
        return 0

    if args.time_transfer:
        best = float("inf")
        for _ in range(args.reps):
            torch.cuda.synchronize()
            t0 = time.perf_counter()
            A_g, B_g = A_t.cuda(), B_t.cuda()  # PCIe copy inside the timing
            C_g = A_g @ B_g
            torch.cuda.synchronize()
            best = min(best, time.perf_counter() - t0)
        report("rung7_gpu_with_transfer", args.n, best, C_g.cpu().numpy(), C_ref)
        return 0

    A_g, B_g = A_t.cuda(), B_t.cuda()
    for _ in range(3):  # warmup
        _ = A_g @ B_g
    torch.cuda.synchronize()

    best = float("inf")
    for _ in range(args.reps):
        torch.cuda.synchronize()
        t0 = time.perf_counter()
        C_g = A_g @ B_g
        torch.cuda.synchronize()
        best = min(best, time.perf_counter() - t0)
    report("rung7_gpu", args.n, best, C_g.cpu().numpy(), C_ref)
    return 0


if __name__ == "__main__":
    sys.exit(main())
