#!/bin/sh
for fastq in /projects/micb405/resources/project_2/2018/Metatranscriptomes/*_150m.qtrim.*;
do
	file_name=$( basename $fastq );
	prefix=$(echo $file_name | sed 's/.qtrim.*//g');
	echo $file_name, $prefix;
	bwa mem -t 8 ~/Project_2/3_Metatranscriptome_Output/index/orf_index \
	/projects/micb405/resources/project_2/2018/Metatranscriptomes/$file_name \
	1>~/Project_2/3_Metatranscriptome_Output/BWA_Output/$prefix\.sam \
	2>~/Project_2/3_Metatranscriptome_Output/BWA_Output/$prefix\.log.txt
done
	