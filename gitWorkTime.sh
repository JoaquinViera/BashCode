#!/bin/bash

# argument: name of folder or repo to analyze.

cd "$1"
git log | grep -B 3 'h:' | grep 'Author:' | sed 's/.*Author:\(.*\)<//' | sed 's/@fing\(.*\)>//'  > ../history.txt
git log | grep -B 3 'h:'| sed 'N;s/.*Merged\(.*\)\n/HOLA/g' | sed 'N;s/HOLA\(.*\)\n/HOLA/g' | sed '/^HOLA/ d' | grep  'h:' | sed 's/.*\(.*\)h://' > ../history2.txt
cd ..

paste history.txt history2.txt | sed 's/\t/ /' > FINAL.txt

#~ rm history.txt
#~ rm history2.txt


sum1=$(awk -F ''  '{sum1 += $9} END {print sum1}' FINAL.txt) 
sum2=$(awk -F ''  '{sum2 += $10} END {print sum2}' FINAL.txt)
sum4=$(awk -F ''  '{sum4 += $11} END {print sum4}' FINAL.txt)
sum5=$(awk -F ''  '{sum5 += $12} END {print sum5}' FINAL.txt)


if [ $sum5 -gt 9 ] ; 
then
	let sum4=$(($sum4 + "$sum5/10"))      
	let sum5=$(($sum5%10))
fi  

if [ $sum4 -gt 9 ] ; 
then 
	let	sum2=$(($sum2 + "$sum4/10"))
	let sum4=$(($sum4%10))
fi


if [ $sum2 -gt 9 ] ; 
then 
	let sum1=$(($sum1 + "$sum2/10"))
	let	sum2=$(($sum2%10))
fi
echo h:$sum1$sum2.$sum4$sum5

a=($(wc -l FINAL.txt)) ; # guardo como variable la salida de la cantidad de lineas en el archivo file.txt
declare -i i=1   # declaro variable como un entero


printf "\documentclass[11pt]{article}" > prueba.tex
printf "\\\begin{document} \n">> prueba.tex
for ((i=1;i<=$a;i+=1)); do 
  echo $i
  printf "%s" $(sed -n ""$i"p" FINAL.txt)  >> prueba.tex
	printf "\n" >> prueba.tex
done
printf "\\\end{document}" >> prueba.tex
