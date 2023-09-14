#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "../data/Census_allTue_cosmic_hg19_v92.tsv";
my $f3 = "../output/02_sample_hgvsg_unique_oncotree.txt.gz";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open( my $I3 ,"gzip -dc $f3|") or die ("can not open input file '$f3' \n");
my $fo1 = "../output/08_filter_sample_in_pathogenicity_icgc_non_silent_census.txt.gz";

open my $O1, "| gzip >$fo1" or die $!;
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7,%hash8,%hash9,%hash10,%hash11,%hash12,%hash13,%hash30);

print $O1 "submitted_donor_id\tcancer_gene\n";

while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Gene/){
        my $Gene = $f[0];
        $Gene = uc($Gene);
        $hash1{$Gene}=$Gene;
        my $Synonyms =$f[-1];
        $Synonyms =~s/"//g;
        my @ss = split/,/,$Synonyms;
        foreach my $s(@ss){
            $s = uc($s);
            $hash2{$s}=$Gene;
        }
        
    }
}

while(<$I3>)
{
    chomp;
    my @f= split/\t/;
    unless(/original_hgvsg/){
        my $submitted_donor_id =$f[7];
        my $gene = $f[8];
        $gene = uc($gene); 
        my $Variant_annotation =$f[9];
        my $Protein_Change =$f[10];
        if($Protein_Change =~/\d+/){
            unless($Variant_annotation =~ /synonymous_variant/){
                my @G=();
                if(exists $hash1{$gene}){
                    my $f_gene = $hash1{$gene};
                    push @G,$f_gene;
                }
                elsif(exists $hash2{$gene}){
                    my $f_gene = $hash2{$gene};
                    push @G,$f_gene;
                }
                my $length=@G;
                if($length >0){ 
                    # print "$length\n";
                    my $f_gene = $G[0];
                    print $O1 "$submitted_donor_id\t$f_gene\n";
                }
            }
        }

    }
}

