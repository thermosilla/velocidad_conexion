#!/usr/bin/env bash

awk '{gsub ("\\(","",$3); gsub(",",".",$3); gsub("\\)","",$4); print $1, $2 ",", $3 ",", $4}' test-velocidad.txt > test-velocidad.csv
