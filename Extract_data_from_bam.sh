#using star output bamfile as example 
#!/bin/sh
bamin=$1
#extract reads aligned to chr2
sambamba view -F "ref_id==24 and mapping_quality >= 50 " -f bam $bamin -o ${bamin%%.sort.bam}_chr22.bam
#sort reads by names if not presorted by software
sambamba sort -n ${bamin%%.sort.bam}_chr22.bam -o ${bamin%%.sort.bam}_chr22.sort.bam
#bam2fastq
bam2fq.py -i ${bamin%%.sort.bam}_chr22.sort.bam -o ${bamin%%.sort.bam} -c 
