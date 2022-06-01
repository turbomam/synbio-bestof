from linkml_runtime import SchemaView
from linkml_runtime.dumpers import json_dumper

meta_view = SchemaView("https://w3id.org/linkml/meta.yaml")

meta_view.merge_imports()

print(json_dumper.dumps(meta_view.schema, inject_type=True))

meta_view.ind