# import prefixcommons as pc
from linkml_runtime import SchemaView
import pandas as pd

# todo how to remember the yaml_dumper import
from linkml_runtime.dumpers import yaml_dumper

# todo add indicator of whether the range for each row is a class or a type

memorable = "linkml:meta.yaml"
# todo how to remember what case to use?
selected_element = "slot_definition"
# selected_element = "prefix"

expanded = "https://w3id.org/linkml/meta.yaml"

first_col = f"{selected_element}_slot"

meta_view = SchemaView(expanded)


def element_to_is_dict(view: SchemaView, element):
    eis = view.class_induced_slots(element)
    # todo why is replacing whitespace with an underscore necessary? for broad mappings etc
    #  or use alias instead?
    eis_names = [i.name.replace(" ", "_") for i in eis]
    eis_dict = dict(zip(eis_names, eis))
    eis_names.sort()
    return eis_dict, eis_names


# todo: how to immediately parse the two items out (from a tuple?)
sis_dict, sis_names = element_to_is_dict(meta_view, "slot_definition")
eis_dict, eis_names = element_to_is_dict(meta_view, selected_element)

lod = []
type_dict = {}
type_tally = {}
for en in eis_names:
    ev = eis_dict[en]
    current_dict = {first_col: en}
    for sn in sis_names:
        if sn in ev:
            if ev[sn]:
                if sn in type_dict:
                    type_tally[sn] = type_tally[sn] + 1
                else:
                    type_dict[sn] = sis_dict[sn].range
                    type_tally[sn] = 1
                final = ""
                # todo might want special handling for examples
                # somehow the X_definitions have their names cast to strings
                if sis_dict[sn].multivalued and sis_dict[sn].range in [
                    "string",
                    "class_definition",
                    "slot_definition",
                    "subset_definition",
                    "uri",
                    "uriorcurie",
                ]:
                    final = "|".join(ev[sn])
                else:
                    final = ev[sn]
                current_dict[sn] = final
                if sn == "range":
                    current_range_name = ev[sn]
                    cr_obj = meta_view.get_element(current_range_name)
                    cr_obj_type = type(cr_obj).class_name
                    current_dict["Z_range_type"] = cr_obj_type
    lod.append(current_dict)
df = pd.DataFrame(lod)

col_names = list(df.columns)
col_names.remove(first_col)
col_names.sort()
col_names = [first_col] + col_names
df = df[col_names]
df.to_csv("get_element_slots.tsv", sep="\t", index=False)

type_frame = pd.DataFrame(list(type_dict.items()), columns=["slot", "range"])
tally_frame = pd.DataFrame(list(type_tally.items()), columns=["slot", "count"])
# print(type_frame)
type_frame.to_csv("slot_types.tsv", sep="\t", index=False)
# print(tally_frame)
tally_frame.to_csv("slot_usage_tally.tsv", sep="\t", index=False)

# todo attempt to get URL for meta.yaml from "linkml:meta.yaml" alone
# Slot: default_curi_maps
# ordered list of prefixcommon biocontexts to be fetched to resolve id prefixes and inline prefix variables
# meta_url = pc.expand_uri(memorable)
# print(meta_url)

# prefix = "linkml"
# prefix_expansion = "https://w3id.org/linkml/"
# w3id_expansion = "https://linkml.github.io/linkml-model/linkml/meta.yaml"

# todo: why are some of these file NOT imported into meta.yaml?
# https://github.com/linkml/linkml-model/tree/main/linkml_model/model/schema
# datasets.yaml
# meta.yaml
# validation.yaml

# https://linkml.github.io/linkml-model/linkml/meta.yaml
# imports:
#   - linkml:types
#   - linkml:mappings
#   - linkml:extensions
#   - linkml:annotations

# annotations.yaml
# extensions.yaml
# mappings.yaml
# types.yaml
