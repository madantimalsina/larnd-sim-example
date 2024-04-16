#!/usr/bin/env bash

default_in_file="/global/cfs/cdirs/dune/www/data/2x2/simulation/mkramer_dev/larnd-sim-example/MiniRun5_1E19_RHC.convert2h5.00123.EDEPSIM.hdf5"

# allow custom input file to be passed via command line
in_file=${1:-$default_in_file}

module unload python 2>/dev/null
module unload cudatoolkit 2>/dev/null

module load cudatoolkit/11.7
module load python/3.11

cd $(dirname "${BASH_SOURCE[0]}")
source larnd-sim.venv/bin/activate

now=$(date -u +%Y%m%dT%H%M%SZ)

out_file=$(basename $in_file .hdf5 | sed 's/convert2h5/larnd/' | sed 's/.EDEPSIM//')."$now".LARNDSIM.hdf5
out_dir=$SCRATCH/larnd-sim-output
mkdir -p "$out_dir"

nsys=/global/common/software/dune/mkramer/misc_software/nsight-systems-2023.4.1/bin/nsys
ncu=/global/common/software/dune/mkramer/misc_software/NVIDIA-Nsight-Compute-2024.1/ncu

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

simulate_pixels.py 2x2_mod2mod_variation \
    --input_filename "$in_file" \
    --output_filename "$out_dir/$out_file" \
    --rand_seed 321
