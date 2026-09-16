#!/usr/bin/perl
die "perl $0 CLIP.ratio ChIP.tab\n" if(@ARGV != 2);
my $CLIP_ratio_table=shift;
my $ChIP_count_table=shift;

my %count_ChIP=read_bw_tab($ChIP_count_table);

open(CRT,$CLIP_ratio_table) || die;
while(my $line=<CRT>){
	chomp $line;
	my @sub=split/\s+/,$line;
	if(exists $count_ChIP{$sub[3]}){
		print $line,"\t",$count_ChIP{$sub[3]},"\n";
	}
	else{
		print $line,"\t0\n";
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
