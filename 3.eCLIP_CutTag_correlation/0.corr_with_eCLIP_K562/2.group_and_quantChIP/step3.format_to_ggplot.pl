#!/usr/bin/perl
die "perl $0 out3.gene_RBM15ratio.ChIP2.RBM15_HepG2_rep1.graded.xls\n" if(@ARGV != 1);
my $quantify_table=shift;

open(QT,$quantify_table) || die;
while(my $line=<QT>){
	chomp $line;
	my @sub=split/\s+/,$line;
	my $level=shift @sub;
	my $grade;
	if($level == 0){
		$grade="Low";
	}
	elsif($level == 1){
		$grade="Medium";
	}
	elsif($level == 2){
		$grade="High";
	}
	else{
		die;
	}

	foreach (@sub){
		print $grade,"\t",$_,"\n";
	}
}
