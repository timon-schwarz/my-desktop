#!/bin/bash
for (( i=11; i != 0; i-- ))
do
    hyprctl dispatch workspace $i
done

