#!/bin/bash
# job name
#SBATCH --job-name=T_L2
# Number of nodes
#SBATCH --nodes=1
# Number of threads
#SBATCH --cpus-per-task=8
# partition
#SBATCH --partition=std
# list of valid ndoes
# max time restriction: add a day on top just to be safe
#SBATCH --time=4:00:00

srun ../../TimeFuzz/build-kali-release-noui/src/TimeFuzz --conf ../../TimeFuzz_Test/TF_Maze_Large/config_server_score.ini --save-status 60 status_2 --separatelogfiles logs_2 --savepath saves_2 --results-end --resultpath results_2 --disable-logging