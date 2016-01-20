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

    pod2usage() unless @ARGV == 1;

    my ($file) = @ARGV;

    printf "Making BioDBFasta from '%s'\n", $file;

    my $db  = Bio::DB::Fasta->new($file);

}

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

make-fastaDB.pl - make a fasta DB for searching

=head1 SYNOPSIS

  make-fastaDB.pl [/path/to/directory/with/fastas]

Options:

  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Make a fasta database that can be used later for searching

=head1 SEE ALSO

Bio::SeqIO.

=head1 AUTHOR

Scott Garrett Daniel E<lt>scottdaniel@email.arizona.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2015 Hurwitz Lab

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
