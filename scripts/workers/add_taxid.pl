#!/usr/bin/env perl

### Note to self:
# /rsgrps/bhurwitz/hurwitzlab/data/reference/simap/proteins.gz
# is where to lookup taxid with the md5 in blastresults
# then /rsgrps/bhurwitz/hurwitzlab/data/reference/ncbitax/...
# is where to lookup genus/family/species info (proteins.gz just gives you the species_id
# (e.g. "7227")

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
open($handle, "> $encoding", catfile($output_dir, basename($input))) || die "$0: Can't open in write-open mode: $!";

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


# open (GOTERM, "/rsgrps/bhurwitz/hurwitzlab/data/reference/goterms/ontology_term.txt");
# my %goid_to_desc;
#
# while (<GOTERM>) {
#    chomp $_;
#    my ($id, $cat, $desc, $desc2) = split(/\t/, $_);
#    $goid_to_desc{$id} = $desc;
# }

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

# my $simap_to_go = "$simap_dir/blast2go";
# open (GO, "$simap_to_go") || die "Cannot open simap_to_go\n";
# my %simap_to_go;
# while (<GO>) {
#    chomp $_;
#    my ($id, $goid, $score) = split(/\t/, $_);
#    if (exists $simap_ids{$id}) {
#       push(@{$simap_to_go{$id}}, $goid);
#    }
# }

# my $simap_to_pfam = "$simap_dir/features_HMMPfam";
# open (PF, "$simap_to_pfam") || die "Cannot open simap_to_pfam\n";
# my %simap_to_pfam;
# while (<PF>) {
#    chomp $_;
#    my @fields = split(/\t/, $_);
#    my $id = shift @fields;
#    if (exists $simap_ids{$id}) {
#       my $line = join("\t", @fields);
#       $simap_to_pfam{$id} =  $line;
#    }
# }

# my $simap_to_tigr = "$simap_dir/features_HMMTigr";
# open (T, "$simap_to_tigr") || die "Cannot open simap_to_tigr\n";
# my %simap_to_tigr;
# while (<T>) {
#    chomp $_;
#    my @fields = split(/\t/, $_);
#    my $id = shift @fields;
#    if (exists $simap_ids{$id}) {
#       my $line = join("\t", @fields);
#       $simap_to_tigr{$id} =  $line;
#    }
# }

# my $simap_to_pir = "$simap_dir/features_HMMPIR";
# open (P, "$simap_to_pir") || die "Cannot open simap_to_pir\n";
# my %simap_to_pir;
# while (<P>) {
#    chomp $_;
#    my @fields = split(/\t/, $_);
#    my $id = shift @fields;
#    if (exists $simap_ids{$id}) {
#       my $line = join("\t", @fields);
#       $simap_to_pir{$id} =  $line;
#    }
# }

# go through hits and find their simap_info if it exists
# Note in this script we are choosing the top hit to
#  pfam, tigrfam, and pir.  As well as the top tax id.

while (<IN>) {
   chomp $_;
   my @fields = split(/\t/, $_);
   my @none;
   for my $ct ( 1 .. 12) {
      push (@none, 'NONE');
   }
   my $n = join("\t", @none);

   print OUT "$_\t";
   my $gid = $fields[0];
   my $sid = $fields[2];

   if (exists $simap_to_tax{$sid}) {
      print OUT "$simap_to_tax{$sid}\t";
   }
   else {
      print OUT "NONE\tNONE\tNONE\tNONE\tNONE\tNONE\tNONE\tNONE\t";
   }

   # if (exists $simap_to_go{$sid}) {
#       my @goids;
#       my @godesc;
#       for my $g (@{$simap_to_go{$sid}}) {
#          push(@goids, $g);
#          my $desc = 'NONE';
#          if (exists $goid_to_desc{$g}) {
#             $desc = $goid_to_desc{$g};
#          }
#          push(@godesc, $desc);
#      }
#      my $gids = join(",", @goids);
#      my $gdesc = join(",", @godesc);
#      print OUT "$gids\t$gdesc\t";
#    }
#    else {
#       print OUT "NONE\tNONE\t";
#    }
#
#    if (exists $simap_to_pfam{$sid}) {
#       print OUT "$simap_to_pfam{$sid}\t";
#    }
#    else {
#       print OUT "$n\t";
#    }
#
#    if (exists $simap_to_tigr{$sid}) {
#       print OUT "$simap_to_tigr{$sid}\t";
#    }
#    else {
#       print OUT "$n\t";
#    }
#
#    if (exists $simap_to_pir{$sid}) {
#       print OUT "$simap_to_pir{$sid}\t";
#    }
#    else {
#       print OUT "$n\t";
#    }
#    print OUT "\n";
}

my $arbitrary_breakpoint = "done!";
print $arbitrary_breakpoint;

__END__
