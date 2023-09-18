library(dplyr)
library(stringr)

setwd("../output/")
org  <-read.csv("04_snv_indel_gene_and_network_based.txt.gz",header = T,sep = "\t") %>% as.data.frame()
org$drug_target_score[is.na(org$drug_target_score)]<-1
drug_target_score_SNV_INDEL <- unique(org[,c("Drug_chembl_id_Drug_claim_primary_name","paper_sample_name","drug_ENSG","drug_target_score","oncotree_ID","oncotree_ID_type")])%>%group_by(Drug_chembl_id_Drug_claim_primary_name,paper_sample_name,oncotree_ID,oncotree_ID_type)%>%summarise(average_effective_drug_target_score_SNV_INDEL=mean(drug_target_score),max_effective_drug_target_score_SNV_INDEL=max(drug_target_score))%>%data.frame


mutation_map_to_gene_level_score_SNV_INDEL <- unique(org[,c("Drug_chembl_id_Drug_claim_primary_name","paper_sample_name","Mutation_ID","cancer_ENSG","map_to_gene_level_score","oncotree_ID","oncotree_ID_type")])%>%group_by(Drug_chembl_id_Drug_claim_primary_name,paper_sample_name,oncotree_ID,oncotree_ID_type)%>%summarise(average_mutation_map_to_gene_level_score_SNV_INDEL=mean(map_to_gene_level_score),max_mutation_map_to_gene_level_score_SNV_INDEL=max(map_to_gene_level_score))%>%data.frame

the_shortest_path_length_SNV_INDEL <- unique(org[,c("Drug_chembl_id_Drug_claim_primary_name","paper_sample_name","the_shortest_path","path_length","oncotree_ID","oncotree_ID_type")])%>%group_by(Drug_chembl_id_Drug_claim_primary_name,paper_sample_name,oncotree_ID,oncotree_ID_type)%>%summarise(average_the_shortest_path_length_SNV_INDEL=mean(path_length),min_the_shortest_path_length_SNV_INDEL=min(path_length))%>%data.frame

rwr_normal_P_value_SNV_INDEL <- unique(org[,c("Drug_chembl_id_Drug_claim_primary_name","paper_sample_name","normal_score_P","cancer_ENSG","oncotree_ID","oncotree_ID_type")])%>%group_by(Drug_chembl_id_Drug_claim_primary_name,paper_sample_name,oncotree_ID,oncotree_ID_type)%>%summarise(min_rwr_normal_P_value_SNV_INDEL=min(normal_score_P),median_rwr_normal_P_value_SNV_INDEL=median(normal_score_P))%>%data.frame

cancer_gene_n <- unique(org[,c("Drug_chembl_id_Drug_claim_primary_name","paper_sample_name","cancer_ENSG","data_source","oncotree_ID","oncotree_ID_type")])%>%group_by(Drug_chembl_id_Drug_claim_primary_name,paper_sample_name,oncotree_ID,oncotree_ID_type)%>%summarise(number_of_cancer_gene=n())%>%data.frame
aa <-filter(org,data_source=="gene_based")
gene_based_n <- unique(aa[,c("Drug_chembl_id_Drug_claim_primary_name","paper_sample_name","cancer_ENSG","data_source","oncotree_ID","oncotree_ID_type")])%>%group_by(Drug_chembl_id_Drug_claim_primary_name,paper_sample_name,oncotree_ID,oncotree_ID_type)%>%summarise(number_of_gene_bases=n())%>%data.frame

bb<- left_join(cancer_gene_n,gene_based_n,by=c("Drug_chembl_id_Drug_claim_primary_name","paper_sample_name","oncotree_ID","oncotree_ID_type"))
bb$number_of_gene_bases[is.na(bb$number_of_gene_bases)] <- 0
bb$cancer_gene_exact_match_drug_target_ratio_SNV_INDEL <- bb$number_of_gene_bases/bb$number_of_cancer_gene

mutation_pathogenicity_SNV_INDEL <- unique(org[,c("Drug_chembl_id_Drug_claim_primary_name","paper_sample_name","Mutation_ID","CADD_MEANPHRED","oncotree_ID","oncotree_ID_type")])%>%group_by(Drug_chembl_id_Drug_claim_primary_name,paper_sample_name,oncotree_ID,oncotree_ID_type)%>%summarise(average_mutation_pathogenicity_SNV_INDEL=mean(CADD_MEANPHRED),max_mutation_pathogenicity_SNV_INDEL=max(CADD_MEANPHRED))%>%data.frame


f_features <- left_join(drug_target_score_SNV_INDEL,mutation_map_to_gene_level_score_SNV_INDEL,by=c("Drug_chembl_id_Drug_claim_primary_name","paper_sample_name","oncotree_ID","oncotree_ID_type"))%>%left_join(the_shortest_path_length_SNV_INDEL,by=c("Drug_chembl_id_Drug_claim_primary_name","paper_sample_name","oncotree_ID","oncotree_ID_type"))%>% left_join(rwr_normal_P_value_SNV_INDEL,by=c("Drug_chembl_id_Drug_claim_primary_name","paper_sample_name","oncotree_ID","oncotree_ID_type"))%>%left_join(bb,by=c("Drug_chembl_id_Drug_claim_primary_name","paper_sample_name","oncotree_ID","oncotree_ID_type"))%>%left_join(mutation_pathogenicity_SNV_INDEL,by=c("Drug_chembl_id_Drug_claim_primary_name","paper_sample_name","oncotree_ID","oncotree_ID_type"))

f_features <- f_features[,c(4,2,1,3,5:12,15:17)]
write.table(f_features,"05_caculated_fetures.txt" ,row.names = F, col.names = T,quote =F,sep="\t")
