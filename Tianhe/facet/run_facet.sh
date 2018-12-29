#!/bin/sh
tumor=$1
normal=$2

vcfpath=~/database/hg19/FACET_lib/GRCh37p13_b151.vcf.gz

# get pileup files 
~/software/snp-pileup/snp-pileup -g -q15 -Q20 -P100 -r25,0 \
				 $vcfpath ${tumor}.csv  ${normal}_sort_dedup_realigned_recal.bam ${tumor}_sort_dedup_realigned_recal.bam  

# remove chrX fiel 
zcat ${tumor}.csv | grep -v chrM | gzip - > $tumor.rm.chrM.csv.gz

# run FACET 
Rscript FACETS.R $tumor.rm.chrM.csv.gz $tumor

