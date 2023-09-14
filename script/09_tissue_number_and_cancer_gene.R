library(dplyr)
library(stringr)
library(tibble)

setwd("../output/")
org<-read.table("07_merge_sample_oncotree.txt.gz",header = T,sep = "\t") %>% as.data.frame()
cancer_genes <- read.table("08_filter_sample_in_pathogenicity_icgc_non_silent_census.txt.gz",header = T,sep = "\t") %>% as.data.frame()

unique_sample_cancer_gene <- unique(cancer_genes)
unique_sample_cancer_gene$cancer_gene <- as.character(unique_sample_cancer_gene$cancer_gene)
unique_sample_cancer_gene$submitted_donor_id <- as.character(unique_sample_cancer_gene$submitted_donor_id)

org_unique_sample <- unique(org$paper_sample_name)
unique_sample_cancer_gene_sample <- unique_sample_cancer_gene[unique_sample_cancer_gene$submitted_donor_id %in% org_unique_sample,]
#----------------------------------------------
load("../data/gene.Rdata")

m <- matrix(NA, nr = length(unique(org$paper_sample_name)), nc = ncol(n)-1)
rownames(m) <- as.character(unique(org$paper_sample_name)); colnames(m) <- colnames(n)[2:ncol(n)]
# for()
for(i in 1:nrow(m)){
  sample = rownames(m)[i]
  for(j in 1:ncol(m)){
    gene = colnames(m)[j]
    tmp = unique_sample_cancer_gene_sample %>% as.data.frame %>% dplyr::filter(submitted_donor_id==sample, cancer_gene ==gene)
    if(nrow(tmp)!=0){
      m[sample, gene]=1
    }
  }
}
m[is.na(m)] <- 0

n <-data.frame(m)
n <- add_column(n,paper_sample_name=rownames(n), .before=1)
org$paper_sample_name <-as.character(org$paper_sample_name)
org_gene <-inner_join(org,n,by="paper_sample_name")

#------------------add tissue
load("../data/tissue.Rdata")
#-------------
org_gene <- add_column(org_gene,oncotree_main_tissue_ID_org=org_gene$oncotree_main_tissue_ID, .before="oncotree_main_tissue_ID")
org_gene$oncotree_main_tissue_ID <-str_replace_all(org_gene$oncotree_main_tissue_ID,"/| ","_")

org_gene_tissue <-inner_join(org_gene,tissues_final,by="oncotree_main_tissue_ID")

f_feature <- org_gene_tissue%>% dplyr::select(average_effective_drug_target_score_SNV_INDEL,max_effective_drug_target_score_SNV_INDEL,average_mutation_map_to_gene_level_score_SNV_INDEL,max_mutation_map_to_gene_level_score_SNV_INDEL,average_the_shortest_path_length_SNV_INDEL,min_the_shortest_path_length_SNV_INDEL,min_rwr_normal_P_value_SNV_INDEL,median_rwr_normal_P_value_SNV_INDEL,cancer_gene_exact_match_drug_target_ratio_SNV_INDEL,average_mutation_pathogenicity_SNV_INDEL,max_mutation_pathogenicity_SNV_INDEL)
fff <-org_gene_tissue[,18:742]
f_addition <- org_gene_tissue%>% dplyr::select(Drug_chembl_id_Drug_claim_primary_name,paper_sample_name)
f_write <-bind_cols(f_feature,fff,f_addition)
write.table(f_write,"09_sample_feature_used.txt" ,row.names = F, col.names = T,quote =F,sep="\t")