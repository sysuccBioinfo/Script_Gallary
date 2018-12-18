#!/bin/sh
#############Pipe line for WGS/WES/targeting sequencing data analysis################
#Version 2.1                                                                        #
#2016-10-18                                                                         #
#Authored by Qi Zhao  from Sun Yat-sen University Cancer center                     #
#email: zhaoqi@sysucc.org.cn                                                        #
#####Brief Introdution ####
#This data analysis pipeline were writing for processing raw sequencing data from   #
#WGS/WXS experiment. It contains several preprocessing steps and summary steps for  #
#evaluting data quality. Before using this shell script in you own system, you must #
#make sure the following softwares and tools were properly installed and configured,#
#which are:                                                                         #
#bwa,samtools,picard,gatk,qualimap.multiqc;                                         #
####################################################################################
#####################© 2016 Qi Zhao All Rights Reserved#############################
index=/CLS/sysu_rj_1/database/hg19/hg19_all_assembly/bwaIndex/genome.fa
#picard
picardjar=/CLS/sysu_rj_1/software/picard-tools-1.129/picard.jar
#GATK jarpath
gatkPath=/CLS/sysu_rj_1/software/GenomeAnalysisTK-3.3/GenomeAnalysisTK.jar

#thread num
nthread=24

#gatk knownsitefile
knowfile1=/CLS/sysu_rj_1/database/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf
knowfile2=/CLS/sysu_rj_1/database/1000G_phase1.indels.hg19.sites.vcf
knowfile3=/CLS/sysu_rj_1/database/dbsnp_138.hg19.vcf

#########################Path configuration#####################################
pwd=`pwd`
TEMPDIR=${pwd}/tmp
#create a temp dir avoiding inadequate disk space in default tmp folder of yor linux system
if [ ! -d "./tmp" ]; then
mkdir $TEMPDIR
fi
############Engage mapping step##########################
#get pure sample name information
bamfile=$1
name=$(basename "$bamfile" ".bam")
samplename=`echo $name | cut -d "_" -f1 `
echo $samplename
sample=$samplename
 #     java -jar $picardjar MarkDuplicates INPUT=$bamfile OUTPUT=${samplename}_sort_dedup.bam METRICS_FILE=${samplename}_metrics.txt TMP_DIR=$TEMPDIR
  #     sambamba index ${samplename}_sort_dedup.bam

##change Reads group #
#GATK process
#Local realignment around indels
       java -jar $gatkPath -T RealignerTargetCreator -R $index -I ${samplename}_sort_dedup.bam -known $knowfile1 -known $knowfile2 -o ${samplename}_target_intervals.list -nt 6
       java -jar $gatkPath -T IndelRealigner -R $index -I $bamfile -targetIntervals ${samplename}_target_intervals.list -known $knowfile1 -known $knowfile2 -o ${samplename}_sort_dedup_realigned.bam
       java -jar $gatkPath -T BaseRecalibrator -R $index \
			    -I ${samplename}_sort_dedup_realigned.bam \
			    -knownSites $knowfile3 -knownSites $knowfile1 -knownSites $knowfile2 \
			    -o ${samplename}_sort_dedup_realigned_recal.grp -nct 24
	java -jar $gatkPath -T BaseRecalibrator -R $index \
			    -I ${samplename}_sort_dedup_realigned.bam \
			    -BQSR ${samplename}_sort_dedup_realigned_recal.grp \
			    -knownSites $knowfile3 -knownSites $knowfile1 -knownSites $knowfile2 \
                            -o ${samplename}_sort_dedup_realigned_post_recal.grp -nct 24

	java -jar $gatkPath -T AnalyzeCovariates -R $index \
			    -before ${samplename}_sort_dedup_realigned_recal.grp \
			    -after ${samplename}_sort_dedup_realigned_post_recal.grp \
			    -csv ${samplename}_sort_dedup_realigned_BQSR.csv
	java -jar $gatkPath -T PrintReads -R $index \
			    -I ${samplename}_sort_dedup_realigned.bam \
			    -BQSR ${samplename}_sort_dedup_realigned_recal.grp \
			    -o ${samplename}_sort_dedup_realigned_recal.bam -nct 24
#genotyping germline mutation
##       java -jar $gatkPath -T HaplotypeCaller -R $index -I ${sample}_sort_dedup_realigned_recal.bam -o ${sample}_raw_variants.vcf -nct 24


