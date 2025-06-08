#!/bin/bash
# job name
#SBATCH --job-name=T_SS1
# Number of nodes
#SBATCH --nodes=1
# Number of threads
#SBATCH --cpus-per-task=8
# partition
#SBATCH --partition=std
# list of valid ndoes
# max time restriction: add a day on top just to be safe
#SBATCH --time=4:00:00

srun ../../TimeFuzz/build-kali-release-noui/src/TimeFuzz --conf ../../TimeFuzz_Test/TF_Maze_Super/config_server_length.ini --save-status 60 statusl_1 --separatelogfiles logsl_1 --savepath savesl_1 --results-end --resultpath resultsl_1 --disable-logging