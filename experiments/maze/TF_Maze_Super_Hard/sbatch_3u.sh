#!/bin/bash
# job name
#SBATCH --job-name=T_SS3
# Number of nodes
#SBATCH --nodes=1
# Number of threads
#SBATCH --cpus-per-task=8
# partition
#SBATCH --partition=std
# list of valid ndoes
# max time restriction: add a day on top just to be safe
#SBATCH --time=4:00:00

srun ../../TimeFuzz/build-kali-release-noui/src/TimeFuzz --conf ../../TimeFuzz_Test/TF_Maze_Super_Hard/config_server_score.ini --save-status 60 status_3 --separatelogfiles logs_3 --savepath saves_3 --results-end --resultpath results_3 --disable-logging