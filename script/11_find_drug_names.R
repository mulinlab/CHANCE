library(dplyr)
library(stringr)

setwd("../output/")
name <- read.csv("../data/drug_info.txt",header = T,sep = "\t") %>% as.data.frame()
name$Drug_chembl_id_Drug_claim_primary_name <- as.character(name$Drug_chembl_id_Drug_claim_primary_name)
org <- read.csv("10_sample_drug_predict_key_info.txt",header = T,sep = "\t") %>% as.data.frame()
org$Drug_chembl_id_Drug_claim_primary_name <- as.character(org$Drug_chembl_id_Drug_claim_primary_name)
forg <- left_join(org,name,by="Drug_chembl_id_Drug_claim_primary_name")
forg <- forg[,c(1,4,2,3)]
forg <- forg[order(forg$predict_AUC),]
colnames(forg) <- c("Drug_barcode","Drug_name","Sample_name","predicted_AUC")
write.table(forg,"11_predicted_drug_sample.txt" ,row.names = F, col.names = T,quote =F,sep="\t")

SHAP <- read.csv("10_feature_importance_shap.txt",header = T,sep = "\t") %>% as.data.frame()
colnames(SHAP)[1:11] <- c("mean_of_drug-target_interaction_scores",
    "maximum_of_drug-target_interaction_scores",
    "mean_of_mutation-gene_association_levels",
    "maximum_of_mutation-gene_association_levels",
    "mean_length_of_shortest_paths",
    "minimum_length_of_shortest_paths",
    "minimum_p_value_of_network_proximity",
    "median_p_value_of_network_proximity",
    "proportion_of_directly_targeted_driver_genes",
    "mean_of_driver_mutation_CADD_scores",
    "maximum_of_driver_mutation CADD scores")
write.table(SHAP,"11_feature_importance_shap.txt" ,row.names = F, col.names = T,quote =F,sep="\t")