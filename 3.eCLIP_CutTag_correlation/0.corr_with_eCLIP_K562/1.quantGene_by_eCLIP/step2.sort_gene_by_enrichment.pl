#!/usr/bin/perl
die "perl $0 whole_gene_region.hg38.uniq.bed out1.RBM15.plus.tab out1.RBM15.minus.tab out1.input.plus.tab out1.input.minus.tab\n" if(@ARGV != 5);
my $whole_gene_bed=shift;
my $RBM15_plus_tab=shift;
my $RBM15_minus_tab=shift;
my $input_plus_tab=shift;
my $input_minus_tab=shift;

my %count_RBM15_plus=read_bw_tab($RBM15_plus_tab);
my %count_RBM15_minus=read_bw_tab($RBM15_minus_tab);
my %count_input_plus=read_bw_tab($input_plus_tab);
my %count_input_minus=read_bw_tab($input_minus_tab);

open(WGB,$whole_gene_bed) || die;
while(my $line=<WGB>){
	chomp $line;
	my @sub=split/\s+/,$line;
	if($sub[2]-$sub[1] < 200){
		next;
	}
	if($sub[0] =~ /chrM/ or $sub[3] =~ /SNORD/ or $sub[3] =~ /SNORA/ or $sub[3] =~ /RN7S/){
		next;
	}

	if($sub[5] eq "+"){
		my $input_sig=$count_input_plus{$sub[3]};
		if($input_sig <= 1 and $count_RBM15_plus{$sub[3]} <= 1){	#may be not expressed
			next;
		}
		$input_sig=$input_sig < 1 ? 1 : $input_sig;
		my $ratio=$count_RBM15_plus{$sub[3]}/$input_sig;
		print $line,"\t",$ratio,"\n";
	}
	elsif($sub[5] eq "-"){
		my $input_sig=$count_input_minus{$sub[3]};
		if($input_sig <= 1 and $count_RBM15_minus{$sub[3]} <= 1){	#may be not expressed
			next;
		}
		$input_sig=$input_sig < 1 ? 1 : $input_sig;
		my $ratio=$count_RBM15_minus{$sub[3]}/$input_sig;
		print $line,"\t",$ratio,"\n";
	}
	else{
		die;
	}
}

sub read_bw_tab{
	my $file=shift;
	my %hash;
	open(IN,$file) || die;
	while(my $line=<IN>){
		chomp $line;
		my @sub=split/\s+/,$line;
		$hash{$sub[0]}=abs($sub[4])*1000;	#to perKb
	}
	close IN;
	return %hash;
}
