#! /uaopt/perl/5.14.2/bin/perl
 
use strict;
use Getopt::Std;
use Bio::SeqIO;
use Bio::Seq;
 
$|=1;
 
###############################################
# create_jobarray_fasta.pl 
# Bonnie Hurwitz 
# 20070301 
# input: a directory with one or more fasta files 
# output: a directory with fasta files in jobarray
#         format 
################################################
 
# Usage:
my %opts = ();
getopts('hi:o:j:', \%opts);
usage() if (exists $opts{'h'});
 
################################################################
# Global Variables
################################################################

my $indir        = $opts{'i'} || usage();
my $outdir       = $opts{'o'} || usage();
my $jobs         = $opts{'j'} || '500';  #number of jobs in the array 

#read files
opendir DIR, "$indir"
    or die "Cannot open directory: $indir\n";
my @files = readdir DIR;
close DIR;

open (FASTA, ">$outdir/all_seqs") || die "Cannot open temp all seqs file\n";
my $total_sequences = 0;
for my $file (@files) {
   if ($file =~ /^\./) { next; }
   open (FILE, "$indir/$file") || die "Cannot open indir fasta file: $file\n";
   while (<FILE>) {
       if ($_ =~ /^>/) { $total_sequences++; }
       print FASTA $_;
   }
   close FILE;
}

close FASTA;

#split fasta file and write into job array scratch space
my $infile = $outdir . "/all_seqs";
split_fasta($infile,$jobs);
unlink($infile);

# Usage Sub: to print the usage statement
sub usage{
   my $program = `basename $0`; chomp ($program);
   print "
 
      $program splits up fasta files in a directory into fasta 
               files based on the desired number of jobs for running
               in a job array 
      $program -p program -i /path/to/fa_files -o /path/to/jobarray_fa_files
 
      $program -h (displays this message)
      
   ";
   exit 1;
}

sub split_fasta {
    my ($infile,$files_wanted) = @_;
    my $seq_per_file = int(($total_sequences / $files_wanted) + 1);
    my $filename = 'query';
    my $in  = Bio::SeqIO->new(   
        -file   => $infile,
        -format => 'Fasta',
    );    
    my $file_counter = 1;
    my $outfile = $outdir . '/' . $filename . '.' . $file_counter;

    my $out= Bio::SeqIO->new(
         -format => 'Fasta',
         -file   => ">$outfile",
    );
    my $current_seq_count = 0;
    my $total_seq_count = 0;
    SQ:
    while (my $seqobj = $in->next_seq()) {
        $current_seq_count++;
        $total_seq_count++;
        $out->write_seq($seqobj);
        if ($total_seq_count == $total_sequences) { last SQ; }
   	    if ($current_seq_count == $seq_per_file) {
               # reset the seq count and change the out file
               $current_seq_count = 0;
               $file_counter++;
               $outfile = $outdir . '/' . $filename . '.' . $file_counter;
               $out= Bio::SeqIO->new(
                  -format => 'Fasta',
                  -file   => ">$outfile",
               );
      	}
	
    }
}
