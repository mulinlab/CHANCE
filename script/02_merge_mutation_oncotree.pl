#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
my $f1 = $ARGV[0];
print "my input oncotree file is $f1\n";
my $f2 = "../output/01_sample_hgvsg.txt.gz";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open( my $I2 ,"gzip -dc $f2|") or die ("can not open input file '$f2' \n"); 
my $fo1 = "../output/02_sample_hgvsg_unique_oncotree.txt.gz";
open my $O1, "| gzip >$fo1" or die $!;
my $fo2 = "../output/02_sample_hgvsg_unique_without_oncotree.txt.gz";
open my $O2, "| gzip >$fo2" or die $!;
my %hash1;
my %hash2;
while(<$I1>)
{
    chomp;
    my @f=split/\t/;
    unless(/submitted_donor_id/){
        my $submitted_donor_id =$f[0];
        my $oncotree_ID_detail =$f[1];
        my $oncotree_ID_main_tissue =$f[2];
        my $v="$oncotree_ID_detail\t$oncotree_ID_main_tissue";
        $hash1{$submitted_donor_id}=$v;
        # print "$k\t$v\n";
    }
}


while(<$I2>)
{
    chomp;
    my @f=split/\t/;
    if(/Chr/){
        print $O1 "$_\toncotree_ID_detail\toncotree_ID_main_tissue\n";
        print $O2 "$_\n";
    }
    unless(/original_hgvsg/){
        my $submitted_donor_id =$f[7];
        if(exists $hash1{$submitted_donor_id}){
            my $oncotree = $hash1{$submitted_donor_id};
            print $O1 "$_\t$oncotree\n";
        }
        else{
            print $O2 "$_\n";
            print "$submitted_donor_id oncotree is not exists\n";
        }
    }
}