#!/bin/sh
echo 'MAG_ID,MAG_NUM' >>~/Project_2/2_Concatenated_Prokka_Output/mag_prokka_ref.csv
for f in ~/Project_2/1_Prokka_Output/*;
do
    folder=$( basename $f );
	echo $folder;
	for tsv in ~/Project_2/1_Prokka_Output/$folder/*.tsv;
	do
		tsv_file=$( basename $tsv );
		mag_id=$( head -n2 ~/Project_2/1_Prokka_Output/$folder/$tsv_file | tail -n1 | head -c8 )
		mag_number=$( echo $folder | awk -F "." '{ print $2 }' )
		echo $mag_id,$mag_number >>~/Project_2/2_Concatenated_Prokka_Output/mag_prokka_ref.csv
	done
done
