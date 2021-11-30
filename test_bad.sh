#!/usr/bin/sh

for FILE in lattests/bad/*.lat; do 
    echo $FILE; 
    ./latc $FILE; 
    echo ""; 
done >> tests_bad.out 2>&1