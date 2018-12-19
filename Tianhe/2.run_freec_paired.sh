#!/bin/sh
tumor=$1
normal=$2
samplename=${tumor}
#path=`pwd`
#write config file 
mkdir ${samplename}_freec2
cd ${samplename}_freec2
ln -s ../${tumor}.pileup.gz .
ln -s ../${normal}.pileup.gz .

#unset LD_LIBRARY_PATH
echo "[general]" > ${samplename}_freec_config.txt
echo "chrLenFile = /CLS/sysu_rj_1/database/hg19/freecLib/genome.fa.fai" >> ${samplename}_freec_config.txt
echo "window = 0" >> ${samplename}_freec_config.txt
echo "ploidy = 2" >> ${samplename}_freec_config.txt
echo "outputDir = . " >> ${samplename}_freec_config.txt
echo "sex=XX" >> ${samplename}_freec_config.txt
echo "breakPointType=4" >> ${samplename}_freec_config.txt
echo "chrFiles = /CLS/sysu_rj_1/database/hg19/freecLib/chromosomes" >> ${samplename}_freec_config.txt
echo "bedtools = /CLS/sysu_rj_1/software/bedtools2/bin/bedtools" >> ${samplename}_freec_config.txt
echo "sambamba = ~/bin/sambamba" >> ${samplename}_freec_config.txt
echo "SambambaThreads = 23" >> ${samplename}_freec_config.txt
echo "samtools = samtools" >> ${samplename}_freec_config.txt
echo "maxThreads=23" >> ${samplename}_freec_config.txt
echo "breakPointThreshold=0.8" >> ${samplename}_freec_config.txt
echo "noisyData=TRUE" >> ${samplename}_freec_config.txt
echo "printNA=FALSE" >> ${samplename}_freec_config.txt
echo "readCountThreshold=10" >> ${samplename}_freec_config.txt
echo "[sample]" >> ${samplename}_freec_config.txt
echo "mateFile = ${tumor}.pileup.gz" >> ${samplename}_freec_config.txt
echo "inputFormat = pileup" >> ${samplename}_freec_config.txt
echo "mateOrientation = FR" >> ${samplename}_freec_config.txt
echo "[control]" >> ${samplename}_freec_config.txt
echo "mateFile = ${normal}.pileup.gz" >> ${samplename}_freec_config.txt
echo "inputFormat = pileup" >> ${samplename}_freec_config.txt
echo "mateOrientation = FR" >> ${samplename}_freec_config.txt
echo "[BAF]" >> ${samplename}_freec_config.txt
#echo "makePileup =  /CLS/sysu_rj_1/database/hg19/freecLib/hg19_snp142.SingleDiNucl.1based.bed" >> ${samplename}_freec_config.txt
echo "fastaFile = /CLS/sysu_rj_1/database/hg19/freecLib/genome.fa" >> ${samplename}_freec_config.txt
echo "SNPfile = /CLS/sysu_rj_1/database/hg19/freecLib/hg19_snp142.SingleDiNucl.1based.txt" >> ${samplename}_freec_config.txt
echo "minimalCoveragePerPosition = 5" >> ${samplename}_freec_config.txt
echo "[target]" >> ${samplename}_freec_config.txt
echo "captureRegions = /CLS/sysu_rj_1/database/hg19/freecLib/freec_nuohe_target_V6.bed" >> ${samplename}_freec_config.txt


#set env
#module load glibc/2.14
#source /BIGDATA/app/toolshs/cnmodule.sh
#module load samtools
#module load glibc/2.14
#module load R/3.4.0
#running command 
freec -conf ${samplename}_freec_config.txt > ${samplename}_freec.log 
