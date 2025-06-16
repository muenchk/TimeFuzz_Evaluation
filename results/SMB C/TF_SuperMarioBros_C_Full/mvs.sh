#!/bin/bash


arr=(0 2 3 4 5 7 8 9 10 11 12 13 14 16 17 18 19 20 21 22 23 24 25 26 27 29 30 31 32 33 34 35)

for i in "${arr[@]}"
do
    for c in {1..3}
    do
        cp /mnt/z/TimeFuzz_results/TF_C/TF_SupeMarioBros_C_Full/resultsLV${i}_$c/positive.csv ./resultsLV${i}_$c/positive.csv
    done
done









