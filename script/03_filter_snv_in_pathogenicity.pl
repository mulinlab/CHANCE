#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "../data/pathogenicity_mutation.txt";
my $f2 = "../output/02_sample_hgvsg_unique_oncotree.txt.gz";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open( my $I2 ,"gzip -dc $f2|") or die ("can not open input file '$f2' \n"); 
my $fo1 = "../output/03_filter_snv_in_pathogenicity.txt.gz";
open my $O1, "| gzip >$fo1" or die $!;
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7,%hash8,%hash9,%hash10,%hash11,%hash12,%hash13,%hash30);

print $O1 "hgvsg\tid\tsubmitted_donor_id\tgene\tVariant_Classification\tAmino_Acid_Change\toncotree_detail_ID\toncotree_main_tissue_ID\n";

while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Mutation_ID/){
        my $Mutation_ID = $f[0];
        my $hgvs= $f[2];
        my $k = $hgvs;
        $hash1{$k}=$Mutation_ID;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless(/start/){
        my $hgvsg = $f[6];
        my $submitted_donor_id =$f[7];
        my $gene = $f[8];
        my $Variant_Classification =$f[9];
        my $Amino_Acid_Change =$f[10];
        my $oncotree_detail_ID=$f[-2];
        my $oncotree_main_tissue_ID =$f[-1];
        if($hgvsg =~/chr/){
            my $k = $hgvsg;
            if (exists $hash1{$k}){
                my $id= $hash1{$k};
                # print STDERR "$k\n";
                print $O1 "$hgvsg\t$id\t$submitted_donor_id\t$gene\t$Variant_Classification\t$Amino_Acid_Change\t$oncotree_detail_ID\t$oncotree_main_tissue_ID\n";
            }
        }
        else{
            $hgvsg ="chr${hgvsg}";
            my $k = $hgvsg;
            if (exists $hash1{$k}){
                my $id= $hash1{$k};
                # print STDERR "$k\n";
                print $O1 "$hgvsg\t$id\t$submitted_donor_id\t$gene\t$Variant_Classification\t$Amino_Acid_Change\t$oncotree_detail_ID\t$oncotree_main_tissue_ID\n";
            }
        }

    }
}

