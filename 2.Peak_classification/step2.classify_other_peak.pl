#!/usr/bin/perl
die "perl $0 not_pmt.not_Enh.to_ele.overlap\n" if(@ARGV != 1);
my $overlap_table=shift;

my %peak_ele;
open(OT,$overlap_table) || die;
while(my $line=<OT>){
	chomp $line;
	my @sub=split/\s+/,$line;
	$peak_ele{$sub[3]}{$sub[-2]}=1;
}

foreach (keys %peak_ele){
	my %attr=%{$peak_ele{$_}};
	if(exists $attr{"NCExon"} or exists $attr{"PC3UTR"} or exists $attr{"PC5UTR"} or exists $attr{"PCCDS"}){
		$count_exon++;
		next;
	}
	if(exists $attr{"NCIntron"} or exists $attr{"PCIntron"}){
		$count_intron++;
		next;
	}
	if(!exists $attr{"Intergenic"}){
		print $_,"\taaa\n";
		print %attr,"\n";
		die;
	}
	else{
		$count_intergenic++;
	}
}

warn $count_exon,"\t",$count_intron,"\t",$count_intergenic,"\n";

