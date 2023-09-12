# larnd-sim container

This is a minimal container for running
[larnd-sim](https://github.com/DUNE/larnd-sim) on Perlmutter at NERSC.

## Building it

First, a couple of input files must be copied into this directory before they can be bundled into the container:

``` bash
./copy_inputs.sh
```

This will create and populate the `inputs` directory.

Next, build the image:

``` bash
podman-hpc build -t larnd-sim .
```

At this point, the `inputs` directory can be deleted.

To make the image available on other nodes:

``` bash
podman-hpc migrate larnd-sim
```

## Running it

First, enter the container:

``` bash
podman-hpc run --gpu --rm -it larnd-sim /bin/bash
```

Then launch the simulation:

``` bash
/software/run_larnd_sim.sh
```

The output of the simulation will show up in the `/outputs` directory inside the container.
