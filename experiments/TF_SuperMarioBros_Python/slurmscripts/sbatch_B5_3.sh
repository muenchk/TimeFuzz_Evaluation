#!/bin/bash
# job name
#SBATCH --job-name=TF_5_3
# Number of nodes
#SBATCH --nodes=1
# Number of threads
#SBATCH --cpus-per-task=60
# partition
#SBATCH --partition=std
# max time restriction: add a day on top just to be safe
#SBATCH --time=15:00:00
# list of valid ndoes
#SBATCH --nodelist=gruenau3,gruenau4,gruenau5,gruenau6
# ram requirements
#SBATCH --mem=480G

srun ../../../TimeFuzz/build-kali-release-noui/src/TimeFuzz --conf ../config_server_BLV5.ini --save-status 60 statusBLV5_3 --separatelogfiles logsBLV5_3 --savepath savesBLV5_3 
