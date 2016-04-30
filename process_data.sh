#!/usr/bin/env bash
rm test-velocidad.txt
rsync -aA nuc:test-velocidad.txt .
awk '{gsub ("\\(","",$3); gsub(",",".",$3); gsub("\\)","",$4); print $1, $2 ",", $3 ",", $4}' test-velocidad.txt > test-velocidad.txt
Rscript velocidad_navegacion.r
xdg-open velocidad_navegacion.html
