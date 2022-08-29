import pandas as pd

xlsx_file = "/Volumes/GoogleDrive/Shared drives/IARPA Synbio Ontology/SEC_V3_genes_BATCH4.xlsx"
tsv_output = "target/Celniker_curations.tsv"

minimal_cols = ['element_id', 'Standardized gene name', "Sue's Protein name", "Sue's enzyme name", 'Unipro ID']

curations = pd.read_excel(xlsx_file)

minimal_rows = curations.loc[~ curations['element_id'].isna(), minimal_cols]

minimal_rows.to_csv(tsv_output, sep="\t", index=False)

# Index(['msid', 'host_species', 'batch4', 'parts_ptr_id', 'element_id_number',
#        'element_id', 'element', 'element_name', 'Gene Name',
#        'Standardized gene name', 'Sue's Protein name', 'Sue's enzyme name',
#        'Unipro ID', 'Gene Sequence', 'descriptor', 'size', 'position',
#        'aa_change', 'modification_type', 'category', 'subcategory_size',
#        'element_species', 'taxon_id'],
#       dtype='object')
