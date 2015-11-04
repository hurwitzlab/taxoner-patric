#!/usr/bin/env perl

$| = 1;

use strict;
use warnings;
use feature 'say';
use autodie;
use Cwd 'cwd';
use File::Basename qw(basename fileparse);
use File::Path;
use File::Spec::Functions;
use Getopt::Long;
use Pod::Usage;

my ($file, $out1, $out2);
my $verbose     = 0;
my ($help, $man_page);

GetOptions(
    'f|file=s'           => \$file,
    'o1|out1=s'            => \$out1,
    'o2|out2=s'            => \$out2,
    'v|verbose'          => \$verbose,
    'help'               => \$help,
    'man'                => \$man_page
) or pod2usage(2);

if ($help || $man_page) {
    pod2usage({
        -exitval => 0,
        -verbose => $man_page ? 2 : 1
    });
}

open my $FILE, '<', $file;
open my $OUT1, '>', $out1;
open my $OUT2, '>', $out2; 

my %id_to_feature = ();
my %feature_to_count = ();
while (<$FILE>) {
   chomp $_;
   if ($_ =~ /:/) {
      my @cols = split(/,/, $_);
      # 81,MERCURE:0109:0:4:1101:16599:166526/1,101,5,2,32,K09118,0.852
      my $id = $cols[1];
      my $feature = $cols[6];
      push (@{$id_to_feature{$id}}, $feature);
      $feature_to_count{$feature}++;
   }
}

for my $id (keys %id_to_feature) {
   print $OUT1 "$id\t$id_to_feature{$id}[0]\n";
}

for my $feature (keys %feature_to_count) {
   print $OUT2 "$feature\t$feature_to_count{$feature}\n";
}

