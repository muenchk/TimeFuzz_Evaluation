#!/bin/bash
# job name
#SBATCH --job-name=AMBH2
#SBATCH --nodes=1
#SBATCH -n 1
# partition
#SBATCH --partition=std
# list of valid ndoes
# max time restriction: add a day on top just to be safe
#SBATCH --time=15:00:00

srun timeout 1h ../afl-2.51b/afl-fuzz -m 200 -t 1000 -i seeds  -o "results_2"  -- ./maze_big_hard