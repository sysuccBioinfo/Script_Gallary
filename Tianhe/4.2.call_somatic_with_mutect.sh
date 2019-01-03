#!/bin/sh
################# Configuration ########################
gatkpath=/CLS/sysu_rj_1/software/GATK4/gatk-package-4.0.2.1-local.jar

GENOME=/CLS/sysu_rj_1/database/hg19/IntegrateVirus/genomeAll.fa
COSMIC=/CLS/sysu_rj_1/database/FormuTect/b37_cosmic_v54_120711.vcf  
DBSNP=/CLS/sysu_rj_1/database/ForGATK/dbsnp-147.v2.vcf   
target=/CLS/sysu_rj_1/database/hg19/exome_seq_bed/V6_nuohe/target_for_mutect.bed

#Annovar 
annovarpath=~/software/annovar



############# Mutect2 ###################
# setting input 
file=$1
tumor=${file}_sort_dedup_realigned_recal.bam
normalfile=$2
normal=${normalfile}_sort_dedup_realigned_recal.bam

#extract name from bamfile 
	#tumorname=`samtools view -H ${tumor} | grep SM| head -n 1 | cut -f 4 | cut -f 2 -d ":"`
tumorname=`samtools view -H ${tumor} | grep SM | head -n 1| perl -wanle'/SM:(\S+)/;print $1'`
normalname=`samtools view -H ${normal} | grep SM  | head -n 1 | perl -wanle'/SM:(\S+)/;print $1'`

#get PONfile 
java -jar $gatkpath Mutect2 \
-R $GENOME \
-I $normal \
-tumor $normalname \
--disable-read-filter MateOnSameContigOrNoMappedMateReadFilter \
-L $target \
--native-pair-hmm-threads 23 \
-O ${normalname}.pon.vcf.gz



#run mutect2
java -Xmx2g -jar $gatkpath Mutect2 -R $GENOME -I ${tumor} -I ${normal} -tumor $tumorname -normal $normalname -pon ${normalname}.pon.vcf.gz -O ${file}.somatic.vcf 

#run filter Mutect
java -jar $gatkpath FilterMutectCalls -V ${file}.somatic.vcf -O ${file}.somatic.filter_mark.vcf

# hard filter 

java -jar $gatkpath SelectVariants -R $GENOME -V ${file}.somatic.filter_mark.vcf -select "vc.isNotFiltered()" -O ${file}.somatic.filter.HC.vcf

############## Annovar ###################
# run annovar 

$annovarpath/convert2annovar.pl -format vcf4 -allsample -withfreq  --includeinfo ${file}.somatic.filter.HC.vcf > ${file}.somatic.avinput
$annovarpath/table_annovar.pl ${file}.somatic.avinput $annovarpath/humandb -buildver hg19 \
        -out ${file}.somatic.anno -remove \
        -otherinfo \
        -protocol refGene,cosmic70,avsnp147,ALL.sites.2015_08_edit,EAS.sites.2015_08_edit,esp6500siv2_all,exac03,ljb26_all,clinvar \
        -operation g,f,f,f,f,f,f,f,f
