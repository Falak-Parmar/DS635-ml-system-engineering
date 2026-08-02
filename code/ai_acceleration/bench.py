"""Run the full ladder and write results/results.csv.

Rung 0 runs at N=256 (at N=1024 a single run takes a minute); its GFLOP/s
is comparable anyway — that's the point of the metric. The C rungs run at
N=2048 — large enough that B does not fit in L3, so the memory wall is
real. Rung 4 also runs at N=1024 to capture the before/after of the wall
appearing. GPU rungs are skipped gracefully if torch can't see a GPU.
"""
import os
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
PY = sys.executable

LADDER = [
    ([PY, "rung0_python_naive.py", "256"], True),
    ([PY, "rung1_numpy.py", "2048"], True),
    (["build/rung2_c_naive", "2048", "1"], True),
    (["build/rung3_c_reorder", "2048"], True),
    (["build/rung4_c_simd", "1024"], True),   # before the wall: B fits in L3
    (["build/rung4_c_simd", "2048"], True),   # after: throughput collapses
    (["build/rung5_c_tiled", "2048"], True),
    (["build/rung6_c_openmp", "2048"], True),
    ([PY, "rung7_gpu.py", "2048"], False),
    ([PY, "rung8_lowprec.py", "2048"], False),
]


def main():
    os.chdir(HERE)
    if not os.path.exists("data/N2048"):
        subprocess.run([PY, "common/gen_inputs.py", "--n", "256", "1024", "2048"], check=True)

    rows = ["name,N,seconds,gflops,check"]
    for cmd, required in LADDER:
        print(f"$ {' '.join(cmd)}", file=sys.stderr)
        try:
            out = subprocess.run(cmd, capture_output=True, text=True, check=required)
        except (subprocess.CalledProcessError, FileNotFoundError) as e:
            print(f"  FAILED: {e}", file=sys.stderr)
            if required:
                return 1
            continue
        for line in out.stdout.splitlines():
            line = line.strip()
            if line and not line.startswith("#") and line != rows[0]:
                rows.append(line)
                print(f"  {line}", file=sys.stderr)
        for line in out.stderr.splitlines():
            print(f"  {line}", file=sys.stderr)

    os.makedirs("results", exist_ok=True)
    with open("results/results.csv", "w") as f:
        f.write("\n".join(rows) + "\n")
    print("wrote results/results.csv", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
