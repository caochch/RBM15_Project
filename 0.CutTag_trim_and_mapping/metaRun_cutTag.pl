#!/usr/bin/perl
use strict;
my @samples=@ARGV;

open(TSH,">run.sh") || die;
foreach my $d (@samples){
	
        `mkdir $d`;
        my $tmp_raw_list=`ls ../1.rawdata/$d/*gz`;
        chomp $tmp_raw_list;
        my @tmp_raw_files=split/\n/,$tmp_raw_list;
        foreach (@tmp_raw_files){
                `ln -s ../$_ ./$d`;
        }
        my $file_list=`ls ./$d/*gz`;
        my @files=split/\n/,$file_list;
        my %command;
        foreach my $p (@files){
                my $f=(split/\//,$p)[-1];
                #print $f,"\n";
                if($f=~/.*_1.fq/ or $f=~/_R1_/){
                        $command{1}="gzip -d -c ./$d/$f > ./$d/read_1.fq\n";
                }
                elsif($f=~/.*_2.fq/ or $f=~/_R2_/){
                        $command{3}="gzip -d -c ./$d/$f > ./$d/read_2.fq\n";
                }
                else{
                        die;
                }
        }

        foreach (sort {$a <=> $b} keys %command){
                print TSH $command{$_};
        }
        #next;
        print TSH "fastqc --nogroup ./$d/read_1.fq -o ./$d \n";
        print TSH "fastqc --nogroup ./$d/read_2.fq -o ./$d \n";

        print TSH "java -jar /home/caochch/software/Trimmomatic-0.39/trimmomatic-0.39.jar PE -phred33 -threads 20 -quiet ./$d/read_1.fq ./$d/read_2.fq ./$d/read_1.clean.pair.fq ./$d/read_1.clean.unpair.fq ./$d/read_2.clean.pair.fq ./$d/read_2.clean.unpair.fq ILLUMINACLIP:./adapters.fa:2:30:10:8:true HEADCROP:10 LEADING:15 TRAILING:10 SLIDINGWINDOW:4:15 MINLEN:30\n";

        print TSH "fastqc --nogroup -t 2 ./$d/read_1.clean.pair.fq ./$d/read_2.clean.pair.fq \n";

        print TSH "bwa mem -t 16 /home/caochch/BWAindex/GRCh38.p13.genome.fa ./$d/read_1.clean.pair.fq ./$d/read_2.clean.pair.fq > ./$d/$d.sam\n";
        print TSH "samtools view -h -F 2048 -S -o ./$d/$d.noSuppAlign.sam ./$d/$d.sam\n";

        print TSH "perl select_mapped_and_unmap.pl ./$d/$d.noSuppAlign.sam ./$d/read_1.clean.pair.fq ./$d/read_2.clean.pair.fq ./$d/$d.noSuppAlign.byBWA\n";
        my $mapped_num=`wc -l ./$d/$d.noSuppAlign.byBWA.unmapped.read1.fq`;
        print $mapped_num;

        print TSH "samtools view -bSo ./$d/$d.bam ./$d/$d.noSuppAlign.byBWA.mapped.sam\n";
        print TSH "samtools sort -o ./$d/$d.sort.bam ./$d/$d.bam\n";
        print TSH "samtools view -h -q 10 -b ./$d/$d.sort.bam > ./$d/$d.flt.bam\n";
        print TSH "java -jar /home/caochch/software/picard2.27.5/picard.jar CleanSam I=./$d/$d.flt.bam O=./$d/$d.flt.clean.bam\n";
        print TSH "java -jar /home/caochch/software/picard2.27.5/picard.jar MarkDuplicates I=./$d/$d.flt.clean.bam O=./$d/$d.flt.clean.rmDup.bam M=./$d/$d.rmDup.metrics.txt REMOVE_DUPLICATES=true\n";
        print TSH "samtools index ./$d/$d.flt.clean.rmDup.bam\n";
	print TSH "samtools sort -@ 10 -o ./$d/$d.flt.clean.rmDup.sort.bam ./$d/$d.flt.clean.rmDup.bam\n";
	print TSH "samtools index ./$d/$d.flt.clean.rmDup.sort.bam\n";

}
