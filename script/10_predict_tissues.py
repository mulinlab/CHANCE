import pandas as pd
from xgboost import XGBRegressor
import pickle

dataset = pd.read_table("../output/09_sample_feature_used.txt.gz")
dataset.head
X= dataset.iloc[:,0:736]

model = pickle.load(open("../data/CHANCE.dat", "rb"))
Y_pred=model.predict(X)
dataset['predict_AUC']=Y_pred

# dataset.to_csv("../output/10_sample_drug_predict.txt",sep="\t",index=None)


key_info = dataset.loc[:, ['Drug_chembl_id_Drug_claim_primary_name','paper_sample_name','predict_AUC']].values
key_info1 = pd.DataFrame(key_info)
key_info1.columns=['Drug_chembl_id_Drug_claim_primary_name','paper_sample_name','predict_AUC']
key_info1.to_csv("../output/10_sample_drug_predict_key_info.txt",sep="\t",index=None)
