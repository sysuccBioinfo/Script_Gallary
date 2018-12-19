#!/bin/sh
bamfile=$1
bedfile=/CLS/sysu_rj_1/database/hg19/exome_seq_bed/bed_exomeseq_V6/Exon_haploxbed
samtools mpileup -l $bedfile -q 20 $bamfile | gzip >  ${bamfile%%_sort_dedup_realigned_recal.bam}.pileup.gz
