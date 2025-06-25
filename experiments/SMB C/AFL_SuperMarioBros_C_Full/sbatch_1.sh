#!/bin/bash
# job name
#SBATCH --job-name=IJon
#SBATCH -n 1
# partition
#SBATCH --partition=std
# list of valid ndoes
# max time restriction: add a day on top just to be safe
#SBATCH --time=15:00:00
# array
#SBATCH --array=0-1,3,5,8-9,11-14,17,19-20,22,30-31,34-35

srun timeout 12h ../afl-2.51b/afl-fuzz -m 200 -t 1000 -i seeds  -o "level${SLURM_ARRAY_TASK_ID}_1"  -- ./smbc $SLURM_ARRAY_TASK_ID
