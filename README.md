# Project-2
This repository contains all the data and scripts needed to replicate most of our pipeline for Project 2 of MICB 405, provided you have the data. Scripts have not been appended together into a master script, however they are numbered in their logical order of execution. 

Note: If you get complaints with shell scripts about a bad interpreter with a ^M at the end, follow this page: https://stackoverflow.com/questions/2920416/configure-bin-shm-bad-interpreter

ie. Open your script with vim, type :set fileformat=unix, hit Enter, then save with :wq

# Folder Rundown
## 0_Initial_Data
Raw data from the metagenome assembly and binning steps.

## 2_Concatenated_Prokka_Output
Contains the concatenated metadata files output by Prokka such as the TSV of all the predicted ORF metadata, and a table that maps Prokka IDs (eg. ABCDEFGH) to MAG numbers (eg. 10, 103).

## 3_Transcriptome_Output
Contains FastQC output for our transcriptome reads. Not actually used.

## 4_RPKM_Output
RPKM files for each set of transcriptome reads aligned to Prokka predicted ORFs.

## 5_KEGG_Output
Contains the KO TSV file that KAAS output on our ORFs.

## 6_Pathview
Pathway for pathview. Doesn't actually contain anything worth looking at.

## 7_Pathways
Contains the data tables for the binary matrices that visualize contribution of each class in nitrogen cycle (and sulfate reduction) pathways.

## Viz
Contains all figures generated from R.

### Chemical
Plots Saanich Inlet Time Series Chemical Data.

3_Chemical_Comparison.png compares sulfide, nitrate, and oxygen against each other.
All_Chemicals_vs_Date.png compares sulfide, nitrate, and oxygen against time.
Nitrogenous_Compounds_By_Date.png compares various producuts of the nitrogen cycle against time.

### MAG
Each figure visualizes metadata from our MAGs. Avg_Mag_Stats_By_Class.png shows contamination and completeness for all the high quality and medium quality MAGs aggregated by taxonomic class. MAG_Stats.png plots contamination and completeness for all MAGs and scales their dot size by RPKM. MAG_Count_And_RPKM_By_Class.png shows how many MAGs make up each taxonomic class and their total RPKM.

### Pathview
Each figure is output from Pathview for a given data context. For example, Aggregated shows existence of nitrogen and sulfur metabolism enzymes for all taxa combined. Aggregated_Kingdom does the same thing but splits Bacteria and Archaea. Aggregated_Class further splits every taxa into classes.

### Pathway_Dot_Plot
Each figure shows all the taxonomic microbial classes and steps in a given pathway. If there is a dot at an intercept between a pathway step and a class, then that class expresses an enzyme that catalyzes the step.

## data
Contains a local copy of the Saanich Time Series Chemical (1)

## scripts
Contains all the shell scripts we used during our pipeline:
1) Creates all directories
2) Execute Prokka
3) Concatenate all the Prokka amino acid FASTAs into one file and all the Prokka nucleotide FASTAs into another file to capture all ORFs.
4) Index our nucleotide ORF FASTA from step 3
5) Align transcriptome reads to our ORFs
6) FastQC on transcriptome reads (we don't actually do anything with this)
7) Calculate RPKM from our alignment in step 5
8) Concatenate all the TSVs output by Prokka; only the first file concatenated keeps the header row. This is to get metadata on all the ORFs.
9) Makes a table that maps all the Prokka MAG ID's (eg. ABCDEFGH) to their respective MAG numbers (eg. 10) for joining tables in R.

# R Script Rundown
## Chemical_Data.R
Visualizes the Saanich Chemical Time Series Data

## MAGStats.R
Visualizes MAG quality (eg. Contamination vs Completeness)

## MAG_ORF_Stats.R
Calculates some statistics on Prokka output - 16S rRNA count and range of ORF numbers for each MAG.

## Pathways.R
Processes the files in https://github.com/MICB405-Group-16/MICB-405-Project-2-Group-16/tree/master/7_Pathways to generate the dot plots for each nitrogen pathway.

## Transcriptome_RPKM.R
Processes transcriptome data for Pathview

# References
1. Torres-Beltran, M. Dryad Digital Repository http://dx.doi.org/10.5061/dryad.nh035 (2017)
