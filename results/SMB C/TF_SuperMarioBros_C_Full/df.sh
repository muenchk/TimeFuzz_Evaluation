#!/bin/bash


arr=(0 2 3 4 5 7 8 9 10 11 12 13 14 16 17 18 19 20 21 22 23 24 25 26 27 29 30 31 32 33 34 35)

for i in "${arr[@]}"
do
    for c in {1..3}
    do
        echo -n "LV ${i}_$c ..."

        
        (head -n 101 resultsLV${i}_$c/positive.csv &> resultsLV${i}_$c/positive2.csv)
        (rm resultsLV${i}_$c/positive.csv)
        (mv resultsLV${i}_$c/positive2.csv resultsLV${i}_$c/positive.csv)

        lines=$(tail -n +2 resultsLV${i}_$c/positive.csv  2>/dev/null | cut -d";" -f 1  2>/dev/null)

        files=$(find resultsLV${i}_$c/positive -type f -name "*.txt")

        for f in $files
        do
            found=0
            while read line
            do
                if [[ $f == *$line* ]]; then
                    found=1
                fi
            done <<<$(echo "$lines")
            if [ $found -ne 1 ]; then
                (rm -f $f)
            fi
        done
        echo " done"
    done
done









