CHANCE
===
CHANCE is a machine-learning algorithm for repurposing non-oncology drugs to cancer treatment. It first builds a subnetwork to connected drug targets and patient-specific driver mutations (which are usually derived from whole-genome sequencing), then predicts the response of the patient to FDA approved non-oncology drugs by combining multiple evidences, such as pathogenic scores of mutations, network proximity between drug targets and driver genes, and specificity of drug-target interactions. The personalized prediction of CHANCE makes its result  interpretable and can accommodate genetic heterogeneity among different cancer patients.


Required data for CHANCE
===
All the required data for running CHANCE can be downloaded from figshare using the following link [https://figshare.com/](https://figshare.com/ndownloader/files/42377139). After downloading, unzip the files using the command `tar -zxvf data.tar.gz`. Make sure to place the /data and /script directories in the same folder
    
Input file
===
- Mutation file

    The mutation file is MAF format and compressed, that including columns are: Chr start  end   ref    alt submitted_donor_id    gene  Variant_Classification  Amino_Acid_Change. The example of mutation file format is ./input_example/sample.maf.gz.
   
- Oncotree file
   
    The oncotree file including columns are: submitted_donor_id	oncotree_detail_ID	oncotree_main_tissue. The example of oncotree file is ./input_example/sample_oncotree.txt. The predictable oncotree list in ./data/Predictable_oncotree_term.xlsx. If the cancer type were mapped to oncotree_main_tissue, but can't map to oncotree_detail_ID, the oncotree_main_tissue was filled with oncotree_detail_ID.


Running CHANCE
===
The CHANCE.sh script in ./script/ folder can run a CHANCE. The syntax looks like: 

    bash CHANCE.sh <input_mutation_file> <input_oncotree_file>

Examples
===
To help you get up and running, a few simple examples are included in the `input_example` folder.
To run a standard CHANCE experiment on a simple example, run this command:

    bash CHANCE.sh ../input_example/sample.maf.gz ../input_example/sample_oncotree.txt


Required modules
===
    Software: TransVar 2.4.1.20180815

    Perl: v5.22.1
    
    R: 3.4.4
        dplyr
        stringr
        tibble
    
    Python: 3.8.5
        pandas: 1.1.3
        xgboost: 1.4.2
        pickle: 4.0
        shap: 0.40.0
