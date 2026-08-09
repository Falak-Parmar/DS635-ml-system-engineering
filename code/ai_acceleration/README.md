# The Matmul Ladder

One fixed problem — an N×N FP32 matrix multiplication — climbed nine ways,
from naive Python to GPU tensor pipes. One number changes per rung:
**GFLOP/s = 2N³ / time**.

Every rung teaches a different hardware fact. The point is not the speed;
it's that each CPU optimization you write by hand turns out to be a
software imitation of something the GPU does natively.

## Quickstart

```bash
make data     # generate inputs + correctness reference (needs numpy)
make          # build the C rungs
make bench    # run the whole ladder -> results/results.csv
make chart    # plot it            -> results/ladder.png
```

Run a single rung:

```bash
python3 rung0_python_naive.py 256      # never run this at 1024
./build/rung3_c_reorder 1024
python3 rung7_gpu.py 1024
```

Every rung prints the same CSV line: `name,N,seconds,gflops,check`.
`check` compares against a NumPy-computed reference — if you broke the
math, you'll know.

## The rungs

| Rung | File | The one idea it isolates |
|---|---|---|
| 0 | `rung0_python_naive.py` | Interpreter overhead — the zero of the scale |
| 1 | `rung1_numpy.py` | BLAS exists; we're reconstructing it, not beating it |
| 2 | `rung2_c_naive.c` | Compiled vs interpreted |
| 3 | `rung3_c_reorder.c` | **Memory access order** — same arithmetic, ~7× faster |
| 4 | `rung4_c_simd.c` | SIMD lanes — raises the compute roof… into the memory wall |
| 5 | `rung5_c_tiled.c` | **Arithmetic intensity** — tiling escapes the wall |
| 6 | `rung6_c_openmp.c` | All cores — the CPU ceiling |
| 7 | `rung7_gpu.py` | The GPU — plus two timing traps (`--no-sync`, `--time-transfer`) |
| 8 | `rung8_lowprec.py` | Precision as a performance knob (TF32 / FP16) |

Rungs 2–3 are compiled with auto-vectorization *disabled* so each rung
isolates exactly one idea; rungs 4–6 get `-O3 -march=native -ffast-math`.

**Why SIMD before tiling?** Because measurement said so. At scalar speeds
(rungs 2–3) the code is *compute-bound* — ~1 FLOP/cycle is the scalar
issue ceiling — so tiling shows nothing. SIMD raises the compute roof
~8×, and at N=2048 (B no longer fits in L3) throughput collapses: the
code is now *memory-bound*. That's when tiling pays — `bench.py` runs
rung 4 at both N=1024 and N=2048 so the wall's appearance is a data
point, not an assertion. Optimizations only help on the bottleneck; the
ladder demonstrates the bottleneck *moving*.

## Notes

- **Your numbers will differ from the lecture's.** Cache sizes, core
  counts, and GPUs vary. The *shape* of the curve is the lesson.
- **Tile size:** `make T=32` / `make T=128` rebuilds the tiled rungs —
  sweep it and find your machine's L1/L2 sweet spot.
- **GPU device pinning:** on hybrid AMD laptops, `HIP_VISIBLE_DEVICES=0`
  selects the discrete GPU. On NVIDIA use `CUDA_VISIBLE_DEVICES`.
  `rung7_gpu.py` prints the device name it actually ran on — read it.
- **AMD RDNA2 (e.g. RX 6700M, gfx1031):** rocBLAS ships no kernels for
  gfx1031; run the GPU rungs with the ISA-compatible override:
  `HSA_OVERRIDE_GFX_VERSION=10.3.0 HIP_VISIBLE_DEVICES=0 make bench`
- GPU rungs need PyTorch (CUDA or ROCm build). `make bench` skips them
  gracefully if torch can't see a device.

## Lab: extend the ladder

1. Reproduce the ladder on your machine and compare the shape with a
   classmate's — explain every difference you find.
2. Sweep the tile size `T` and plot GFLOP/s vs T. Where is your peak, and
   what does that say about your cache sizes?
3. Run rung 7's two traps and explain, in one paragraph each, what was
   actually measured.
4. (Stretch) Add a rung: `float64` versions, a different loop order, or
   `torch.compile` on the GPU rung. Predict the result before running.
