#!/usr/bin/env bash
rm test-velocidad.txt
rsync -aA nuc:test-velocidad.txt .
cat test-velocidad.txt | grep -v Read > test-velocidad-2.txt
mv test-velocidad-2.txt test-velocidad.txt
awk '{gsub ("\\(","",$3); gsub(",",".",$3); gsub("\\)","",$4); print $1, $2 ",", $3 ",", $4}' test-velocidad.txt > test-velocidad.csv
R -e 'library(rmarkdown);rmarkdown::render("velocidad_navegacion.rmd")'
xdg-open velocidad_navegacion.html
aws s3 cp velocidad_navegacion.html s3://blog.thermosilla.info
