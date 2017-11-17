#!/bin/bash

total=$(nvidia-smi -q -d MEMORY|grep -A 3 'FB Memory' | grep 'Total' | cut -c 38-42)
used=$(nvidia-smi -q -d MEMORY|grep -A 3 'FB Memory' | grep 'Used' | cut -c 38-41)

echo $total $used | awk '{ print $2/$1 }' | awk '{ print 100 * $1 }' 
#| cut -c1,4
