#!/usr/bin/env bash

module unload python 2>/dev/null
module unload cudatoolkit 2>/dev/null

module load cudatoolkit/12.4
module load python/3.11

python3 -m venv larnd-sim.venv
source larnd-sim.venv/bin/activate
pip install --upgrade pip setuptools wheel
# For validation plots:
# pip install matplotlib awkward

# To support CUDA 12.4 with the older kernel driver on Perlmutter
pip install --extra-index-url https://pypi.nvidia.com pynvjitlink-cu12

git clone -b hackathon2024 https://github.com/DUNE/larnd-sim
cd larnd-sim
pip install cupy-cuda12x==13.1.0
SKIP_CUPY_INSTALL=1 pip install -e .
