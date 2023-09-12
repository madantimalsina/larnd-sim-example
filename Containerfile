# podman-hpc build -t mjkramer/larnd-sim:v1 .
FROM nvidia/cuda:11.7.1-devel-rockylinux8

COPY inputs /inputs

COPY install_larnd_sim.sh /
RUN /install_larnd_sim.sh

COPY run_larnd_sim.sh /software
