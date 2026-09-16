#!/usr/bin/perl
die "perl $0 whole_gene_region.hg38.bed\n" if(@ARGV != 1);
my $input_gene_bed=shift;

my %uniq;
open(IGV,$input_gene_bed) || die;
while(my $line=<IGV>){
	chomp $line;
	my @sub=split/\s+/,$line;
	if($sub[0] =~ /_/){
		next;
	}
	if(exists $uniq{$sub[3]}){
		next;
	}
	if($sub[2]-$sub[1] < 200){
		next;
	}
	$uniq{$sub[3]}=1;
	print $line,"\n";
}
