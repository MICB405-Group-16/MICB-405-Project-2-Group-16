#!/bin/sh
header_done=false
for f in ~/Project_2/1_Prokka_Output/*;
do
    folder=$( basename $f );
	echo $folder;
	for tsv in ~/Project_2/1_Prokka_Output/$folder/*.tsv;
	do
		tsv_file=$( basename $tsv );
		echo $tsv_file
		if [ "$header_done" = false ]
		then
			cat ~/Project_2/1_Prokka_Output/$folder/$tsv_file >>~/Project_2/2_Concatenated_Prokka_Output/all_tsvs.tsv
			header_done=true
		else
			tail -n+2 ~/Project_2/1_Prokka_Output/$folder/$tsv_file >>~/Project_2/2_Concatenated_Prokka_Output/all_tsvs.tsv
		fi
	done
done
