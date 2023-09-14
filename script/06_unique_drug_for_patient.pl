#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "../output/05_caculated_fetures.txt";
my $fo1 = "../output/06_caculated_fetures_unique_drug_for_patients.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my %hash1;

while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    my $oncotree_ID_type =$f[0];
    my $paper_sample_name =$f[1];
    my $Drug_chembl_id_Drug_claim_primary_name = $f[2];
    my $cancer_oncotree_id =$f[3];
    my $v = join("\t",$oncotree_ID_type,@f[3..$#f]);
    
    if (/^oncotree_ID_type/){
        print $O1 "$Drug_chembl_id_Drug_claim_primary_name\t$paper_sample_name\t$v\n";
    }
    else{
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$paper_sample_name";
        push @{$hash1{$k}},$v;
    }
}


foreach my $k(sort keys %hash1){
    my @vs = @{$hash1{$k}};
    my %hash2;
    @vs = grep { ++$hash2{ $_ } < 2; } @vs;
    my $number = @vs;
    if ($number >1){#detail
        foreach my $v(@vs){ 
            if ($v =~/detail/){
                print $O1 "$k\t$v\n";
            }
        }
    }
    else{ # main
        print $O1 "$k\t$vs[0]\n";
    }

    
}