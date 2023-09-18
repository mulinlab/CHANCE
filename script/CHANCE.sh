
echo $(date +%Y/%m/%d/%T) "start"
mkdir ../output/
perl 01_transvar_hgvsg.pl $1
# echo  "01"
perl 02_merge_mutation_oncotree.pl $2
# echo  "02"
perl 03_filter_snv_in_pathogenicity_icgc.pl
# echo  "03"
perl 04_filter_snv_in_drug_cancer.pl
# echo  "04"
Rscript 05_calculate_feature.R
# echo  "05"
perl 06_unique_drug_for_patient.pl
# echo  "06"
perl 07_merge_patients_oncotree_main.pl
# echo  "07"
perl 08_filter_sample_gene.pl
# echo  "08"
Rscript 09_tissue_number_and_cancer_gene.R 
# echo  "09"

gzip ../output/09_sample_feature_used.txt
python 10_predict_tissues.py
# echo  "10"
Rscript 11_find_drug_names.R
# echo  "11"
echo "The predicted file is ../output/11_predicted_drug_sample.txt"
echo "The feature importance file is ../output/11_feature_importance_shap.txt"
echo $(date +%Y/%m/%d/%T) "finish"