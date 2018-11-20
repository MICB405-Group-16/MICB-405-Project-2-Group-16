#!/bin/sh
for f in ~/Project_2/1_Prokka_Output/*;
do
    folder=$( basename $f );
	echo $folder;
for aa in ~/Project_2/1_Prokka_Output/$folder/*.faa;
do
	aa_file=$( basename $aa );
	echo $aa_file
	cat ~/Project_2/1_Prokka_Output/$folder/$aa_file >>~/Project_2/1_Prokka_Output/aa_orfs.faa
done
for nuc in ~/Project_2/1_Prokka_Output/$folder/*.ffn;
do
	nuc_file=$( basename $nuc );
	echo $nuc_file
	cat ~/Project_2/1_Prokka_Output/$folder/$nuc_file >>~/Project_2/1_Prokka_Output/nuc_orfs.ffn
done
done