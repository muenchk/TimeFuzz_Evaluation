#!/bin/bash
# job name
#SBATCH --job-name=TF_7_2
# Number of nodes
#SBATCH --nodes=1
# Number of threads
#SBATCH --cpus-per-task=60
# partition
#SBATCH --partition=std
# output path
#SBATCH --output=../slurmout/sbatch_7_2.txt
# max time restriction: add a day on top just to be safe
#SBATCH --time=15:00:00
# list of valid ndoes
#SBATCH --nodelist=gruenau3,gruenau4,gruenau5,gruenau6
# ram requirements
#SBATCH --mem=460G

srun ../../../TimeFuzz/build-kali-release-noui/src/TimeFuzz --conf ../config_server_LV7.ini --save-status 60 statusLV7_2 --separatelogfiles logsLV7_2 --savepath savesLV7_2  --load ScoreProgressLV7
