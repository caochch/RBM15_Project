#!/usr/bin/perl
die "perl $0 out2.gene_RBM15ratio.ChIP.xls\n" if(@ARGV != 1);
my $CLIP_ChIP_table=shift;

my %gene_CLIP;
my %gene_ChIP;
open(CCT,$CLIP_ChIP_table) || die;
while(my $line=<CCT>){
	chomp $line;
	my @sub=split/\s+/,$line;
	$gene_CLIP{$sub[3]}=$sub[6];
	$gene_ChIP{$sub[3]}=$sub[7];
}

my @sorted_genes=sort {$gene_CLIP{$a}<=>$gene_CLIP{$b}} keys %gene_CLIP;
my $num_in_each=($#sorted_genes+1)/3;
if($num_in_each == int($num_in_each)){
}
else{
	$num_in_each=int($num_in_each)+1;
}

my %group_value;
foreach my $i (0..$#sorted_genes){
	if($gene_ChIP{$sorted_genes[$i]} <= 1){
		next;
	}
	#my $ratio=log($gene_ChIP{$sorted_genes[$i]})/log(2);
	my $ratio=log($gene_ChIP{$sorted_genes[$i]})/log(10);
	#my $ratio=$gene_ChIP{$sorted_genes[$i]};
	my $group_idx=int($i/$num_in_each);
	$group_value{$group_idx}.=$ratio."\t";
}

foreach (sort {$a<=>$b} keys %group_value){
	print $_,"\t",$group_value{$_},"\n";
}
	
		
	
	
	
