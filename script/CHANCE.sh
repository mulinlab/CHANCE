source ~/.bashrc
echo $(date +%Y/%m/%d/%T) "start"
mkdir ../output/
/usr/bin/perl 01_transvar_hgvsg.pl $1
echo  "01"
/usr/bin/perl 02_merge_mutation_oncotree.pl $2
echo  "02"
/usr/bin/perl 03_filter_snv_in_pathogenicity.pl
echo  "03"
/usr/bin/perl 04_filter_snv_in_drug_cancer.pl
echo  "04"
/usr/bin/Rscript 05_calculate_feature.R
echo  "05"
/usr/bin/perl 06_unique_drug_for_patient.pl
echo  "06"
/usr/bin/perl 07_merge_patients_oncotree_main.pl
echo  "07"
/usr/bin/perl 08_filter_sample_gene.pl
echo  "08"
/usr/bin/Rscript 09_tissue_number_and_cancer_gene.R 
echo  "09"
# gzip ../output/09_feature.txt
gzip ../output/09_feature_used.txt
python 10_predict_tissues.py
echo  "10"
/usr/bin/Rscript 11_merge_name_and_filter_feature.R
echo  "11"
echo "The file of predicted drugs is ../output/11_rank_drug_predicted_AUC.txt"
echo "The file of top 10 features is ../output/11_top10_features.txt"
echo $(date +%Y/%m/%d/%T) "finish"