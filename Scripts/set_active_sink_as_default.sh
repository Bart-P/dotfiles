#!/bin/bash 

# get list of sinks, filter status running and line before, take only first line, cut out everything before (incl) # 
pactl list sinks | grep -B 1 RUNNING | head -n 1 | cut -d "#" -f2
