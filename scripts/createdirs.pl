#! /uaopt/perl/5.14.2/bin/perl 

use strict;

if (@ARGV != 2) {  die "Usage: createdirs.pl indir file\n"; }

my $indir = shift @ARGV;
my $filename = shift @ARGV;
$filename =~ s/.*\///;
my $scripts = $indir . "/" . "scripts";
my $outdir = $indir . "/" . $filename;

open (DBS, "$indir/blastdbs") || die "Cannot open blastdbs file\n";

if (-d $outdir) {
   # do nothing
}
else {
`mkdir $outdir`;
}

while (<DBS>) {
   chomp $_;
   my ($bldbname, $type, $blastdb) = split (/\t/, $_);
   my $dir = $outdir . "/" . $bldbname;
   `mkdir $dir`;
   `mkdir $dir/blast-out`;
   `mkdir $dir/final-out`;
   `mkdir $dir/parse-out`;
   `mkdir $dir/tophit-out`;
} 



