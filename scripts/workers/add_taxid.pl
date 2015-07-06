#!/usr/bin/env perl

# --------------------------------------------------

=pod

=head1 NAME

add_taxid.pl

=head1 SYNOPSIS

add_taxid.pl -i|--input [Blast results] -o|--output [Output directory] -s|--simap [simap directory] -n|--ncbi [ncbi taxid directory]

Options:

 -h|--help     Show brief help and exit
 -v|--version  Show version and exit
 -i|--input    Blast results against simap
 -o|--output   Output directory
 -s|--simap    Simap direcotry
 -n|--ncbi     NCBI Taxid directory

=head1 DESCRIPTION

Adds NCBI Taxid to Blast Results against Simap DB

=head1 AUTHOR

Bonnie Hurwitz
Scott Daniel

=head1 COPYRIGHT

Copyright (c) 2015 Hurwitz Lab

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut

use File::Basename;
use common::sense;
use autodie;
use Getopt::Long;
use Pod::Usage;
use File::Spec::Functions 'catfile';

#setting version
our $VERSION;
$VERSION = sprintf "%d.%02d", q$Revision: 0.8 $ =~ /(\d+)\.(\d+)/;

#declaring variables
my ($help,  $show_version, $input, $output_dir, $simap_dir, $ncbi_dir);

#getting options from command-line
GetOptions(
    'h|help|?'    => \$help,
    'v|version' => \$show_version,
    'i|input=s'    => \$input,
    'o|output=s' => \$output_dir,
    's|simap=s' => \$simap_dir,
    'n|ncbi=s' => \$ncbi_dir
);

#display help if less than 2 arguments are on commandline
#if (@ARGV < 2 && !($help) && !($show_version)) { pod2usage(2); }

#display help if put in the option --help
pod2usage(2) if $help;

#display version if put in the option --version
if ($show_version) {
    my $prog = basename($0);
    print "$prog v$VERSION\n";
    exit(0);
}

# set up output
my $handle   = undef;
my $encoding = ":encoding(UTF-8)";
open ($handle, "> $encoding", catfile($output_dir, basename($input))) || die "$0: Can't open in write-open mode: $!";

# set up input
open (IN, $input) || die "Cannot open input\n";

open (TAX, "$ncbi_dir/species_to_superkingdom");
my %taxid_to_desc;
my %taxid_to_kingdom;

while (<TAX>) {
   chomp $_;
   my @fields = split (/\t/, $_);
   my $id = $fields[0];
   my $tax_desc = $fields[2];
   $taxid_to_desc{$id} = $tax_desc;
   my $kingdom = $fields[5];
   $taxid_to_kingdom{$id} = $kingdom;
}

open (G, "$ncbi_dir/species_to_genus");
my %taxid_to_genus;

while (<G>) {
   chomp $_;
   my @fields = split (/\t/, $_);
   my $id = $fields[0];
   my $genus = $fields[5];
   $taxid_to_genus{$id} = $genus;
}

open (P, "$ncbi_dir/species_to_phylum");
my %taxid_to_phylum;

while (<P>) {
   chomp $_;
   my @fields = split (/\t/, $_);
   my $id = $fields[0];
   my $phylum = $fields[5];
   $taxid_to_phylum{$id} = $phylum;
}

open (F, "$ncbi_dir/species_to_family");
my %taxid_to_family;

while (<F>) {
   chomp $_;
   my @fields = split (/\t/, $_);
   my $id = $fields[0];
   my $family = $fields[5];
   $taxid_to_family{$id} = $family;
}

# make a hash of input ids to simap ids for simap
open( SIMAPHITS, "$input" ) || die "Cannot open hits file\n";

my %id_to_simap;
my %simap_ids;
my %id_to_simaphit;

while (<SIMAPHITS>) {
   chomp $_;
   my @fields = split(/\t/, $_);
   my $id = $fields[0];
   my $sid = $fields[1];
   $id_to_simap{$id} = $sid;
   $simap_ids{$sid} = $sid;
   $id_to_simaphit{$id} = $_;
}

my $simap_to_tax = "$simap_dir/proteins";
open( SI, "$simap_to_tax" ) || die "Cannot open simap_to_tax\n";

my %simap_to_tax;

while (<SI>) {
    chomp $_;
    my @fields = split( /\t/, $_ );
    my $simapid = $fields[0];
    my $dbid = $fields[1];
    my $source = $fields[3];
    my $taxid  = $fields[2];
    my $taxdesc = $taxid_to_desc{$taxid};
    my $taxking = $taxid_to_kingdom{$taxid};
    my $taxgen  = $taxid_to_genus{$taxid};
    my $taxphy  = $taxid_to_phylum{$taxid};
    my $taxfam  = $taxid_to_family{$taxid};

    my $annot = "$taxid\t$source\t$dbid\t$taxdesc\t$taxking\t$taxphy\t$taxgen\t$taxfam";
    if (exists $simap_ids{$simapid}) {
       $simap_to_tax{$simapid}  = $annot;
    }
}

# go through hits and find their tax_id if it exists
# Note in this script we are choosing the top hit to
# tax id.

while (<IN>) {
   chomp $_;

   my @fields = split(/\t/, $_);

   print $handle "$_\t";

   my $sid = $fields[1];

   if (exists $simap_to_tax{$sid}) {
      print $handle "$simap_to_tax{$sid}\n";
   }
   else {
      print $handle "NONE\tNONE\tNONE\tNONE\tNONE\tNONE\tNONE\tNONE\n";
   }
}

my $arbitrary_breakpoint = "done!";
print $arbitrary_breakpoint;

__END__
