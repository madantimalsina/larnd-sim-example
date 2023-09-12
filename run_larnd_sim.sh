#!/usr/bin/env bash

cd $(dirname "${BASH_SOURCE[0]}")
source larnd-sim.venv/bin/activate

detector_properties="larnd-sim/larndsim/detector_properties/2x2.yaml"
pixel_layout="larnd-sim/larndsim/pixel_layouts/multi_tile_layout-2.4.16.yaml"
response_file="larnd-sim/larndsim/bin/response_44.npy"
light_lut_filename="/inputs/lightLUT_M123.npz"
light_det_noise_filename="larnd-sim/larndsim/bin/light_noise_2x2_4mod_July2023.npy"
simulation_properties="larnd-sim/larndsim/simulation_properties/2x2_NuMI_sim.yaml"

in_file=/inputs/MiniRun4_1E19_RHC.convert2h5.00246.EDEPSIM.h5
out_file=/outputs/MiniRun4_1E19_RHC.larnd.00246.LARNDSIM.h5

mkdir -p "$(dirname "$out_file")"

simulate_pixels.py --input_filename "$in_file" \
    --output_filename "$out_file" \
    --detector_properties "$detector_properties" \
    --pixel_layout "$pixel_layout" \
    --response_file "$response_file" \
    --light_lut_filename "$light_lut_filename" \
    --light_det_noise_filename "$light_det_noise_filename" \
    --rand_seed 321 \
    --simulation_properties "$simulation_properties"
