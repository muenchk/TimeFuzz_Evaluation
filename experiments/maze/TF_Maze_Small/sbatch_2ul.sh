#!/bin/bash
# job name
#SBATCH --job-name=T_S2
# Number of nodes
#SBATCH --nodes=1
# Number of threads
#SBATCH --cpus-per-task=8
# partition
#SBATCH --partition=std
# list of valid ndoes
# max time restriction: add a day on top just to be safe
#SBATCH --time=4:00:00

srun ../../TimeFuzz/build-kali-release-noui/src/TimeFuzz --conf ../../TimeFuzz_Test/TF_Maze_Small/config_server_length.ini --save-status 60 statusl_2 --separatelogfiles logsl_2 --savepath savesl_2 --results-end --resultpath resultsl_2 --disable-logging