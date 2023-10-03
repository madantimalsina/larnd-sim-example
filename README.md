# larnd-sim example

This is a minimal example for running
[larnd-sim](https://github.com/DUNE/larnd-sim) on Perlmutter at NERSC.

## Building it

Start by cloning and entering this repository:

``` bash
git clone https://github.com/lbl-neutrino/larnd-sim-example.git
cd larnd-sim-example
```

Then run the installer:

``` bash
./install_larnd_sim.sh
```

This will locally clone `larnd-sim` and create a Python virtual environment `larnd-sim.venv` for its dependencies.

## Running it

It's a good idea to grab a dedicated GPU:

``` bash
salloc -q shared -C gpu -t 20 --gpus-per-task 1 --ntasks 1 -A dune_g
```

Then launch the simulation:

``` bash
./run_larnd_sim.sh
```

You can override the default input file (i.e. the output from edep-sim) by passing a file on the command line (see the top of `run_larnd_sim.sh`).
