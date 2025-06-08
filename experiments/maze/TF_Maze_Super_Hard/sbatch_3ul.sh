#!/bin/bash
# job name
#SBATCH --job-name=T_SSH3
# Number of nodes
#SBATCH --nodes=1
# Number of threads
#SBATCH --cpus-per-task=8
# partition
#SBATCH --partition=std
# list of valid ndoes
# max time restriction: add a day on top just to be safe
#SBATCH --time=4:00:00

srun ../../TimeFuzz/build-kali-release-noui/src/TimeFuzz --conf ../../TimeFuzz_Test/TF_Maze_Super_Hard/config_server_length.ini --save-status 60 statusl_3 --separatelogfiles logsl_3 --savepath savesl_3 --results-end --resultpath resultsl_3 --disable-logging