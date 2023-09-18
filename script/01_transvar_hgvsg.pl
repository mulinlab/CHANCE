
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = $ARGV[0];
print "my input maf file is $f1\n";
open( my $I1 ,"gzip -dc $f1|") or die ("can not open input file '$f1' \n");
my $fo1 = "../output/01_sample_hgvsg.txt.gz";
open my $O1, "| gzip >$fo1" or die $!;
my %hash1;
my %hash2;

print $O1 "Chr\tstart\tend\tref\talt\toriginal_hgvsg\ttransvar_hgvsg\tsubmitted_donor_id\tgene\tVariant_Classification\tAmino_Acid_Change\n";
while(<$I1>)
{
    chomp;
    unless(/Chr/){
        my @f =split/\t/;
        for (my $i=0;$i<9;$i++){unless(defined $f[$i]){$f[$i] = "NONE"}};
        my $chr=$f[0];
        my $start=$f[1];
        my $end =$f[2];
        my $ref =$f[3];
        my $alt =$f[4];
        my $submitted_donor_id =$f[5];
        my $gene =$f[6];
        my $Variant_Classification =$f[7];
        my $Amino_Acid_Change =$f[8];
        my $lr= length($ref);
        my $la= length($alt);
        # print "$technology\n";
        unless($start=~/\./ || $end=~/\./){
            if($ref=~/^-$/){ #ins
                if($start==$end){ #ICGC的ins start=end
                    my $new_start=$end-1;
                    my $input="$chr:g\.${new_start}_${end}ins$alt";
                    my $hgvsg_t =$input;
                    print $O1 "$chr\t$start\t$end\t$ref\t$alt\t$input\t$hgvsg_t\t$submitted_donor_id\t$gene\t$Variant_Classification\t$Amino_Acid_Change\n";
                }
                else{
                    my $input="$chr:g\.${start}_${end}ins$alt";# ;"$chr:g\.${pos}${ref}>$alt";
                    # my $hgvsg_t =hgvsg($input); 
                    my $hgvsg_t =$input;
                    print $O1 "$chr\t$start\t$end\t$ref\t$alt\t$input\t$hgvsg_t\t$submitted_donor_id\t$gene\t$Variant_Classification\t$Amino_Acid_Change\n";
                }
            }
            else{
                if($alt=~/^-$/){ #del
                    if($lr>1){ #multi n del
                        my $input= "$chr:g\.${start}_${end}del$ref";
                        my $hgvsg_t =$input;
                        print $O1 "$chr\t$start\t$end\t$ref\t$alt\t$input\t$hgvsg_t\t$submitted_donor_id\t$gene\t$Variant_Classification\t$Amino_Acid_Change\n";
                    }else{ #s n del 
                        my $input= "$chr:g\.${start}del$ref";
                        my $hgvsg_t =$input;
                        print $O1 "$chr\t$start\t$end\t$ref\t$alt\t$input\t$hgvsg_t\t$submitted_donor_id\t$gene\t$Variant_Classification\t$Amino_Acid_Change\n";
                    }
                }else{
                    
                    if($lr==1 && $la==1){ #snv
                        my $input= "$chr:g\.${start}${ref}>${alt}";
                        my $hgvsg_t =$input;
                        print $O1 "$chr\t$start\t$end\t$ref\t$alt\t$input\t$hgvsg_t\t$submitted_donor_id\t$gene\t$Variant_Classification\t$Amino_Acid_Change\n";
                    }else{
    #------------
                        if($lr >$la){
                            my $dup=substr($ref,0,$la);
                            if($dup eq $alt){ #del
                                my $miss =substr($ref,$la,$lr-$la);
                                my $new_pos= $start+$la;
                                if(length($miss)>1){
                                    my $new_end= $new_pos+length($miss)-1;
                                    my $input="$chr:g\.${new_pos}_${new_end}del$miss";
                                    my $hgvsg_t =$input;
                                    print $O1 "$chr\t$start\t$end\t$ref\t$alt\t$input\t$hgvsg_t\t$submitted_donor_id\t$gene\t$Variant_Classification\t$Amino_Acid_Change\n";
                                }
                                else{
                                    my $input="$chr:g\.${new_pos}del$miss";
                                    my $hgvsg_t =$input;
                                    print $O1 "$chr\t$start\t$end\t$ref\t$alt\t$input\t$hgvsg_t\t$submitted_donor_id\t$gene\t$Variant_Classification\t$Amino_Acid_Change\n";
                                }
                            }
                            else{
                                my $input= "$chr:g\.${start}${ref}>${alt}";
                                my $hgvsg_t = hgvsg($input);
                                print $O1 "$chr\t$start\t$end\t$ref\t$alt\t$input\t$hgvsg_t\t$submitted_donor_id\t$gene\t$Variant_Classification\t$Amino_Acid_Change\n";
                            }
                        }
                        else{
                            if($lr <$la){
                                my $dup=substr($alt,0,$lr);
                                if($dup eq $ref){#ins
                                    my $new_start=$start+$lr-1;
                                    my $new_end=$new_start +1;
                                    my $ins=substr($alt,$lr,$la-$lr);
                                    my $input="$chr:g\.${new_start}_${new_end}ins$ins";
                                    my $hgvsg_t =$input;
                                    print $O1 "$chr\t$start\t$end\t$ref\t$alt\t$input\t$hgvsg_t\t$submitted_donor_id\t$gene\t$Variant_Classification\t$Amino_Acid_Change\n";
                                }
                                else{
                                    my $input= "$chr:g\.${start}${ref}>${alt}";
                                    my $hgvsg_t = hgvsg($input);
                                    print $O1 "$chr\t$start\t$end\t$ref\t$alt\t$input\t$hgvsg_t\t$submitted_donor_id\t$gene\t$Variant_Classification\t$Amino_Acid_Change\n";
                                }
                            }
    #-------------------------------------------------------
                        }
                    }
                }
            }
        }
    }
}


sub hgvsg{
    my $hg= $_[0];
    my $aa = readpipe("transvar ganno -i '$hg' --ccds |tail -1" );
    my @s=split/\t/,$aa;
    my $hgvs=$s[4];
    $hgvs=~s/\/.*//g;
    my $chr= $hgvs;
    $chr =~ s/g.*//g;
    my $info=$s[6];
    # print "$info\n";
    my @new=();
    if($info =~/unaligned_gDNA|unalign_gDNA/){
        my @ts=split/;/,$info;
        foreach my $t(@ts){
            if($t=~/^unaligned_gDNA|unalign_gDNA/){
                my $hgvsg2= $t;
                $hgvsg2 =~s/unaligned_gDNA=|unalign_gDNA=//g;
                chomp($hgvsg2);
                my $hgvsg3 = "${chr}${hgvsg2}";
                push @new,$hgvsg3;
                # print  "aaa\n";
            }
        }
        return($new[0]);
    }
    else{
        return($hgvs);
    }
}