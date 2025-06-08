#!/bin/bash
# job name
#SBATCH --job-name=TF_4_3
# Number of nodes
#SBATCH --nodes=1
# Number of threads
#SBATCH --cpus-per-task=60
# partition
#SBATCH --partition=std
# output path
#SBATCH --output=../slurmoutB/sbatch_4_3.txt
# max time restriction: add a day on top just to be safe
#SBATCH --time=15:00:00
# list of valid ndoes
#SBATCH --nodelist=gruenau3,gruenau4,gruenau5,gruenau6
# ram requirements
#SBATCH --mem=480G

srun ../../../TimeFuzz/build-kali-release-noui/src/TimeFuzz --conf ../config_server_BLV4.ini --save-status 60 statusBLV4_3 --separatelogfiles logsBLV4_3 --savepath savesBLV4_3  --load ScoreProgressLV4

