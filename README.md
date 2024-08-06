# larnd-sim example (Hackathon edition)

This is a minimal example for running [larnd-sim](https://github.com/DUNE/larnd-sim) on Perlmutter at NERSC. For the purposes of the hackathon, we also discuss running miniapps, profilers, tests, etc.

## Installation

Note: CFS and `$HOME` tend to struggle with Python virtual environments, so I recommend that you do the following steps in a directory on `$PSCRATCH` (but commit/push any code changes that you don't want to fall victim to `$PSCRATCH`'s purge policy!).

Start by cloning and entering this repository:

``` bash
git clone https://github.com/lbl-neutrino/larnd-sim-example.git
cd larnd-sim-example
```

Then run the installer:

``` bash
./install_larnd_sim.sh
```

This will locally clone `larnd-sim` and create a Python virtual environment `larnd-sim.venv` for its dependencies. Since `larnd-sim` is installed with the `-e` option to `pip install`, you don't need to re-run `pip install` after modifying the code.

## The wrapper script

For convenience, we wrap all invocations of the simulation and miniapps in the `run.sh` wrapper script, which takes care of environment setup, profiling, etc.

## Running the full simulation

It's a good idea to grab a dedicated 80GB GPU:

``` bash
salloc -A dune -q interactive -C 'gpu&hbm80g' -t 30
```

30 minutes should be enough for a few runs of `larnd-sim`. The above will actually give you a whole node, with four GPUs, which is more than you need, but so be it. You can also grab a single GPU on a shared node:


``` bash
salloc -q shared -C 'gpu&hbm80g' -t 30 --gpus-per-task 1 --ntasks 1 -A dune_g
```

But the `shared` QOS typically will leave you waiting in the queue, while `interactive` is usually nearly instant.

Once you've got a GPU to yourself, launch the simulation:

``` bash
./run.sh larnd-sim.sh
```

### Controlling the run

The following environment variables can be used:

- `LARNDSIM_CONFIG`: Sets the configuration of the simulation. The default is `2x2`. For production we typically use `2x2_mod2mod_variation`.
- `LARNDSIM_MAX_EVENTS`: Can be used to limit the number of events simulated.
- `LARNDSIM_PROFILER`: Can be set to `nsys` or `ncu` to run in Nsight Systems or Nsight Compute, respectively
- `LARNDSIM_INPUT_FILE`: Can be used to override the default input file.
- `LARNDSIM_DISABLE_CUPY_MEMPOOL`: Disable the Cupy memory pool

Another useful parameter is the `BATCH_SIZE` variable in the simulation properties file.

### Producing miniapp inputs

The following environment variables will cause simulate_pixels.py to dump the kernel's input arrays to a pickle file (and then exit).

- `LARNDSIM_DUMP4MINIAPP_CALC_LIGHT_DET_RESPONSE`
- `LARNDSIM_DUMP4MINIAPP_GET_ADC_VALUES`
- `LARNDSIM_DUMP4MINIAPP_TRACKS_CURRENT_MC`

## Producing validation plots

You can produce a PDF of validation plots as follows:

```
./make_plots.sh /path/to/output.hdf5
```

The PDF file will be produced in the same directory as the HDF5 file.

## Running integration tests

Run `larnd-sim/cli/compare_files.py`.

## Running miniapps

### `calc_light_det_response`

``` bash
./run.sh larnd-sim/miniapps/calc_light_det_response.py
```

### `get_adc_values`

``` bash
./run.sh larnd-sim/miniapps/get_adc_values.py
```

### `tracks_current_mc`

``` bash
./run.sh larnd-sim/miniapps/tracks_current_mc.py
```

## Using the profiling output

### Nsight Systems

The output (an `nsys-rep` file) can be opened with `nsys-ui` from Nsight Systems 2023.4.1:

![NSight Systems screenshot](assets/nsight_systems.png)

### Nsight Compute

The output (an `ncu-rep` file) can be opened with `ncu-ui` from Nsight Compute 2024.1.
