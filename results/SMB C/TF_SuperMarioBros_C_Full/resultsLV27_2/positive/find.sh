#!/bin/bash

files=$(find . -type f -name "*.cmdargs.txt")
for f in $files
do  
    cut -f 3 --delimiter=" " $f 
done


#| sort -n | tail -n 1