"""Plot the ladder: results/results.csv -> results/ladder.png.

Log scale is the honest scale here — the whole story spans 5-6 orders of
magnitude.
"""
import csv
import os

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt

HERE = os.path.dirname(os.path.abspath(__file__))


def main():
    path = os.path.join(HERE, "results", "results.csv")
    names, gflops, checks = [], [], []
    with open(path) as f:
        for row in csv.DictReader(f):
            names.append(f'{row["name"]} (N={row["N"]})')
            gflops.append(float(row["gflops"]))
            checks.append(row["check"])

    fig, ax = plt.subplots(figsize=(9, 0.5 * len(names) + 2))
    colors = ["#4878cf" if c == "PASS" else "#d1022f" for c in checks]
    bars = ax.barh(range(len(names)), gflops, color=colors)
    ax.set_yticks(range(len(names)), names)
    ax.invert_yaxis()
    ax.set_xscale("log")
    ax.set_xlabel("GFLOP/s (log scale) — FP32 matmul, higher is better")
    ax.set_title("The Matmul Ladder")
    ax.bar_label(bars, fmt="%.2f", padding=3, fontsize=8)
    ax.grid(axis="x", alpha=0.3)
    fig.tight_layout()
    out = os.path.join(HERE, "results", "ladder.png")
    fig.savefig(out, dpi=150)
    print(f"wrote {out}")


if __name__ == "__main__":
    main()
