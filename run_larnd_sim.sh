#!/usr/bin/env bash

default_in_file="/global/cfs/cdirs/dune/users/mkramer/mywork/2x2_sim/run-convert2h5/output/MiniRun4_1E19_RHC.convert2h5/EDEPSIM_H5/MiniRun4_1E19_RHC.convert2h5.00246.EDEPSIM.h5"

# allow custom input file to be passed via command line
in_file=${1:-$default_in_file}

module load cudatoolkit/11.7
module load python/3.9-anaconda-2021.11

cd $(dirname "${BASH_SOURCE[0]}")
source larnd-sim.venv/bin/activate

detector_properties="larnd-sim/larndsim/detector_properties/2x2.yaml"
pixel_layout="larnd-sim/larndsim/pixel_layouts/multi_tile_layout-2.4.16.yaml"
response_file="larnd-sim/larndsim/bin/response_44.npy"
light_lut_filename="/global/cfs/cdirs/dune/www/data/2x2/simulation/larndsim_data/light_LUT_M123_v1/lightLUT_M123.npz"
light_det_noise_filename="larnd-sim/larndsim/bin/light_noise_2x2_4mod_July2023.npy"
simulation_properties="larnd-sim/larndsim/simulation_properties/2x2_NuMI_sim.yaml"

out_file=$(basename $in_file .h5 | sed 's/convert2h5/larnd/' | sed 's/.EDEPSIM//').LARNDSIM.h5

simulate_pixels.py --input_filename "$in_file" \
    --output_filename "$out_file" \
    --detector_properties "$detector_properties" \
    --pixel_layout "$pixel_layout" \
    --response_file "$response_file" \
    --light_lut_filename "$light_lut_filename" \
    --light_det_noise_filename "$light_det_noise_filename" \
    --rand_seed 321 \
    --simulation_properties "$simulation_properties"
