#!/bin/bash
# job name
#SBATCH --job-name=IJon
#SBATCH --nodes 1
#SBATCH -n 1
# partition
#SBATCH --partition=std
# list of valid ndoes
# max time restriction: add a day on top just to be safe
#SBATCH --time=15:00:00
# array
#SBATCH --array=0,2-5,7-14,16-27,29-35

export AFL_NO_AFFINITY=1

srun timeout 12h ../ijon-experimental/afl-fuzz -m 200 -t 1000 -i seeds  -o "level${SLURM_ARRAY_TASK_ID}_2"  -- ./smbc $SLURM_ARRAY_TASK_ID