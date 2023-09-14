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
