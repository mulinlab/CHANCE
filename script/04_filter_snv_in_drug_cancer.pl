#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "../data/non_oncology_drug_genetic_info.txt.gz";
my $f2 = "../output/03_filter_snv_in_pathogenicity_icgc.txt.gz";
open( my $I1 ,"gzip -dc $f1|") or die ("can not open input file '$f1' \n"); 
open( my $I2 ,"gzip -dc $f2|") or die ("can not open input file '$f2' \n");

my $fo1 = "../output/04_snv_indel_gene_and_network_based.txt.gz";
open my $O1, "| gzip >$fo1" or die $!;
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7,%hash8,%hash9,%hash10,%hash11,%hash12,%hash13,%hash30);

my $header = "Drug_chembl_id_Drug_claim_primary_name\tdrug_entrze\tdrug_ENSG\tdrug_target_score\tend_entrze\tthe_shortest_path\tpath_length\tnormal_score_P\tMutation_ID\tcancer_specific_affected_donors\toriginal_cancer_ID\tCADD_MEANPHRED";
$header = "$header\tcancer_ENSG\toncotree_ID\tthe_final_logic\tMap_to_gene_level\tmap_to_gene_level_score\tdata_source";
$header = "$header\toncotree_ID_type\tpaper_sample_name\tdrug_in_paper\tdata_type";

print $O1 "$header\n";

while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    my $output1 = join("\t",@f[0..12],@f[15,16],@f[18..20]); 
    unless(/^Drug_chembl_id/){
        my $Drug_chembl_id_Drug_claim_primary_name= $f[0]; 
        my $Mutation_id = $f[8];
        my $oncotree_detail_ID = $f[13];
        my $oncotree_main_ID = $f[14];
        my $k1 = "$oncotree_detail_ID\t$Mutation_id";
        my $k2 = "$oncotree_main_ID\t$Mutation_id";
        push @{$hash2{$k2}},$output1;
        unless($oncotree_detail_ID eq $oncotree_main_ID){
            push @{$hash1{$k1}},$output1;
        }
    }
}



while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless(/^hgvsg/){
        my $Drug = "NA";  #$drug_name
        my $Mutation_id = $f[1];
        my $paper_sample_name = $f[2];
        my $oncotree_detail_ID = $f[-2];
        my $oncotree_main_ID = $f[-1];
        my $k1 = "$oncotree_detail_ID\t$Mutation_id";
        my $k2 = "$oncotree_main_ID\t$Mutation_id";
        if (exists $hash1{$k1}){ #$oncotree_detail_ID 
            my @vs = @{$hash1{$k1}};
            foreach my $v(@vs){
                my @t =split/\t/,$v;
                my $output1 = join("\t",@t[0..12]);
                my $output2 = join ("\t",@t[13..16]);
                my $output = "$output1\t$oncotree_detail_ID\t$output2\tdetail\t$paper_sample_name\t$Drug\t$t[-1]";
                unless(exists $hash3{$output}){
                    $hash3{$output}=1;
                    print $O1 "$output\n";
                }
            }
        }
        if (exists $hash2{$k2}){ #$oncotree_main_ID
            my @vs = @{$hash2{$k2}};
            foreach my $v(@vs){
                my @t =split/\t/,$v;
                my $output1 = join("\t",@t[0..12]);
                my $output2 = join ("\t",@t[13..16]);
                my $output = "$output1\t$oncotree_main_ID\t$output2\tmain\t$paper_sample_name\t$Drug\t$t[-1]";
                unless(exists $hash3{$output}){
                    $hash3{$output}=1;
                    print $O1 "$output\n";
                }
            }
        }
    }
}
