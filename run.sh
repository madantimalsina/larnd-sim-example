#!/usr/bin/env bash

module unload python 2>/dev/null
module unload cudatoolkit 2>/dev/null

module load cudatoolkit/12.4
module load python/3.11

cd $(dirname "${BASH_SOURCE[0]}")
source larnd-sim.venv/bin/activate

nsys=/global/common/software/dune/mkramer/misc_software/nsight-systems-2023.4.1/bin/nsys
ncu=/global/common/software/dune/mkramer/misc_software/NVIDIA-Nsight-Compute-2024.1/ncu

out_dir=$SCRATCH/larnd-sim-output
mkdir -p "$out_dir"

run_in_nsys() {
    mkdir -p $out_dir/nsys
    # --cudabacktrace=all gives us a crash
    # nsys profile --cuda-memory-usage=true --cudabacktrace=all --python-backtrace=cuda --python-sampling=true \
    $nsys profile --cuda-memory-usage=true --python-backtrace=cuda --python-sampling=true \
        -o $out_dir/nsys/nsys-report%n "$@"
}

run_in_ncu() {
    mkdir -p $out_dir/ncu
    dcgmi profile --pause
    $ncu --kernel-id :::5 -o $out_dir/ncu/ncu-report.$now "$@"
    # $ncu -o $out_dir/ncu/ncu-report.$now "$@"
    dcgmi profile --resume
}

if [[ "$LARNDSIM_PROFILER" == "nsys" ]]; then
    run_in_nsys "$@"
elif [[ "$LARNDSIM_PROFILER" == "ncu" ]]; then
    run_in_ncu "$@"
else
    "$@"
fi
