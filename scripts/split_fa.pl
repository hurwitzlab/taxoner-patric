#! /uaopt/perl/5.14.2/bin/perl 

use strict;

if (@ARGV != 4) {  die "Usage: filename indir outdir jobs\n"; }

my $filename = shift @ARGV;
$filename =~ s/.*\///;
my $indir = shift @ARGV;
my $outdir = shift @ARGV;
my $jobs = shift @ARGV;

my $splitdir = $outdir . "/" . $filename;
`mkdir $splitdir`;
my $infa = $indir . "/" . $filename;
`cp $infa $splitdir`;
`./scripts/create_jobarray_fasta.pl -i $splitdir -o $splitdir -j $jobs`;
