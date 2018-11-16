#!/bin/sh
#gtdbtk ar is the archaea file
#gtdbtk bac is the bacteria
#tsv is a tab separated value
#for each of the relevant bins, it will tell you something like d__Archaea to tell you the domain
#metabat folder's medQplus tells you the fastqs for each of the MAGs

for f in MetaBAT2_SaanichInlet_150m/MedQPlus_MAGs/*fa;
do	
	bin=$(basename $f | sed 's/.fa//g');
	#gets the classification column
	# searches with the whole word of the bin, extracts column 2, delimits by semicolon, gets column 1 which is the domain, parses the string
	tax = $(grep -w $bin MetaBAT2_SaanichInlet_150m/gtdbtk_output/gtdbtk.*.classification_pplacer.tsv | awk '{ print $2}' | awk -F";" '{ print $1}' | sed 's/d__//g' ); 
	#use out dynamically computed taxon to run prokka
	#echo $bin;
	#echo $tax | less -S; #gets you all the Bin IDs
	prokka --kingdom $tax --outdir ~/ProcessedData/Prokka_output $f;
done