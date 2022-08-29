import pandas as pd

modifications_file = "target/felix_modifcation_parts.tsv"
curations_file = "target/Celniker_curations.tsv"
blast_annotations_file = "target/blast_annotation_results.tsv"
output_file = "target/merged_modification_data.tsv"

curations_new_col_names = ['element_id', 'SC_curated_gene_name', 'SC_curated_protein_name', 'SC_curated_enzyme_name',
                           'SC_curated_uniprot_id']

blast_annotations_prefix = 'seq2ids_'

# SC_curated_gene_name	SC_curated_protein_name	SC_curated_enzyme_name	SC_curated_uniprot_id	seq2ids_alias
# seq2ids_sacc	seq2ids_blast_db	seq2ids_bitscore	seq2ids_gene_name_1ry	seq2ids_gene_names	seq2ids_organism
# seq2ids_prot_names	seq2ids_prot_function	seq2ids_all_go

tab_sep = "\t"

pd.set_option('display.max_columns', None)

modifications_frame = pd.read_csv(modifications_file, sep=tab_sep)
curations_frame = pd.read_csv(curations_file, sep=tab_sep)

# MODIFICATION
curations_frame.columns = curations_new_col_names
# move the equivalent of the cut command from makefile in here

blast_annotations_frame = pd.read_csv(blast_annotations_file, sep=tab_sep)

# MODIFICATION
oldcols = list(blast_annotations_frame.columns)
#  if not str(i) == "alias"
newcols = [blast_annotations_prefix + i for i in oldcols]
blast_annotations_frame.columns = newcols

first_merge = modifications_frame.merge(right=curations_frame, how="left", left_on="element_id", right_on="element_id")
second_merge = first_merge.merge(right=blast_annotations_frame, how="left", left_on="element_id",
                                 right_on="seq2ids_alias")

second_merge.to_csv(output_file, sep=tab_sep, index=False)
