#!/bin/bash

files=$(find ./level$1_$2/queue/ -maxdepth 1 -type f ! -name  '*.stats')
for f in $files
do  
    size="$(wc -c < "$f")" 
    echo -n "$f"
    echo -n -e "\t"
    echo -n "$size" 
    echo -n -e "\t"
    echo -n ' '
    (./smbcf $1 $size trace < $f  | cut -d, -f 1 | sort -n | tail -n 1)
done
files2=$(find ./level$1_$2/ijon_max/ -maxdepth 1 -type f ! -name  '*.stats')
for f in $files2
do  
    size="$(wc -c < "$f")" 
    echo -n "$f"
    echo -n -e "\t"
    echo -n "$size" 
    echo -n -e "\t"
    echo -n ' '
    (./smbcf $1 $size trace < $f  | cut -d, -f 1 | sort -n | tail -n 1)
done