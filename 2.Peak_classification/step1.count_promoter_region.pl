#!/usr/bin/perl
die "perl $0 input_peak result1.1.RBM15_BGC.to_tss.distance\n" if(@ARGV != 2);
my $all_peak_bed=shift;
my $peak_to_tss_dis_table=shift;

my %closest;
open(PTD,$peak_to_tss_dis_table) || die;
while(my $line=<PTD>){
	chomp $line;
	my @sub=split/\s+/,$line;
	$closest{$sub[3]}=$sub[-1];
}

open(APB,$all_peak_bed) || die;
while(my $line=<APB>){
	chomp $line;
	my @sub=split/\s+/,$line;
	if(exists $closest{$sub[3]}){
		my $dis=$closest{$sub[3]};
		if($dis <= 500){
			$count_500++;
			next;
		}
		if($dis <= 1000){
			$count_1000++;
			next;
		}
		if($dis <= 2000){
			$count_2000++;
			next;
		}
		if($dis <= 5000){
			$count_5000++;
			next;
		}
		print $line,"\n";	#> 5kb
	}
	else{
		print $line,"\n";
	}
}
	
warn $count_500,"\t",$count_1000,"\t",$count_2000,"\t",$count_5000,"\n";

