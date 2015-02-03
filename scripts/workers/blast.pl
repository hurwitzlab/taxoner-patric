#! /uaopt/perl/5.14.2/bin/perl 

use strict;

if (@ARGV != 3) {  die "Usage: blast.pl indir filename arrayct \n"; }

my $indir = shift @ARGV;
my $filename = shift @ARGV;
$filename =~ s/.*\///;
my $arrayct = shift @ARGV;
my $query = $indir . "/query/" . $filename . "/query." . $arrayct; 
my $scripts = $indir . "/" . "scripts";
my $outdir = $indir . "/" . $filename;

open (DBS, "$indir/blastdbs") || die "Cannot open blastdbs file\n";

if ( -d $outdir ) {
   # do nothing
} else {
  `mkdir $outdir`;
}

while (<DBS>) {
   chomp $_;
   my ($bldbname, $type, $blastdb) = split (/\t/, $_);
   my $dir = $outdir . "/" . $bldbname;
   `cd $dir`;
   my $boutfile = "blastout." . $arrayct;
   my $poutfile = "parse." . $arrayct;
   my $bout = $outdir . "/" . $bldbname . "/" . "blast-out/" . $boutfile;
   my $pout = $outdir . "/" . $bldbname . "/" . "parse-out/" . $poutfile;
   my $tout = $outdir . "/" . $bldbname . "/" . "tophit-out/" . $poutfile;
   my $program1 = "/rsgrps1/mbsulli/bioinfo/biotools/blast-2.2.22/bin/blastall -a 12 -p $type";
   my $program2 = "$scripts/parse_blastout.pl";
   my $program3 = "$scripts/parse_blastout2.pl";
   my $desc = 10;
   my $aln = 10;
   my $eval = '1e-3';
      
   # run blast
   `$program1 -i $query -o $bout -v $desc -b $aln -d $blastdb -e $eval`;

   # parse blast
   `$program2 $bout >> $pout`;

   # get tophit
   `$program3 $bout >> $tout`;  

   `cd $indir`;

}

