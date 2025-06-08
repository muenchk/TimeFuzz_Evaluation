#!/bin/bash
# job name
#SBATCH --job-name=TF_6_3
# Number of nodes
#SBATCH --nodes=1
# Number of threads
#SBATCH --cpus-per-task=60
# partition
#SBATCH --partition=std
# output path
#SBATCH --output=../slurmout/sbatch_6_3.txt
# max time restriction: add a day on top just to be safe
#SBATCH --time=15:00:00
# list of valid ndoes
#SBATCH --nodelist=gruenau3,gruenau4,gruenau5,gruenau6
# ram requirements
#SBATCH --mem=460G

srun ../../../TimeFuzz/build-kali-release-noui/src/TimeFuzz --conf ../config_server_LV6.ini --save-status 60 statusLV6_3 --separatelogfiles logsLV6_3 --savepath savesLV6_3  --load ScoreProgressLV6
