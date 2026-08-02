# The Matmul Ladder — build and bench
#
#   make            build all C rungs
#   make data       generate input matrices + reference
#   make bench      run the full ladder -> results/results.csv
#   make chart      plot results -> results/ladder.png
#   make T=32       rebuild tiled rungs with a different tile size

CC     := gcc
T      ?= 128
PY     ?= python3

# Rungs 2-3: vectorization OFF, so each rung isolates ONE idea.
BASE   := -O2 -fno-tree-vectorize -fno-tree-slp-vectorize -Wall
# Rungs 4-6: let the compiler off the leash.
FAST   := -O3 -march=native -ffast-math -funroll-loops -Wall

BUILD  := build

BINS := $(BUILD)/rung2_c_naive $(BUILD)/rung3_c_reorder $(BUILD)/rung4_c_simd \
        $(BUILD)/rung5_c_tiled $(BUILD)/rung6_c_openmp

all: $(BINS)

$(BUILD):
	mkdir -p $(BUILD)

$(BUILD)/rung2_c_naive: rung2_c_naive.c common/harness.h | $(BUILD)
	$(CC) $(BASE) -o $@ $<

$(BUILD)/rung3_c_reorder: rung3_c_reorder.c common/harness.h | $(BUILD)
	$(CC) $(BASE) -o $@ $<

$(BUILD)/rung4_c_simd: rung4_c_simd.c common/harness.h | $(BUILD)
	$(CC) $(FAST) -o $@ $<

$(BUILD)/rung5_c_tiled: rung5_c_tiled.c common/harness.h | $(BUILD)
	$(CC) $(FAST) -DT=$(T) -o $@ $<

$(BUILD)/rung6_c_openmp: rung6_c_openmp.c common/harness.h | $(BUILD)
	$(CC) $(FAST) -fopenmp -DT=$(T) -o $@ $<

data:
	$(PY) common/gen_inputs.py

bench: all
	$(PY) bench.py

chart:
	$(PY) plot.py

clean:
	rm -rf $(BUILD)

.PHONY: all data bench chart clean
