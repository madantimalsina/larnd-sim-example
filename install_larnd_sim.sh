#!/usr/bin/env bash

module load cudatoolkit/11.7
module load python/3.9-anaconda-2021.11

python3 -m venv larnd-sim.venv
source larnd-sim.venv/bin/activate
pip install --upgrade pip setuptools wheel

git clone -b develop https://github.com/DUNE/larnd-sim
cd larnd-sim
pip install cupy-cuda11x
SKIP_CUPY_INSTALL=1 pip install -e .
