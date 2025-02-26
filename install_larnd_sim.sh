#!/usr/bin/env bash

source setup.inc.sh

python3 -m venv "$venv_name"
source "$venv_name/bin/activate"

pip install --upgrade pip setuptools wheel
# For validation plots:
pip install matplotlib awkward

# If we're re-running the installer for, say, a different CUDA version, then
# `larnd-sim` already exists
if [[ ! -d larnd-sim-hackathon2024 ]]; then
    # git clone -b develop https://github.com/DUNE/larnd-sim
    git clone -b develop https://github.com/madantimalsina/larnd-sim-hackathon2024
fi

cd larnd-sim-hackathon2024
pip install -e .
