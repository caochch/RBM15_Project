#!/usr/bin/perl

my @bw_files=(
"../../../../2.trim/2.RBM15_HepG2_rep1/2.RBM15_HepG2_rep1.flt.clean.rmDup.RPM.bw"
);

foreach my $bw (@bw_files){
	my $prefix=$bw;
	$prefix=~s/.+\///;
	$prefix=~s/.flt.clean.rmDup.RPM.bw//;
	`bigWigAverageOverBed $bw ../1.quantGene_by_eCLIP/whole_gene_region.hg38.uniq.bed out1.$prefix.tab`;
	`perl step1.addChIP_to_CLIP.pl ../1.quantGene_by_eCLIP/out2.gene_RBM15ratio.xls out1.$prefix.tab > out2.gene_RBM15ratio.ChIP$prefix.xls`;
	`perl step2.separate_genes.pl out2.gene_RBM15ratio.ChIP$prefix.xls > out3.gene_RBM15ratio.ChIP$prefix.graded.xls`;
	`perl /home/caochch/selfBin/split_and_transpose_large_matrix.pl out3.gene_RBM15ratio.ChIP$prefix.graded.xls 1 out4.gene_RBM15ratio.ChIP$prefix.graded`;
}

