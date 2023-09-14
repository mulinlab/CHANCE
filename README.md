CHANCE
===
CHANCE is a machine-learning algorithm for repurposing non-oncology drugs to cancer treatment. It first builds a subnetwork to connected drug targets and patient-specific driver mutations (which are usually derived from whole-genome sequencing), then predicts the response of the patient to FDA approved non-oncology drugs by combining multiple evidences, such as pathogenic scores of mutations, network proximity between drug targets and driver genes, and specificity of drug-target interactions. The personalized prediction of CHANCE makes its result  interpretable and can accommodate genetic heterogeneity among different cancer patients. To run CHANCE, you only need to provide a file in MAF format which containing all mutations of one patient.  



Required data for CHANCE
===
    All required data for running CHANCE can be downloaded from figshare with link https://figshare.com/, and the /data/ folder same as 

Input file
===
    1. Mutation file
    The mutation file is maf format and compressed, that including columns are: Chr start  end   ref    alt submitted_donor_id    gene  Variant_Classification  Amino_Acid_Change. The example of mutation file is ./input_example/sample.maf.gz.
    2. Oncotree file
    The oncotree file including columns are:submitted_donor_id	oncotree_detail_ID	oncotree_main_tissue. The example of mutation file is ./input_example/sample.maf.gz. The predictable oncotree list in ./input_example/Predictable_oncotree_term.xlsx. If the cancer type were map to oncotree_main_tissue, but can't map to oncotree_detail_ID, the oncotree_main_tissue was filled with oncotree_detail_ID.


Running CHANCE
===
The CHANCE.sh script in ./script/ folder can be used to run a CHANCE. The syntax looks like: 

    bash CHANCE.sh <input_mutation_file> <input_oncotree_file>

Examples
===
To help you get up and running, a few simple examples are included in the `input_example` folder.
To run a standard CHANCE experiment on a simple example network, run this command:

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
