#!/bin/bash
# job name
#SBATCH --job-name=TF
# Number of nodes
#SBATCH --nodes=1
# Number of threads
#SBATCH --cpus-per-task=15
# partition
#SBATCH --partition=std
# list of valid ndoes
#SBATCH --nodelist=gruenau3,gruenau4,gruenau5,gruenau6
# max time restriction: add a day on top just to be safe
#SBATCH --time=13:00:00
# ram requirements
#SBATCH --mem=120G
# array
#SBATCH --array=0,2-5,7-14,16-27,29-35

srun ../../TimeFuzz/build-kali-release-noui/src/TimeFuzz --conf config_server_LV${SLURM_ARRAY_TASK_ID}.ini --save-status 60 statusLV${SLURM_ARRAY_TASK_ID}_2 --separatelogfiles logsLV${SLURM_ARRAY_TASK_ID}_2 --savepath savesLV${SLURM_ARRAY_TASK_ID}_2 --results --resultpath resultsLV${SLURM_ARRAY_TASK_ID}_2 --fork 