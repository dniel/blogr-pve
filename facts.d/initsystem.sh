#!/bin/bash
echo "initsystem=$(ls -l /proc/1/exe | awk '{n=split($NF, N, "/"); { print N[n] }}')"
exit
