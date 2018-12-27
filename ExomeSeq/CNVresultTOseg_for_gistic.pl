#!/usr/bin/perl -w
#transfer GVC cnv.simp output into segment file for gistic 
#released by meimei	2018/12/27
#usage: perl seg_for_gistic.pl *.cnv.simp > *_seg.txt

open IN, shift or die;

readline IN;
my $sample = "1001073";

while(<IN>){
	chomp;
	my @tmp = split /\t/, $_;
	print "$sample\t$tmp[0]\t$tmp[1]\t$tmp[3]\t$tmp[9]\t$tmp[4]\n";	
}
