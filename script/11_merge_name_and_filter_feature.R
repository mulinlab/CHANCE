library(dplyr)
library(stringr)
library(Hmisc)
library(reshape2)

Feature <- read.csv("../output/10_feature_importance_shap.txt",na.strings = "",sep="\t")
org1 <- read.table("../output/10_predict_key_info.txt",header=T,sep="\t")
dat <-bind_cols(org1,Feature)
dat <-dat[order(dat$predict_AUC),]

# cutoff_dat <- dat[1:10,]
cutoff_dat <- dat
rownames(cutoff_dat)<-1:nrow(cutoff_dat)
#----------
top10_feature <-function(i){
  features <-t(cutoff_dat[i,4:ncol(cutoff_dat)])%>%data.frame()
  colnames(features)="shap_values"
  features[,c("feature","shap_values_abs")] <-c(rownames(features),abs(features$shap_values))
  rownames(features) <-1:nrow(features)
  features$shap_values_abs <-as.numeric(features$shap_values_abs)
  features <-features[order(-features$shap_values_abs),]
  features$feature <-as.factor(features$feature)
  features$feature <-gsub("_"," ",features$feature)
  features$feature <-capitalize(features$feature) 
  top_feature <-features[1:10,]
  top_feature$drug <-cutoff_dat[i,"Drug_chembl_id_Drug_claim_primary_name"]
  return(top_feature)
}
aa <-lapply(1:nrow(cutoff_dat),top10_feature)
res <-do.call(rbind,aa)
res1 <- res[,c(4,2,1)]
colnames(res1)<-c("Drug_Barcode","Feature")
res1$Feature <-gsub(" SNV INDEL","",res1$Feature)
res1$Feature <-gsub("Average the shortest path length","The average length of shortest paths",res1$Feature)
res1$Feature <-gsub("Min the shortest path length","The minimum length of shortest paths",res1$Feature)
res1$Feature <-gsub("Average effective drug target score","The average score of drug-target interaction",res1$Feature)
res1$Feature <-gsub("Max effective drug target score","The maximum score of drug-target interaction",res1$Feature)
res1$Feature <-gsub("Max mutation pathogenicity","The maximum CADD score of driver mutations",res1$Feature)
res1$Feature <-gsub("Average mutation pathogenicity","The average CADD score of driver mutations",res1$Feature)
res1$Feature <-gsub("Median rwr normal P value","The median empirical P value",res1$Feature)
res1$Feature <-gsub("Min rwr normal P value","The minimum empirical P value",res1$Feature)
res1$Feature <-gsub("Cancer gene exact match drug target ratio","The ratio of shared genes between drug targets and driver genes",res1$Feature)

write.table(res1,"../output/11_top10_features.txt" ,row.names = F, col.names = T,quote =F,sep="\t")

drug_name <- read.csv("../data/Drug_Barcode_name.txt",na.strings = "",sep="\t")
dat1 <- dat[,c(1:3)]
colnames(dat1)[1:2] <-c("Drug_Barcode","sample")
dat2 <-left_join(dat1,drug_name[,1:2],by="Drug_Barcode")
write.table(dat2[,c(1,4,2,3)],"../output/11_rank_drug_predicted_AUC.txt" ,row.names = F, col.names = T,quote =F,sep="\t")