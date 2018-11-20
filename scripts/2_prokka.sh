#!/bin/sh
#gtdbtk ar is the archaea file
#gtdbtk bac is the bacteria
#tsv is a tab separated value
#for each of the relevant bins, it will tell you something like d__Archaea to tell you the domain
#metabat folder's medQplus tells you the fastqs for each of the MAGs

for f in /projects/micb405/resources/project_2/2018/SaanichInlet_150m/MetaBAT2_SaanichInlet_150m/MedQPlus_MAGs/*fa
do
    sid=$( basename $f | sed 's/.fa//g' )
    tax=$(grep -w $sid /projects/micb405/resources/project_2/2018/SaanichInlet_150m/MetaBAT2_SaanichInlet_150m/gtdbtk_output/gtdbtk.*.classification_pplacer.tsv | awk '{ print $2 }' | awk -F";" '{ print $1 }' | sed 's/d__//g')
    echo $sid,$tax
    prokka --kingdom $tax --outdir ~/Project_2/1_Prokka_Output/$sid/ --force $f
done

 