#!/bin/sh
for sam in ~/Project_2/3_Metatranscriptome_Output/BWA_Output/*.sam;
do
	prefix=$(basename $sam | sed 's/.sam//g');
	/projects/micb405/resources/project_2/2018/rpkm \
	-c ~/Project_2/2_Concatenated_Prokka_Output/nuc_orfs.ffn \
	-a ~/Project_2/3_Metatranscriptome_Output/BWA_Output/$prefix\.sam \
	-o ~/Project_2/4_RPKM_Output/$prefix\_RPKM.csv
done
