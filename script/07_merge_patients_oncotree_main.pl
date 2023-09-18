#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "../output/03_filter_snv_in_pathogenicity_icgc.txt.gz";
open( my $I1 ,"gzip -dc $f1|") or die ("can not open input file '$f1' \n");
my $f2 = "../output/06_caculated_fetures_unique_drug_for_patients.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "../output/07_merge_sample_oncotree.txt.gz";
open my $O1, "| gzip >$fo1" or die $!;
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);


while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^hgvsg/){
        my $submitted_donor_id =$f[2];
        my $oncotree_main_tissue_ID =$f[-1];
        $hash1{$submitted_donor_id}=$oncotree_main_tissue_ID;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    if (/^Drug_chembl_id_Drug_claim_primary_name/){
        print $O1 "$_\toncotree_main_tissue_ID\n";
    }
    else{
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $paper_sample_name =$f[1];
        if(exists $hash1{$paper_sample_name}){
            my $oncotree_main_tissue_ID = $hash1{$paper_sample_name};
            print $O1 "$_\t$oncotree_main_tissue_ID\n";
        }
    }
}


