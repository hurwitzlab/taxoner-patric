#! /uaopt/perl/5.14.2/bin/perl 

use strict;

if (@ARGV != 2) {  die "Usage: assemble_blast.pl indir filename\n"; }

my $indir = shift @ARGV;
my $filename = shift @ARGV;
$filename =~ s/.*\///;
my $scripts = $indir . "/" . "scripts";
my $outdir = $indir . "/" . $filename;

open (DBS, "$indir/blastdbs") || die "Cannot open blastdbs file\n";

while (<DBS>) {
   chomp $_;
   my ($bldbname, $type, $blastdb) = split (/\t/, $_);
   my $dir = $outdir . "/" . $bldbname;
   `cd $dir`;
   my $toutdir = $outdir . "/" . $bldbname . "/" . "tophit-out";
   my $fout = $outdir . "/" . $bldbname . "/final-out/all_tophit";
   my $program4 = "$scripts/compile.pl";

   # compile tophits
   `$program4 $toutdir $fout`; 
}

