#!/usr/bin/sh

for FILE in lattests/good/*.lat; do 
    echo $FILE; 
    ./latc $FILE; 
    echo ""; 
done >> tests_good.out 2>&1