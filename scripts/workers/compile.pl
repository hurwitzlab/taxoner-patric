#!/usr/bin/env perl

if (@ARGV != 2) { die "Usage: Compile.pl directory output\n"; }

my $dir = shift @ARGV;
my $out = shift @ARGV;

opendir DIR, "$dir"
    or die "Cannot open directory: $dir\n";
my @files = readdir DIR;
close DIR;

open (OUT, ">$out") || die "Cannot open outfile\n";

for my $file (@files) {
  open (F, "$dir/$file") || die "cannot open file\n";
  while (<F>) {
     print OUT $_;
  }
  close F;
}

close OUT;

