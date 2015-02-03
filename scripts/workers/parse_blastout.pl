#! /uaopt/perl/5.14.2/bin/perl

use strict;
use Bio::SearchIO;

if ( @ARGV != 1 ) {
    die "usage:\nparse_blast.pl file \> out\n\n";
}

my $infile = shift;
parse_blast($infile);

sub parse_blast {
    my $infile = shift;
    my $in     = Bio::SearchIO->new(
        -file   => $infile,
        -format => 'blast'
    );

    while ( my $result = $in->next_result ) {
        my $hit_count = 0;

      HIT:
        while ( my $hit = $result->next_hit ) {
            $hit_count++;
            my $hsp_count = 0;
            #next HIT if $hit_count > 1;
            while ( my $hsp = $hit->next_hsp ) {
                my $coverage = ( $hsp->length() / $result->query_length );
                $hsp_count++;
                  #if ( $hsp_count == 1 ) {
                  #if ($hit->name =~ /NP/) {

                    #             if ($coverage >= 0.5) {
                                 #next HIT if ( $hit->description =~ /complete genome/);
                                 #next HIT if ( $hit->description !~ /cds/);
                  #                   ($hsp->frac_identical('total') >= 0.95)) {
                    print join(
                        "\t",
                        $result->query_name,              #1
                        $result->query_length,            #2
                        $hit->name,                       #3
                        $hit->length(),                   #4
                        $hit_count,                       #5
                        $hsp->rank,                       #6
                        $hsp->evalue(),                   #7
                        $hsp->score,                      #8
                        $hsp->frac_identical('total'),    #9
                        $hsp->start('query'),             #10
                        $hsp->end('query'),               #11
                        $hsp->gaps('query'),              #12
                        $hsp->frac_identical('query')
                        ,                       #13 won't be accurate for blastx
                        $hsp->strand('query'),  #14
                        $hsp->start('hit'),     #15
                        $hsp->end('hit'),       #16
                        $hsp->gaps('hit'),      #17
                        $hsp->frac_identical('hit'),    #18
                        $hsp->strand('hit'),            #19
                        $result->query_description,     #20
                        $hit->description,              #21
                      ),
                      "\n";
                #}    # end of if
            }    #end while

        }    #end while next hit

    }    #end while next result
}    #end sub
