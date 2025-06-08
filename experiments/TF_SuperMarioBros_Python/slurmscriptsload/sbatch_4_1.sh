#!/bin/bash
# job name
#SBATCH --job-name=TF_4_1
# Number of nodes
#SBATCH --nodes=1
# Number of threads
#SBATCH --cpus-per-task=60
# partition
#SBATCH --partition=std
# output path
#SBATCH --output=../slurmout/sbatch_4_1.txt
# max time restriction: add a day on top just to be safe
#SBATCH --time=15:00:00
# list of valid ndoes
#SBATCH --nodelist=gruenau3,gruenau4,gruenau5,gruenau6
# ram requirements
#SBATCH --mem=460G

srun ../../../TimeFuzz/build-kali-release-noui/src/TimeFuzz --conf ../config_server_LV4.ini --save-status 60 statusLV4_1 --separatelogfiles logsLV4_1 --savepath savesLV4_1  --load ScoreProgressLV4
