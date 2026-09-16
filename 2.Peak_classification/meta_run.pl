#!/usr/bin/perl
my @peak_files=@ARGV;

foreach my $peak (@peak_files){
	my $prefix=$peak;
	$prefix=~s/.+\///;
	$prefix=~s/.flt.clean.rmDup_peaks.narrowPeak//;
	`wc -l $peak > log.$prefix.all.count`;
	`bedtools closest -a $peak -b ./0.source_promoter/input.hg38.tss.bed -d > result1.$prefix.to_tss.distance`;
	`perl step1.count_promoter_region.pl $peak result1.$prefix.to_tss.distance > input1.$prefix.not_pmt.bed 2> log.$prefix.pmt.count`;

	my $enhancer_bed;
	if($peak =~ /RBM15_K562/){
		$enhancer_bed="./0.source_enhancer/K562.hg38.bed";
	}
	elsif($peak =~ /RBM15_HepG2/ or $peak =~ /RBM15_Hep3B/){
		$enhancer_bed="./0.source_enhancer/HepG2.hg38.bed";
	}
	elsif($peak =~ /RBM15_BGC/){
		$enhancer_bed="./0.source_enhancer/BGC.enhancer.bed";
	}
	elsif($peak =~ /RBM15_Hep3B/){
        $enhancer_bed="./0.source_enhancer/Hep3B.enhancer.bed";
        }
	else{
		die;
	}
	`bedtools intersect -a input1.$prefix.not_pmt.bed -b $enhancer_bed -u | wc -l > log.$prefix.enh.count`;
	`bedtools intersect -a input1.$prefix.not_pmt.bed -b $enhancer_bed -v > input1.$prefix.not_pmt.not_Enh.bed`;

	`bedtools intersect -a input1.$prefix.not_pmt.not_Enh.bed -b hg38.refseq.gene_element.and_intergenic.bed -wa -wb -f 0.51 > result2.$prefix.not_pmt.not_Enh.to_ele.overlap`;
	`perl step2.classify_other_peak.pl result2.$prefix.not_pmt.not_Enh.to_ele.overlap 2> log.$prefix.exon_intron_inter.count`;

	
}
