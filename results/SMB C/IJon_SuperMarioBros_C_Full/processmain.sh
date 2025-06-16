#!/bin/bash

arr=(0 2 3 4 5 7 8 9 10 11 12 13 14 16 17 18 19 20 21 22 23 24 25 26 27 29 30 31 32 33 34 35)

echo "sep=;"
echo -e -n "Level;Solved;File;Execs;Execs/sec;Score;Distance;Length;GenTime;GenExecs;;"
echo -e -n "Level;Solved;File;Execs;Execs/sec;Score;Distance;Length;GenTime;GenExecs;;"
echo -e  "Level;Solved;File;Execs;Execs/sec;Score;Distance;Length;GenTime;GenExecs"


for i in "${arr[@]}"
do
    for c in {1..3}
    do
        echo -n "LV${i}_${c};"
        # get general fuzzer stats
        f="./level${i}_${c}/fuzzer_stats"
        fexec=$(grep "execs_done" $f)
        fexec=$(echo $fexec | cut -d: -f 2)
        fexecs=$(grep "execs_per_sec" $f)
        fexecs=$(echo $fexecs | cut -d: -f 2)
        st=$(grep "start_time" $f)
        st=$(echo $st | cut -d: -f 2)

        if [ -n "$(find level${i}_${c}/crashes/ -prune -empty -type d 2>/dev/null)" ]
        then
            bash ./process.sh $i $c &> rs/level$i-$c
            # get best file and possibly exec count
            size=$(cut -f 3 rs/level$i-$c 2>/dev/null | sort -n 2>/dev/null | tail -n 1 2>/dev/null)
            line=$(grep "$size" rs/level$i-$c 2>/dev/null | sort  -rk1 2>/dev/null | tail -n1 2>/dev/null)

            file=$(echo $line | cut -f 1 -d" ")
            f=$file
            size=$(echo $line | cut -f 2 -d" ")
            score=$(echo $line | cut -f 3 -d" ")
            file="${file}.stats"
            execs=$(grep "execs_done" $file 2>/dev/null)
            execs=$(echo $execs | cut -d: -f 2)
            start=$(grep "start_time" $file 2>/dev/null)
            start=$(echo $start | cut -d: -f 2)
            time=$(grep "last_update" $file 2>/dev/null)
            time=$(echo $time | cut -d: -f 2)
            t2=$(expr $time - $start)
            
           # if [[ $file == *ijon_max* ]]; then
    
           #     fi=$(echo $f | cut -d/ -f 3)
           #     fi=$(echo $fi | cut -d_ -f 3)
           #     t2=$(expr $fi - $st)

           #     echo -n "No;"
           #     echo -n "$file;$fexec;$fexecs;"
           #     echo -n "$score;;"
           #     echo -n "$size;"
           #     echo -n "$t2;"
           #     echo -e ";"
           # else
                echo -n "No;"
                echo -n "$file;$fexec;$fexecs;"
                echo -n "$score;;"
                echo -n "$size;"
                echo -n "$t2;"
                echo -n -e "$execs;"
           # fi
        else
            files2=$(find level${i}_${c}/crashes/ -maxdepth 1 -type f ! -name  '*.stats')
            for f in $files2
            do
                size="$(wc -c < "$f")" 
                score=$(./smbcf ${i} $size trace < $f 2>/dev/null | cut -d, -f 1 | sort -n | tail -n 1)

                file="${f}.stats"
                execs=$(grep "execs_done" $file 2>/dev/null)
                execs=$(echo $execs | cut -d: -f 2)
                start=$(grep "start_time" $file 2>/dev/null)
                start=$(echo $start | cut -d: -f 2)
                time=$(grep "last_update" $file 2>/dev/null)
                time=$(echo $time | cut -d: -f 2)
                #t2= $(("$time - $start")) 
                t2=$(expr $time - $start)
            
                echo -n "Yes;"
                echo -n "$f;$fexec;$fexecs;"
                echo -n "$score;;"
                echo -n "$size;"
                echo -n "$t2;"
                echo -n -e "$execs;"
                break
            done
        fi
        echo -n ";"
    done
    echo ""
done