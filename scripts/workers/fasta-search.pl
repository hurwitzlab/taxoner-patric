#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Bio::DB::Fasta;
use Bio::SeqIO;
use File::Basename;
use Getopt::Long;
use Pod::Usage;

main();

# --------------------------------------------------
sub main {
    my %args = get_args();

    if ($args{'help'} || $args{'man_page'}) {
        pod2usage({
            -exitval => 0,
            -verbose => $args{'man_page'} ? 2 : 1
        });
    } 

    pod2usage() unless @ARGV == 3;

    #Command be like: perl ./fasta-search.pl $TEST_DB $TEST_SQ $TEST_OUT_DIR
    my ($dir_or_file, $read_id_file, $out_dir) = @ARGV;

    printf "Searching '%s'\n", $dir_or_file;

    #Setting up inputs and outpus

       
    #The database, if this wasn't created before this will take a loooong time!
    my $db  = Bio::DB::Fasta->new($dir_or_file);

    #The read_id file, one id per line
    open my $READ_ID_FILE, '<', $read_id_file;

    #We'll store the read_ids in an array
    my @read_ids;

    #Create a name
    (my $number = basename($read_id_file)) =~ s/[^0-9]//g; 

    my $filename = 'DNA_' . $number . '_results.fa';

    printf "Filename is '%s'\n", $filename;

    my $writer = Bio::SeqIO->new(-format => 'Fasta', -file => ">$out_dir/$filename");

    my $found = 0;
    while (<$READ_ID_FILE>) {
        chomp $_;
        if ( $_ =~ /:/ ) {
            my @cols = split( /\t/, $_ );

#HWI-ST885:65:C07WUACXX:7:1101:10000:22995   1068975 304030  1.925   17938   18005
            my $read_id = $cols[0];
            #say "read_id ($read_id)";
            if (my $seq = $db->get_Seq_by_id($read_id)) {
                $found++;
                $writer->write_seq($seq);
            }
        }
    }

    say "Found $found.";
}

#sub foo {
#
#    my $x = @read_ids;
#
#    printf "There are %s ids in the input\n", $x;
#    
#    my @found_ids;
#    for my $read_id (@read_ids) {
#        my @found_ids = grep { /$read_id/i } $db->get_all_primary_ids;
#    }
#
#    my $n   = @found_ids;
#
#    printf "Found %s id%s\n", $n, $n == 1 ? '' : 's';
#
#    if ($n > 0) {
#        (my $filename = $read_id_file) =~ s/\W//g;
#        $filename ||= 'out';
#        $filename .= '.fa';
#        printf "Writing out to %s\n", $filename;
#        for my $id (@found_ids) {
#        }
#
#        say "See results in '$filename'";
#    }
#}

# --------------------------------------------------
sub get_args {
    my %args;
    GetOptions(
        \%args,
        'help',
        'man',
    ) or pod2usage(2);

    return %args;
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

02-fasta-search.pl - search FASTA file for sequences IDs matching a pattern

=head1 SYNOPSIS

  02-fasta-search.pl file.fa pattern

Options:

  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Searches a FASTA file for sequence IDs matching a pattern.

=head1 SEE ALSO

Bio::SeqIO.

=head1 AUTHOR

Ken Youens-Clark E<lt>kyclark@email.arizona.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2015 Hurwitz Lab

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
