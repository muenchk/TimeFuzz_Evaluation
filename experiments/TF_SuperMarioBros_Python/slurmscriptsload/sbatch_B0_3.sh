#!/bin/bash
# job name
#SBATCH --job-name=TF_0_3
# Number of nodes
#SBATCH --nodes=1
# Number of threads
#SBATCH --cpus-per-task=60
# partition
#SBATCH --partition=std
# output path
#SBATCH --output=../slurmoutB/sbatch_0_3.txt
# max time restriction: add a day on top just to be safe
#SBATCH --time=15:00:00
# list of valid ndoes
#SBATCH --nodelist=gruenau3,gruenau4,gruenau5,gruenau6
# ram requirements
#SBATCH --mem=480G

srun ../../../TimeFuzz/build-kali-release-noui/src/TimeFuzz --conf ../config_server_BLV0.ini --save-status 60 statusBLV0_3 --separatelogfiles logsBLV0_3 --savepath savesBLV0_3  --load ScoreProgressLV0

